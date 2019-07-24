module("util", package.seeall)

--for k, v in pairs(package.loaded) do
--	print(k, v)
--end

---
-- Splits a string according to a given split pattern.
-- Compatibility: Lua-5.1
-- SOURCE: function split(str, pat) in: http://lua-users.org/wiki/SplitJoin
-- TODO: StringSplit should have a common textadept/lua place to live
-- @param str The string to be splitted
-- @param pat The splitt pattern.
-- @return array containing the splitted string without pat parts.
-- @usage stringSplit('c:\\windows\\system32\\kernel32.dll', '[^\\/]+')
function stringSplit(str, pat)
	local t = {}
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

