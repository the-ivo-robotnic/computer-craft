local energy = require("energy");

local EnergyUnit = energy.EnergyUnit;
local EnergyValue = energy.EnergyValue;

Turbine = {};
Turbine.__index = Turbine;
Turbine.Peripheral_Name = "turbineValve";

function Turbine:new(peripheral_id)
    -- Setup other object properties
    self.production_rate = {
        last_time = nil, -- seconds
        last_fill = nil, -- EnergyValue
    };

    -- Setup the peripheral device
    if peripheral_id == nil then
        self.device = peripheral.find(self.Peripheral_Name);
    else
        local peripheral_name = self.Peripheral_Name .. "_" .. peripheral_id;
        self.device = peripheral.wrap(peripheral_name)
    end
    self:assert_device();

    return self;
end

function Turbine:assert_device()
    if (self.device == nil) then
        local msg = "Turbine object with prefix \'" .. self.Peripheral_Name .. "\'is not connected!";
        error("Turbine object with prefix \'" .. self.Peripheral_Name .. "\'is not connected!");
    end
end

function Turbine:get_energy_fill()
    self:assert_device();
    return EnergyValue:new(self.device.getEnergy(), EnergyUnit.JOULES);
end

function Turbine:get_energy_max()
    self:assert_device();
    return EnergyValue:new(self.device.getMaxEnergy(), EnergyUnit.JOULES);
end

function Turbine:get_energy_production_rate()
    self:assert_device();

    local curr_time = os.clock();                                                    -- seconds
    local curr_energy = EnergyValue:new(self.device.getEnergy(), EnergyUnit.JOULES); -- EnergyValue

    if (self.production_rate.last_time == nil) then
        self.production_rate.last_time = curr_time;
        self.production_rate.last_fill = curr_energy;
        return 0, EnergyUnit.NONE;
    else
        local time_delta_t = (curr_time - self.production_rate.last_time) * 20;
        local energy_delta = curr_energy - self.production_rate.last_fill;
        local energy_delta_fe, energy_delta_unit = energy_delta:as_fe(true);
        local energy_delta_fe_t = energy_delta_fe / time_delta_t;

        self.production_rate.last_time = curr_time;
        self.production_rate.last_fill = curr_energy;

        return energy_delta_fe_t, (energy_delta_unit .. "/t");
    end
end

return { Turbine = Turbine };
