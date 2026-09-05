-- Package Path Modification
package.path = package.path .. ";/usr/lib/?";
package.path = package.path .. ";/usr/lib/?.lua";
package.path = package.path .. ";/usr/lib/?/init.lua";


local civil_alarms = require("civil-alarms");
local logging = require("logging");
local logger = logging.create_context("Alarm CC");


local Alarm = civil_alarms.Alarm;

term.clear();
term.setCursorPos(1, 1);

local evac_alarm = Alarm:new("left", "top", "redstone_relay_6");

evac_alarm:arm();
logger.info("Armed everything! Waiting for 12 s...");
os.sleep(12);

evac_alarm:silence();
logger.info("Silenced alarm! Waiting for 12 s...");
os.sleep(12);


evac_alarm:disarm();
logger.info("Disarmed alarm! Done!");
