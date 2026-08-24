LABEL_WIDTH = 15;
LABEL_HEIGHT = 3;
DATA_PATH = "./turbine-data.json";
CMD_PATH = "./fission-reactor-cmd.json";

local pixelui = require("pixelui");

local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)

function read_data(data_path)
    local file = fs.open(data_path, "r");
    local data_json = file.readAll();
    return textutils.unserialiseJSON(data_json);
end

function write_cmd(cmd_path, cmds)
    local file = fs.open(cmd_path, "w+");
    local data_json = textutils.serialiseJSON(cmds);
    file.write(data_json);
    file.close();
end

local monitor_width, monitor_height = monitor.getSize();
local viewport = window.create(monitor, 1, 1, monitor_width, monitor_height, true);

local app = pixelui.create({
    window = viewport,
    background = colors.black,
    rootBorder = { color = colors.gray },
    animationInterval = 0.05
})
local root = app:getRoot();

function create_labeled_bar(monitor_width, label, label_height, label_width, vertical_level, --[[optional]] bar_color)
    local bar_color = bar_color == nil and colors.blue or bar_color;

    local label = app:createLabel({
        y = vertical_level,
        x = 2,
        height = label_height,
        width = label_width,
        text = label,
        align = "right",
        verticalAlign = "center",
        wrap = true,
    })
    app.root:addChild(label)

    local bar = app:createProgressBar({
        showPercent = true,
        textColor = colors.black,
        fillColor = bar_color,
        trackColor = colors.white,
        value = 0,
        y = label.y,
        x = label_width + 4,
        height = label.height,
        width = monitor_width - label_width - 2 - label.x,
        min = 0,
        max = 1,
    })
    app.root:addChild(bar);

    return label, bar;
end

local header = app:createLabel({
    width = monitor_width,
    height = 1,
    text = "TURBINE A",
    align = "center",
    bg = colors.blue,
    fg = colors.white
});
root:addChild(header);

local _, tank_minimums_bar = create_labeled_bar(monitor_width, "TANK MINIMUM\nFILL LEVEL:",
    LABEL_HEIGHT, LABEL_WIDTH, 3);

local _, steam_flow_rate_bar = create_labeled_bar(monitor_width, "STEAM FLOW-RATE\nCAPACITY:",
    LABEL_HEIGHT, LABEL_WIDTH, 7, colors.orange);

CHART_HEIGHT = 10;
local energy_history_chart = app:createChart({
    x = 3,
    y = monitor_height - CHART_HEIGHT - 2,
    width = monitor_width - 4,
    height = CHART_HEIGHT,
    data = {},
    minValue = 0,
    maxValue = 1,
    showAxis = true,
    showLabels = false,
    selectable = false,
    chartType = "line",
    rangePadding = 1,
    lineColor = colors.green,
    axisColor = colors.white,
});
app.root:addChild(energy_history_chart);

local toggle_label = app:createLabel({
    x = 2,
    y = 11,
    width = LABEL_WIDTH,
    height = LABEL_HEIGHT,
    text = "Reactor Switch",
    align = "right",
    verticalAlign = "center",
});
root:addChild(toggle_label);

local toggle = app:createToggle({
    x = toggle_label.x + LABEL_WIDTH + 2,
    y = toggle_label.y,
    width = LABEL_WIDTH,
    height = LABEL_HEIGHT,
    value = true,
    onChange = function(self, state)
        write_cmd(CMD_PATH, { state and "REACTOR_ENABLE" or "REACTOR_DISABLE" });
    end
})
app.root:addChild(toggle)

app:spawnThread(function(ctx)
    while not ctx:isCancelled() do
        local data = read_data(DATA_PATH);
        local steam_flow_rate_perc = data.flow_rate / data.max_flow_rate;

        tank_minimums_bar:setValue(data.steam_filled);
        steam_flow_rate_bar:setValue(steam_flow_rate_perc);
        energy_history_chart:setData(data.energy_production_history);

        ctx:yield();
    end
end, { name = "Update Display" });

app:run();
