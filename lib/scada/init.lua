local civil_alarms = require("usr.programs.civil-alarms");

local function clear_term()
    term.clear();
    term.setCursorPos(1, 1);
end

function Run()
    clear_term();

    local fire_alarm = civil_alarms.Alarm:new(colors.purple, colors.red);
    fire_alarm:strobe();
    fire_alarm:horn();
    fire_alarm:run_async();
end

Run();
return { run = Run };
