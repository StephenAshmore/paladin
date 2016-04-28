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
				elseif tempMemory[i] == 'prts' then
					self.instructions[position] = tempMemory[i]
					self.instructions[position+1] = ""
					for j = 1, tempMemory.size - 1 do
						if j == 1 then
							self.instructions[position+1] = tempMemory[j]
						else
							self.instructions[position+1] = self.instructions[position+1] .. " " .. tempMemory[j]
						end
					end
					print("Just created a string for the prts instruction: " .. self.instructions[position+1])
					position = position + 2
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

function program:next(offset)
	if offset == nil or offset + self.programCounter > self.size then
		offset = 0
	end
	return self.instructions[self.programCounter + offset]
end

function program:advance(num)
	if num == nil then
		num = 1
	end
	
	self.programCounter = self.programCounter + num
	
	if self.programCounter >= self.size then
		-- send terminate signal
-- 		return nil
		-- probably not needed, will rely on other method
	end
end

function program:good()
	if self.programCounter >= self.size then
		return false
	else
		return true
	end
end