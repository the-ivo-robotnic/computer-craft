DATA_PATH = "./turbine-data.json";
YIELD_TIME = 0.1; -- seconds
JSON_OPTS = { nbt_style = false, unicode_strings = true, allow_repetitions = false }

local mk_turbine = require("usr.programs.mekanism.turbine");

local RelativeHistory = {};

function RelativeHistory:new(name, --[[optional]] sample_size)
    self.name = name;
    self.sample_size = sample_size == nil and 100 or sample_size;
    self.history = {};
    return self;
end

function RelativeHistory:append(data)
    local trim_size = #self.history - self.sample_size;
    if (trim_size > 0) then
        print("Trimming " .. trim_size .. " data points from " .. self.name .. " history!");
        for _ = 1, trim_size do
            table.remove(self.history, 1);
        end
    end
    table.insert(self.history, data);
end

function write_data(data_path, data)
    local json = textutils.serializeJSON(data, JSON_OPTS);
    local file = fs.open(data_path, "w+");
    file.write(json);
    file.close();
end

function main()
    local turbine = mk_turbine.Turbine:new();

    local data = {};
    local energy_production_history = RelativeHistory:new('Energy Production', 100);

    while true do
        data.steam_filled = turbine.device.getSteamFilledPercentage();

        data.flow_rate = turbine.device.getFlowRate();
        data.max_flow_rate = turbine.device.getMaxFlowRate();

        data.energy_production = turbine.device.getEnergyFilledPercentage();
        data.max_energy_productuion = turbine.device.getMaxProduction();

        data.max_water_output = turbine.device.getMaxWaterOutput();

        energy_production_history:append(data.energy_production);
        data.energy_production_history = energy_production_history.history;

        write_data(DATA_PATH, data);
        sleep(YIELD_TIME);
    end

    file.close();
end

main();
