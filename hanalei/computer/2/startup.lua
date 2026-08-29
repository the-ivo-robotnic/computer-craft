local mk_turbine = require("usr.programs.mekanism.turbine");

YIELD_TIME = 1;        -- ticks
TICKS_PER_SECOND = 20; -- Average server ticks per second

function setup_term()
    term.clear();
    term.setCursorPos(1, 1);
end

function add_route(route)
    shell.setPath("" .. shell.path() .. ":" .. route);
    return shell.path();
end

function yield_t(time)
    time = time or YIELD_TIME
    sleep(time / TICKS_PER_SECOND);
end

add_route("/usr/programs");
setup_term();

local turbine = mk_turbine.Turbine:new();

while true do
    local current_time_s = os.clock();
    local current_energy_fe = joules_to_fe(energy_cube.getEnergy());

    if energy_rate.last_time_s == nil then
        energy_rate.last_time_s = current_time_s;
        energy_rate.last_energy_fe = current_energy_fe;
    else
        local time_delta_t = (current_time_s - energy_rate.last_time_s) * 20;
        local energy_delta_fe = current_energy_fe - energy_rate.last_energy_fe;
        energy_rate.last_rate_fe_t = energy_delta_fe / time_delta_t;

        setup_term();
        print(
            "Reactor Buffer:\n" ..
            "\t\tCurrent Fill: " .. (current_energy_fe / 10 ^ 6) .. " MFE\n" ..
            "\t\tFill Rate: " .. (energy_rate.last_rate_fe_t / 10 ^ 6) .. " MFE/t"
        );

        energy_rate.last_time_s = current_time_s;
        energy_rate.last_energy_fe = current_energy_fe;
    end

    sleep(1 / 20);
end

-- shell.openTab("ui-demo");
-- shell.openTab("reactor-monitor");
-- shell.run("turbine-monitor");
