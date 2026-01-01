--[[
# MIT License
#
# Copyright (c) 2026 Mickaël Canouil
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
]]

--- Extension name constant
local EXTENSION_NAME = 'div-reuse'

--- Load utils module
local utils = require(quarto.utils.resolve_path('_modules/utils.lua'):gsub('%.lua$', ''))

--- Storage for div contents indexed by identifier.
--- @type table<string, table>
local div_contents = {}

--- Track reuse chain to detect circular references.
--- @type table<string, boolean>
local reuse_chain = {}

--- Collect divs with identifiers for later reuse.
--- Stores div content in the div_contents table indexed by the div's identifier.
---
--- @param el pandoc.Div The div element to collect
--- @return pandoc.Div The unchanged div element
local function collect_divs(el)
  if el.identifier ~= '' then
    div_contents[el.identifier] = el.content
  end
  return el
end

--- Find and count divs with identifiers within content.
--- Recursively searches through content to count divs that have identifiers,
--- which helps detect potential issues with reused content.
---
--- @param content table Array of pandoc elements to search through
--- @param ref_id string Reference identifier (currently unused but kept for future use)
--- @return integer Number of divs with identifiers found in the content
local function find_identifiers(content, ref_id)
  --- @type integer Count of divs with identifiers
  local identifier_found = 0
  for _, inner_el in ipairs(content) do
    if inner_el.t == 'Div' and inner_el.identifier ~= '' then
      identifier_found = identifier_found + 1
    end
    if inner_el.content then
      identifier_found = identifier_found + find_identifiers(inner_el.content, ref_id)
    end
  end
  return identifier_found
end

--- Replace div content with content from a referenced div.
--- If a div has a "reuse" attribute, replaces its content with the content
--- from the div identified by that attribute. Warns if the reused content
--- contains divs with identifiers, as this may cause issues. Detects and prevents
--- circular references.
---
--- @param el pandoc.Div The div element to potentially replace
--- @return pandoc.Div The div with replaced content or the original div
local function replace_divs(el)
  if el.attributes['reuse'] then
    --- @type string The identifier of the div to reuse
    local ref_id = el.attributes['reuse']

    -- Check for circular reference
    if reuse_chain[ref_id] then
      utils.log_warning(
        EXTENSION_NAME,
        'Circular reference detected: Div "' .. ref_id ..
        '" is already in the reuse chain. Skipping to prevent infinite loop.'
      )
      return el
    end

    if div_contents[ref_id] then
      -- Add to reuse chain before processing
      reuse_chain[ref_id] = true

      el.content = div_contents[ref_id]
      --- @type integer Number of divs with identifiers in reused content
      local total_identifiers = find_identifiers(el.content, ref_id)
      if total_identifiers > 0 then
        utils.log_warning(
          EXTENSION_NAME,
          'Div "' .. ref_id .. '" has been reused but contains ' ..
          total_identifiers .. ' Div(s) with an identifier.'
        )
      end

      -- Remove from reuse chain after processing
      reuse_chain[ref_id] = nil
    end
  end
  return el
end

--- Pandoc filter configuration.
--- Defines a two-pass filter:
--- 1. First pass collects all divs with identifiers
--- 2. Second pass replaces divs with reuse attributes
--- @type table
return {
  { Div = collect_divs },
  { Div = replace_divs }
}
