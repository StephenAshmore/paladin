require "global"
require "program_memory"
require "modules.tape"

paladin = Object:extend()

function paladin:new()
	self.labels = {}
	self.memory = {}
	self.modules = {}
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

	-- Modules:
	local t = tape(4)
	print(t.name)
	t:input(1)
	t:seek(0)
	print(t:output())
	self.modules["TAPE"] = tape(500)
	print(self.modules["TAPE"]:output())
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
		elseif cmd == 'modules' then
			outString = ': '
			for name, moduleValue in pairs(self.modules) do
				outString = outString .. name .. ' ' .. moduleValue.name .. ' '
			end
			print(outString)
		elseif cmd == 'tape' then
			local cmd2 = string.lower(self.program:next(1))
			if cmd2 == 'input' then
				op1 = self.program:next(2)
				op1 = self.registers[op1] or op1
				self.modules['TAPE']:input(op1)
				advanceNum = 3
			elseif cmd2 == 'output' then
				op1 = self.program:next(2)
				if self.registers[op1] ~= nil then
					self.registers[op1] = self.modules['TAPE']:output()
				end
				advanceNum = 3
			elseif cmd2 == 'seek' then
				op1 = self.program:next(2)
				op1 = self.registers[op1] or op1
				self.modules['TAPE']:seek(tonumber(op1))
				advanceNum = 3
			elseif cmd2 == 'step' then
				self.modules['TAPE']:step()
				advanceNum = 2
			end
		end
			
		self.program:advance(advanceNum)
	end
end