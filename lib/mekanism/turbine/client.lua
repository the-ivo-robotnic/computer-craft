local utils = require("../utils");

Turbine = {};
Turbine.__index = Turbine;
Turbine.Peripheral_Name = "turbineValve";

function Turbine:new(peripheral_id)
    -- Setup other object properties
    self.energy_production_rate = {};

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

function Turbine:get_energy_production_rate()
    self:assert_device();

    local current_time_s = os.clock();
    local current_energy_fe = utils.joules_to_fe(self.device.getEnergy())

    if (self.energy_production_rate.last_time_s == nil) then
        self.energy_production_rate.last_time_s = current_time_s;
        self.energy_production_rate.last_energy_fe = current_energy_fe;
    else
        local time_delta_t = (current_time_s - self.energy_production_rate.last_time_s) * 20;
        local energy_delta_fe = current_energy_fe - self.energy_production_rate.last_energy_fe;
        self.energy_production_rate.last_production_rate = energy_delta_fe / time_delta_t;
    end

    return self.energy_production_rate.last_production_rate;
end

return { Turbine = Turbine };
