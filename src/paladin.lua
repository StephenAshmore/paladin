require "global"
require "program_memory"

paladin = Object:extend()

function paladin:new()
	self.memory = {}
	self.registers = {}
	
end

function paladin:bootstrap(prog)
	self.program = assert(prog, "Attempted to load nil program")
	
	-- create registers:
	-- Registers for mathematical operations
	self.registers["MAX"] = 0
	self.registers["MBX"] = 0
	self.registers["MCX"] = 0
	self.registers["MDX"] = 0
	self.registers["MEX"] = 0
	self.registers["MFX"] = 0
	self.registers["MGX"] = 0
	self.registers["MHX"] = 0
	
	-- Misc Registers:
	self.registers["LCX"] = 0 -- Loop Control Register
end


function paladin:go()
	-- emulate
	local advanceNum = 0
	local cmd = ""
	local op1 = nil
	local op2 = nil
	while self.program:good() do
		advanceNum = 1 -- set to 1 in case of unrecognized instruction.
				-- unrecognized instructions will be ignored 1 instruction at a time
		cmd = self.program:next()
				
		if cmd == 'add' then
			op1 = self.program:next(1)
			op2 = self.program:next(2)
			if self.registers[op1] ~= nil then
				local num
				if self.registers[op2] == nil then
					num = op2
				else
					num = self.registers[op2]
				end
				self.registers[op1] = tonumber(self.registers[op1]) + tonumber(num)
			end
			advanceNum = 3
		elseif cmd == 'sub' then
			op1 = self.program:next(1)
			op2 = self.program:next(2)
			if self.registers[op1] ~= nil then
				local num
				if self.registers[op2] == nil then
					num = op2
				else
					num = self.registers[op2]
				end
				self.registers[op1] = tonumber(self.registers[op1]) - tonumber(num)
			end
			advanceNum = 3
		elseif cmd == 'div' then
			op1 = self.program:next(1)
			op2 = self.program:next(2)
			if self.registers[op1] ~= nil then
				local num
				if self.registers[op2] == nil then
					num = op2
				else
					num = self.registers[op2]
				end
				self.registers[op1] = tonumber(self.registers[op1]) / tonumber(num)
			end
			advanceNum = 3
		elseif cmd == 'mul' then
			op1 = self.program:next(1)
			op2 = self.program:next(2)
			if self.registers[op1] ~= nil then
				local num
				if self.registers[op2] == nil then
					num = op2
				else
					num = self.registers[op2]
				end
				self.registers[op1] = tonumber(self.registers[op1]) * tonumber(num)
			end
			advanceNum = 3
		elseif cmd == 'mov' then
			op1 = self.program:next(1)
			op2 = self.program:next(2)
			
			-- make sure op1 is a register, if not ignore entire instruction.
			if self.registers[op1] ~= nil then
				local num = 0
				-- figure out if op2 is a register or number
				if self.registers[op2] ~= nil then
					num = tonumber(self.registers[op2])
				else
					num = tonumber(op2)
				end
				-- move num into the indicated register
				self.registers[op1] = num
			end
			advanceNum = 3
		elseif cmd == 'print' then
			op1 = self.program:next(1)
			
			-- make sure that op1 is a register
			if self.registers[op1] ~= nil then
				print( self.registers[op1] )
			end
			
			advanceNum = 2
		elseif cmd == 'prts' then
			op1 = self.program:next(1)
			print( op1 )
			advanceNum = 2
		end
			
		self.program:advance(advanceNum)
	end
end