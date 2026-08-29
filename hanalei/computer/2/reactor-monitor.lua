CMD_PATH = "./fission-reactor-cmd.json";

local logging = require("logger");
local logger = logging.Logger:new("reactor-monitor.log");

function read_cmd(cmd_path)
    local file = fs.open(cmd_path, "r");
    local cmd_json = file.readAll();
    local cmd = textutils.unserialiseJSON(cmd_json);
    if cmd_json == nil or cmd_json == "" or cmd == nil then
        cmd = {};
    end
    file.close();

    file = fs.open(cmd_path, "w+");
    file.write("[]");
    file.close();
    return cmd;
end

function main()
    local reactor = peripheral.find("fissionReactorLogicAdapter");
    local coolant_valve_relay = peripheral.find("redstone_relay");
    local coolant_valve = "top";

    while true do
        local cmds = read_cmd(CMD_PATH);

        for _, cmd in ipairs(cmds) do
            logger:debug("Got cmd: " .. cmd);
            local reactor_status = reactor.getStatus();

            if cmd == "REACTOR_ENABLE" and not reactor_status then
                logger:info("Arming fission reactor...");
                reactor.activate();
                logger:warn("Fission reactor is armed!")
            elseif cmd == "REACTOR_DISABLE" and reactor_status then
                logger:info("Disarming fission reactor...");
                reactor.scram();
                logger:warn("Fission reactor is disarmed!")
            elseif cmd == "COOLANT_ENABLE" then
                coolant_valve_relay.setOutput(coolant_valve, false);
            elseif cmd == "COOLANT_DISABLE" then
                coolant_valve_relay.setOutput(coolant_valve, true);
            else
                local reactor_status_str = reactor_status and "ACTIVE" or "INACTIVE"
                logger:critical("Failed to change state according to command " ..
                    cmd .. " but reactor is in state: " .. reactor_status_str);
            end
        end
        sleep(0.1);
    end
end

main();
