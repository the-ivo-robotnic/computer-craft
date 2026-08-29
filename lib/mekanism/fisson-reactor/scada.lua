local async = require("sys/packages/async");


YIELD_TIME = 0.1;
SIREN_TIME = 1;
STROBE_TIME = 0.01;
CABLE_PORT = "back";
MONITOR_PERIPHERAL_NAME = "monitor";
REACTOR_PERIPHERAL_NAME = "fissionReactorLogicAdapter";

--- Output Redstone
local CIVIL_ALERT_SIREN = colors.purple;
local CIVIL_ALERT_STROBE = colors.red;


---@type table
local monitor = peripheral.find(MONITOR_PERIPHERAL_NAME);
assert(monitor ~= nil, "No monitor was found on the network!");

---@type table
local reactor = peripheral.find(REACTOR_PERIPHERAL_NAME);
assert(reactor ~= nil, "No reactor rs adaptor was found on the network!");

