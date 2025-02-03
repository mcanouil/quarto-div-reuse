--[[
# MIT License
#
# Copyright (c) 2025 Mickaël Canouil
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
]]

local div_contents = {}

function collect_divs(el)
  if el.identifier ~= "" then
    div_contents[el.identifier] = el.content
  end
  return el
end

local function update_identifiers(content, ref_id)
  local identifier_modified = 0
  for _, inner_el in ipairs(content) do
    if inner_el.t == "Div" and inner_el.identifier ~= "" then
      inner_el.identifier = inner_el.identifier .. "-" .. div_contents[ref_id .. "-count"]
      identifier_modified = identifier_modified + 1
    end
    if inner_el.content then
      identifier_modified = identifier_modified + update_identifiers(inner_el.content, ref_id)
    end
  end
  return identifier_modified
end

function replace_divs(el)
  if el.attributes["reuse"] then
    local ref_id = el.attributes["reuse"]
    if div_contents[ref_id] then
      el.content = div_contents[ref_id]
      if not div_contents[ref_id .. "-count"] then
        div_contents[ref_id .. "-count"] = 1
      end
      div_contents[ref_id .. "-count"] = div_contents[ref_id .. "-count"] + 1

      local modified_count = update_identifiers(el.content, ref_id)
      if modified_count > 0 then
        quarto.log.warning(
          '[div-reuse] Div "' ..
          ref_id ..
          '" has been reused but contains ' .. modified_count .. ' Div(s) with an identifier.',
          'The identifier(s) have been incremented.'
        )
      end
    end
  end
  return el
end

return {
  { Div = collect_divs },
  { Div = replace_divs }
}
