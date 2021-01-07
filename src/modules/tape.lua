require "modules.module"

tape = module:extend()

function tape:new(size)
    self.name = 'tape'
    self.location = 0
    self.size = size
    self.tape = {}
    for i = 0, size, 1 do
        self.tape[i] = 0
    end
end

function tape:input(data)
    self.tape[self.location] = data
    self.location = self.location + 1
end

function tape:output()
    local val = self.tape[self.location]
    self.location = self.location + 1
    return val
end

function tape:seek(location)
    self.location = location
end

function tape:step(offset)
    self.location = self.locaton + offset
end
