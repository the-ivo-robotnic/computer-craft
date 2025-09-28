--
-- Data Analysis Utilities
--
local function ternary(condition, true_expression, false_expression)
    if condition then
        return true_expression
    else
        return false_expression
    end
end

local function table_dump(o)
    for key, value in pairs(o) do
        print('  ', key, value)
    end
end

local function table_dump_to_json(o, file)
    file.write('{\n')
    for key, value in pairs(o) do
        local value_type = type(value)

        if (value_type == 'table') then
            file.write('"' .. key .. '": ')
            table_dump_to_json(value, file)
        else
            file.write('"' .. key .. '": ' .. '"' .. tostring(value) .. '",\n')
        end
    end
    file.write('}')
end

--
-- Hardware Utilities
--
local function get_peripherals_by_type(type, o)
    local peripherals = {}

    for _, value in pairs(o) do
        if string.find(value, type) then
            table.insert(peripherals, value)
        end
    end

    return peripherals
end

local function wrap_peripherals_of_type(type, o)
    local new_peripherals = {}
    local peripheral_ids = get_peripherals_by_type(type, o)

    if #peripheral_ids == 0 then
        error('Could not find peripheral of type \'' .. type .. '\' on the network! Check wired connections!')
    end

    for _, id in pairs(peripheral_ids) do
        table.insert(new_peripherals, peripheral.wrap(id))
        new_peripherals[#new_peripherals].id = id
    end

    return new_peripherals
end

local function init_modem(net_port)
    local net_port = net_port or 7000
    local modem = peripheral.find('modem')
    modem.open(0)
    print('Server listening for peripherals at 0.0.0.0:' .. net_port)
    return modem
end

--
-- Screen Drawing Utilities
--
local function reset_screen()
    term.clear()
    term.setCursorPos(1, 1)
    term.setCursorBlink(false)
end


return {
    ternary = ternary,
    table_dump = table_dump,
    table_dump_to_json = table_dump_to_json,
    get_peripherals_by_type = get_peripherals_by_type,
    wrap_peripherals_of_type = wrap_peripherals_of_type,
    init_modem = init_modem,
    reset_screen = reset_screen
}
