Object = require("classic")

function split(str, delim)
	local splitStrings = { }
	local counter = 0
	for s in string.gmatch(str, delim) do
-- 		print ("In split: " .. s)
		splitStrings[counter] = s
		counter = counter + 1
	end
	splitStrings.size = counter
	return splitStrings
end