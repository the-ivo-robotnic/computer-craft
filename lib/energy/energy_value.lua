local utils = require("utils");
local enums = require("energy.enums");
local EnergyUnit = enums.EnergyUnit;
local SIUnit = enums.SIUnit;

EnergyValue = {};
EnergyValue.__index = EnergyValue;

function EnergyValue:new(value, unit)
    local energy_value = {};
    energy_value.value = value;
    energy_value.unit = unit or DEFAULT_ENERGY_UNIT;

    energy_value.conversion_table = {
        J_TO_FE = 0.4,
        FE_TO_J = 2.5,
    };

    return setmetatable(energy_value, EnergyValue);
end

function EnergyValue:__add(value)
    return EnergyValue:new(self:as_fe() + value:as_fe(), EnergyUnit.FORGE_ENERGY);
end

function EnergyValue:__sub(value)
    return EnergyValue:new(self:as_fe() - value:as_fe(), EnergyUnit.FORGE_ENERGY);
end

function EnergyValue:__mul(value)
    return EnergyValue:new(self:as_fe() * value:as_fe(), EnergyUnit.FORGE_ENERGY);
end

function EnergyValue:__div(value)
    return EnergyValue:new(self:as_fe() / value:as_fe(), EnergyUnit.FORGE_ENERGY);
end

function EnergyValue:__tonumber()
    return self.value;
end

function EnergyValue:__tostring()
    local scale, unit = self:autoscale();
    return utils.round_float(self.value / scale) .. " " .. unit;
end

function EnergyValue:__concat(other)
    return tostring(self) .. tostring(other);
end

function EnergyValue:autoscale(unit)
    local unit = unit or self.unit;

    for _, si_unit in pairs(SIUnit) do
        local scale = si_unit[1];
        local symbol = si_unit[2];
        local value = math.abs(math.floor(self.value / scale));
        local digits = #tostring(value);

        if (value > 0 and digits < 4 and digits >= 1) then
            return scale, symbol .. unit;
        end
    end

    return 1, unit;
end

function EnergyValue:convert_to(unit, autoscale)
    local autoscale = autoscale or false;

    if (self.unit == unit) then
        if autoscale then
            local scale, unit = self:autoscale(unit);
            return (self.value / scale), unit;
        else
            return self.value, self.unit;
        end
    end

    local conversion_name = self.unit .. "_TO_" .. unit;
    local conversion_scale = self.conversion_table[conversion_name];
    local value = self.value * conversion_scale;

    if autoscale then
        local scale, unit = self:autoscale(unit);
        return (value / scale), unit;
    else
        return value, unit;
    end
end

function EnergyValue:as_j(autoscale)
    return self:convert_to(EnergyUnit.JOULES, autoscale);
end

function EnergyValue:as_fe(autoscale)
    return self:convert_to(EnergyUnit.FORGE_ENERGY, autoscale);
end

return {
    EnergyValue = EnergyValue,
};
