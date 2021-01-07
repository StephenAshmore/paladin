require "global"

module = Object:extend()

function module:new()
    self.name = 'module'
end

function module:input(data)
    print('Test module data' .. data)
end

function module:output()
    return 'Test module'
end