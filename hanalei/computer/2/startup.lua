local add_load_path = require("usr.lib.utils").add_load_path

term.clear();
term.setCursorPos(1, 1);

add_load_path('usr/lib');
add_load_path('usr/lib/fbc');

local civil_alarms = require("civil-alarms");
local logging = require("fbc.logging");
local logger = logging.create_context("Alarm CC");


local Alarm = civil_alarms.Alarm;


local evac_alarm = Alarm:new("left", "top", "redstone_relay_6");

evac_alarm:arm();
logger.info("Armed everything! Waiting for 12 s...");
os.sleep(12);

evac_alarm:silence();
logger.info("Silenced alarm! Waiting for 12 s...");
os.sleep(12);


evac_alarm:disarm();
logger.info("Disarmed alarm! Done!");
