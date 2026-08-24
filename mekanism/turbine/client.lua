Turbine = {};
Turbine.__index = Turbine;
Turbine.Peripheral_Name = "turbineValve";
Turbine.Float_Precision = 2;

local function round(number, precision)
    return (math.ceil(number * (10 ^ (precision)))) / 10 ^ precision;
end

function Turbine:new()
    self.device = peripheral.find(self.Peripheral_Name);
    if (self.device == nil) then
        printError("Failed to find device with prefix: " .. self.Peripheral_Name);
    end
    return self;
end

function Turbine:assert_device()
    if (self.device == nil) then
        error("Turbine object with prefix \'" .. self.Peripheral_Name .. "\'is not connected!");
    end
end

function Turbine:device_help()
    if self:assert_device() then
        local help_dict = self.device.help();
        return textutils.serialiseJSON(help_dict);
    end

    return "";
end

function Turbine:get_steam_min_percentage()
    self:assert_device();
    local steam_actual = self.device.getSteam().amount;
    local steam_needed = self.device.getSteamNeeded();
    return math.floor(100 * (steam_actual / steam_needed));
end

function Turbine:get_steam_max_percentage()
    if self:assert_device() then
        local steam_actual = self.device.getSteam().amount;
        local steam_needed = self.device.getSteamCapacity();
        return round(100 * (steam_actual / steam_needed), self.Float_Precision);
    end

    return -1;
end

function Turbine:get_flow_rate()
    if self:assert_device() then
        return round(self.device.getFlowRate() / 1000, self.Float_Precision);
    end

    return -1;
end

return { Turbine = Turbine };
