require "global"
require "paladin"
require "program_memory"

-- Verify argument is passed in
if arg[1] == nil then
    print('You must pass a file to the program as the first argument.')
else
    -- **Main Program**
    -- Create the Emulator object
    print "Creating CPU emulator."
    local cpu = paladin()

    -- Load the program
    local prog = program()
    prog:load(arg[1])

    -- Pass the program to the emulator and go
    cpu:bootstrap(prog)

    cpu:go()
end