local logger = require('reactor-controller.logger')
local utils = require('reactor-controller.utilities')
local cs = require('reactor-controller.control_signals')


CONTROL_SIGNALS = nil
LOGGER = logger.Logger:new()

local function scram_handler()
    LOGGER:info('Registered SCRAM handler. Waiting for signals controller to initialize...')
    while CONTROL_SIGNALS == nil do
    end

    LOGGER:info('Signals controller initialized! Listening for RS SCRAM events...')
    while true do
        os.pullEvent('redstone')

        if (CONTROL_SIGNALS:get_in_signal('scram_state')) then
            LOGGER:critical('SCRAM was triggered! Stopping early!')
            CONTROL_SIGNALS:safed_scram()
            break
        end
    end
end

local function terminate_handler()
    LOGGER:info('Registered TERMINATE handler. Waiting for signals controller to initialize...')
    while CONTROL_SIGNALS == nil do
    end

    LOGGER:info('Signals controller initialized! Listening for OS TERMINATE events...')
    while true do
        os.pullEvent('terminate')

        if (CONTROL_SIGNALS:get_in_signal('scram_state')) then
            LOGGER:critical('TERMINATE was triggered! Stopping early!')
            CONTROL_SIGNALS:safed_scram()
            break
        end
    end
end

local function repl_control_loop()
    -- Init signal controller
    local signal_inputs = {
        scram_state = colors.black
    }

    local signal_outputs = {
        operating_indicator = colors.green,
        maintenance_indicator = colors.yellow,
        initializing_indicator = colors.blue,
        scram_indicator = colors.orange,
    }

    CONTROL_SIGNALS = cs.ControlSignals:new(
        'right',
        signal_inputs,
        signal_outputs
    )

    -- Clear Screen
    utils.reset_screen()

    -- Init Modem
    local net_port = 7082
    local modem = utils.init_modem(net_port)

    -- Fetch all available nodes on the network
    local all_peripherals = modem.getNamesRemote()

    -- Discover reactors
    local reactors = utils.wrap_peripherals_of_type('deepresonance:generator_part', all_peripherals)
    local reactor = reactors[1]
    LOGGER:debug('Found ' .. #reactors .. ' reactors!')
    LOGGER:warn('Implicitly selecting reactor ' .. reactor.id .. ' as the primary controllee.')

    -- Discover pedestals
    local pedestals = utils.wrap_peripherals_of_type('deepresonance:pedestal', all_peripherals)
    LOGGER:debug('Found ' .. #pedestals .. ' pedestals!')

    -- Discover Barrels
    local barrels = utils.wrap_peripherals_of_type('sophisticatedstorage:limited_barrel', all_peripherals)
    local crystals_barrel = barrels[1]
    LOGGER:debug('Found ' .. #barrels .. ' barrels!')

    -- Discover Energy Cell
    local energy_cells = utils.wrap_peripherals_of_type('energyCell', all_peripherals)
    local battery = energy_cells[1]
    LOGGER:warn('Auto-selecting ' .. battery.id .. ' as the default battery bank for reactor: ' .. reactor.id .. '!')

    -- Put Reactor into maintenance mode
    CONTROL_SIGNALS:safed_maintenance()

    -- Push RC's to pedestals
    for _, p in pairs(pedestals) do
        local push_amount = 4
        LOGGER:debug('Pushing ' .. push_amount .. ' RC\'s to ' .. p.id)
        p.pullItems(crystals_barrel.id, 1, push_amount)
    end

    os.sleep(5)

    CONTROL_SIGNALS:set_out_signal('maintenance_indicator', false)
    LOGGER:info('RC refil to pedestals complete!')

    -- Initiate control sequence
    CONTROL_SIGNALS:set_out_signal('operating_indicator', true)
    LOGGER:info('Control signal established succesfully!')
    os.sleep(15)

    -- Begin REPL Sequence
    CONTROL_SIGNALS:set_out_signal('initializing_indicator', false)
    LOGGER:info('Reactor startup completed succesfully!')
    os.sleep(2.5)

    local last_rf = 0
    utils.reset_screen()

    while true do
        local this_rf = battery:getEnergy()
        local capacity = battery:getEnergyCapacity()
        if(this_rf == nil) or (capacity == nil) then
            os.sleep(0.5)
            goto continue
        end
        local delta = (this_rf - last_rf)
        local capacity_perc = (this_rf / capacity) * 100

        term.clear()
        term.setCursorPos(1, 1)
        print('Capacity: ' .. this_rf .. ' RF / ' .. capacity .. ' RF (' .. capacity_perc .. '%)')
        print('RF Last-Tick: ' .. last_rf .. ' RF')
        print('dRF: ' .. delta .. ' RF/t')

        last_rf = this_rf
        ::continue::
    end
end

local function main()
    parallel.waitForAny(repl_control_loop, scram_handler, terminate_handler)
end

return { main = main }
