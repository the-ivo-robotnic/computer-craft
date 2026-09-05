-- Package Path Modification
package.path = package.path .. ";/usr/lib/?";
package.path = package.path .. ";/usr/lib/?.lua";
package.path = package.path .. ";/usr/lib/?/init.lua";


local civil_alarms = require("civil-alarms");
local Alarm = civil_alarms.Alarm;

term.clear();
term.setCursorPos(1, 1);

local evac_alarm = Alarm:new("left", "top", "redstone_relay_6");

evac_alarm:arm(
    function ()
        sleep(12);
        evac_alarm:silence();
        sleep(12);
        evac_alarm:disarm();
    end
);