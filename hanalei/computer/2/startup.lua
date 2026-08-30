package.path = package.path .. ";/usr/lib/?";
package.path = package.path .. ";/usr/lib/?.lua";
package.path = package.path .. ";/usr/lib/?/init.lua";

local energy = require("energy");

local EnergyUnit = energy.EnergyUnit;
local EnergyValue = energy.EnergyValue;

term.clear();
term.setCursorPos(1, 1);

local val = EnergyValue:new(5244, EnergyUnit.JOULES);

print(val:as_fe(true));
print(val:as_j(true));
