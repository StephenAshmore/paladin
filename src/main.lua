require "global"
require "paladin"
require "program_memory"
-- Functions


-- **Main Program**
-- Create the Emulator object
print "Creating CPU emulator."
local cpu = paladin()

-- Load the program
local prog = program()
prog:load("../demos/os.dat")

-- Pass the program to the emulator and go
cpu:bootstrap(prog)

cpu:go()