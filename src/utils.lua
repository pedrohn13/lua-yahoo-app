function split(str, _separator) -- if no separator is used, " " is used
  words = {}
  separator = _separator or " "
  new_str = str
  while true do
    _index = string.find(new_str, separator) -- index of the separator
    workaround = true -- workaround to use continue statement

    if _index == nil then -- end of string or no separator
      table.insert(words, string.sub(new_str, 1))
      return words;
    end

  if _index == 1 then -- separator begins the string
      table.insert(words, "")
      new_str = string.sub(new_str, 2)
      workaround = false
  end

  if workaround then -- if separator is not on the beginning of the string
    -- the program enters this
    table.insert(words, string.sub(new_str, 1, _index -1))
    new_str = string.sub(new_str, _index + 1)
  end

  end
  return words
end

function shallow_clone_of(table_to_clone)
    local cloned_table = {}
    for k,v in pairs(table_to_clone) do
        cloned_table[k] = v
    end

    return cloned_table
end

local UNICODE_REGEX = "([%z\1-\127\194-\244][\128-\191]*)"
local UNICODE_MASK = 195
local ULOWER_LEFT = 161
local ULOWER_RIGHT = 190

local function uppercase(c)
    local upperC = ''
    if string.byte(string.sub(c, 1)) == UNICODE_MASK then
        local secondChar = string.byte(string.sub(c, 2))
        if ULOWER_LEFT <= secondChar and secondChar <= ULOWER_RIGHT then
            upperC = string.char(UNICODE_MASK) .. string.char(secondChar - 0x20)
            return upperC
        end
    end
    return string.upper(c)
end

function stringUpper(str)
	 upperString = ''
	 for uchar in string.gfind(str, UNICODE_REGEX) do
        upperString = upperString .. uppercase(uchar)
    end
    return upperString
end
