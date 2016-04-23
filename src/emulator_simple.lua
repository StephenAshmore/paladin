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

function loadProgram(programMemory, file, labels)
-- 	Bootstrap the OS, or default program into memory:
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
					labels[tempMemory[i+1]] = position
-- 					print("Found a label at " .. position .. " called " .. tempMemory[i+1])
					break
				else
-- 					print("Splitting results " .. tempMemory[i])
					programMemory[position] = tempMemory[i]
					position = position + 1
				end
			end
		end
	end
	programMemory.size = position
end

function createMemory(Memory)
	-- create the size of the table:
	Memory.size = 64
	for i = 0, Memory.size - 1 do
		Memory[0] = ""
	end
end

-- Emulator Program:

-- Create counters and pointers.
PC = 0
InterruptPeriod = 10
Counter = InterruptPeriod

Cycles = {
	['load'] = 2,
	['add'] = 4,
	['sub'] = 4,
	['mv'] = 4,
	['print'] = 2,
	['label'] = 2,
	['goto'] = 2,
	['je'] = 4,
	['jg'] = 4,
	['done'] = 1,
	['printstr'] = 2,
	['div'] = 6,
	['mult'] = 5,
	['jge'] = 4,
	['jle'] = 4,
	['jl'] = 4
	
}

registers = {
	["r1"] = 0,
	['r2'] = 0,
	['r3'] = 0,
	['r4'] = 0,
	['r5'] = 0,
	['r6'] = 0,
	['r7'] = 0,
	['r8'] = 0
}

labels = { }

Memory = { }

programMemory = {}

-- TODO: Ram emulation

-- Load OS or whatever.
loadProgram(programMemory, "os.dat", labels)


while true do
-- 	print ("Program counter = " .. PC)
	local operation = programMemory[PC]
-- 	print ("Operation = " .. operation)
	
	PC = PC + 1
	Counter = Counter - Cycles[operation]
	
	if operation == 'add' then
		registers[programMemory[PC]] = tonumber(registers[programMemory[PC]]) + tonumber(registers[programMemory[PC+1]])
		PC = PC + 2
	elseif operation == 'sub' then
		registers[programMemory[PC]] = tonumber(registers[programMemory[PC]]) - tonumber(registers[programMemory[PC+1]])
		PC = PC + 2
	elseif operation == 'div' then
		registers[programMemory[PC]] = tonumber(registers[programMemory[PC]]) / tonumber(registers[programMemory[PC+1]])
		PC = PC + 2
	elseif operation == 'mult' then
		registers[programMemory[PC]] = tonumber(registers[programMemory[PC]]) * tonumber(registers[programMemory[PC+1]])
		PC = PC + 2
	elseif operation == 'load' then
		registers[programMemory[PC]] = tonumber(programMemory[PC+1])
		PC = PC + 2
	elseif operation == 'mv' then
		registers[programMemory[PC]] = registers[programMemory[PC+1]]
		PC = PC + 2
	elseif operation == 'print' then
		print(registers[programMemory[PC]])
		PC = PC + 1
	elseif operation == 'goto' then
		local gotoLoc = programMemory[PC]
		PC = labels[gotoLoc]
-- 		print("GoTo PC = " .. PC)
	elseif operation == 'je' then
		if registers[programMemory[PC]] == registers[programMemory[PC+1]] then
			PC = labels[programMemory[PC+2]]
		else
			PC = PC + 3
		end
	elseif operation == 'jg' then
		if registers[programMemory[PC]] > registers[programMemory[PC+1]] then
			PC = labels[programMemory[PC+2]]
		else
			PC = PC + 3
		end
	elseif operation == 'jl' then
		if registers[programMemory[PC]] < registers[programMemory[PC+1]] then
			PC = labels[programMemory[PC+2]]
		else
			PC = PC + 3
		end
	elseif operation == 'jle' then
		if registers[programMemory[PC]] <= registers[programMemory[PC+1]] then
			PC = labels[programMemory[PC+2]]
		else
			PC = PC + 3
		end
	elseif operation == 'jge' then
		if registers[programMemory[PC]] >= registers[programMemory[PC+1]] then
			PC = labels[programMemory[PC+2]]
		else
			PC = PC + 3
		end
	elseif operation == 'done' then
		break
	elseif operation == 'printstr' then
		print(programMemory[PC])
		PC = PC + 1
	elseif operation == 'loadm' then
		-- load something from memory to a register
		
	elseif operation == 'pushm' then
		-- push something into memory
		
	end
	
	if Counter <= 0 then
		
		-- check if we have an interrupt.
		Counter = Counter + InterruptPeriod
	end
end
