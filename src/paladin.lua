require "global"
require "program_memory"

paladin = Object:extend()

function paladin:new()
	self.labels = {}
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
	self.registers["TCX"] = 0 -- Test Control Register
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
		cmd = string.lower(self.program:next())
				
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
		elseif cmd == 'printall' then
			outString = ''
			for name, register in pairs(self.registers) do
				outString = outString .. '(' .. name .. ',' .. register .. ') '
			end
			print(outString)
		elseif cmd == 'jump' then
			op1 = self.program:next(1)
			self.program:jumpTo(self.program.labels[op1])
			advanceNum = 0
		elseif cmd == 'tjmp' then
			op1 = self.program:next(1)
			if self.registers['TCX'] == 1 then
				self.program:jumpTo(self.program.labels[op1])
				advanceNum = 0
			else
				advanceNum = 2
			end
		elseif cmd == 'fjmp' then
			op1 = self.program:next(1)
			if self.registers['TCX'] == 0 then
				self.program:jumpTo(self.program.labels[op1])
				advanceNum = 0
			else
				advanceNum = 2
			end
		elseif cmd == 'test' then
			op1 = self.program:next(1)
			op2 = self.program:next(2)
			op3 = self.program:next(3)
			op1 = tonumber(self.registers[op1] or op1)
			op3 = tonumber(self.registers[op3] or op3)
			if op2 == '=' then
				if op1 == op3 then
					self.registers['TCX'] = 1
				else
					self.registers['TCX'] = 0
				end
			elseif op2 == '<' then
				if op1 < op3 then
					self.registers['TCX'] = 1
				else
					self.registers['TCX'] = 0
				end
			elseif op2 == '>' then
				if op1 > op3 then
					self.registers['TCX'] = 1
				else
					self.registers['TCX'] = 0
				end
			elseif op2 == '>=' then
				if op1 >= op3 then
					self.registers['TCX'] = 1
				else
					self.registers['TCX'] = 0
				end
			elseif op2 == '<=' then
				if op1 <= op3 then
					self.registers['TCX'] = 1
				else
					self.registers['TCX'] = 0
				end
			elseif op2 == '<>' then
				if op1 ~= op3 then
					self.registers['TCX'] = 1
				else
					self.registers['TCX'] = 0
				end
			end
			advanceNum = 3
		end
			
		self.program:advance(advanceNum)
	end
end