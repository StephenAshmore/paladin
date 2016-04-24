require("global")


program = Object:extend()


function program:new()
	self.instructions = {}
	self.labels = {}
	self.size = 0
	self.programCounter = 0
end

function program:load(file)
	local loader = io.open ( file, "r" )
	
	local position = 0
	local line = ""
	while line ~= nil do
		line = loader:read()
		if line ~= nil then
			local tempMemory = split(line, "%S+")
			local i = 0
			for i = 0, tempMemory.size - 1 do
				if tempMemory[i] == 'label' then
					self.labels[tempMemory[i+1]] = position
-- 					print("Found a label at " .. position .. " called " .. tempMemory[i+1])
					break
				else
-- 					print("Splitting results " .. tempMemory[i])
					self.instructions[position] = tempMemory[i]
					position = position + 1
				end
			end
		end
	end
	self.size = position
end