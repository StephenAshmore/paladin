require "global"
require "program_memory"

paladin = Object:extend()

function paladin:new()
	self.memory = {}
	self.opcodes = {}
	self.registers = {}
	
end

function paladin:bootstrap(prog)
	self.program = assert(prog, "Attempted to load nil program")
	
end


function paladin:go()
	-- emulate
	print "Hello from cpu"
	while true do
		break
	end
end