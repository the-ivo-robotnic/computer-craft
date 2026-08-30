-- Package Path Modification
package.path = package.path .. ";/usr/lib/?";
package.path = package.path .. ";/usr/lib/?.lua";
package.path = package.path .. ";/usr/lib/?/init.lua";

-- Startup

local mk_turbine = require("mekanism.turbine");
local turbine = mk_turbine.Turbine:new();
local utils = require("utils");
local capacity = turbine:get_energy_max();
local capacity_fe, capacity_unit = capacity:as_fe(true);

while true do
    local fill = turbine:get_energy_fill();
    local fill_fe, fill_unit = fill:as_fe(true);
    local fill_perc = utils.round_float(turbine.device.getEnergyFilledPercentage() * 100, 1);
    local rate, unit = turbine:get_energy_production_rate();

    term.clear();
    term.setCursorPos(1, 1);
    print(
        "Turbine:\n" ..
        "\tProducing: " .. utils.round_float(rate), unit .. "\n" ..
        "\tBuffer:    " .. utils.round_float(fill_fe), fill_unit .. " / " .. capacity_fe, capacity_unit .. "\n" ..
        "\tBuffer Filled: " .. utils.round_float(fill_perc) .. "%\n"
    );

    sleep(1 / 20);
end
