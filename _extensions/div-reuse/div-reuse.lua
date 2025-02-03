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

local function find_identifiers(content, ref_id)
  local identifier_found = 0
  for _, inner_el in ipairs(content) do
    if inner_el.t == "Div" and inner_el.identifier ~= "" then
      identifier_found = identifier_found + 1
    end
    if inner_el.content then
      identifier_found = identifier_found + find_identifiers(inner_el.content, ref_id)
    end
  end
  return identifier_found
end

function replace_divs(el)
  if el.attributes["reuse"] then
    local ref_id = el.attributes["reuse"]
    if div_contents[ref_id] then
      el.content = div_contents[ref_id]
      local total_identifiers = find_identifiers(el.content, ref_id)
      if total_identifiers > 0 then
        quarto.log.warning(
          '[div-reuse] Div "' ..
          ref_id ..
          '" has been reused but contains ' .. total_identifiers .. ' Div(s) with an identifier.'
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
