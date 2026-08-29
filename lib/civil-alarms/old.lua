local function rs_enable_cable(cable_port, cable)
    rs.setBundledOutput(cable_port, colors.combine(rs.getBundledOutput(cable_port), cable));
end

local function rs_disable_cable(cable_port, cable)
    rs.setBundledOutput(cable_port, colors.subtract(rs.getBundledOutput(cable_port), cable));
end



local function async_raise_fire_alarm()
    print("Fire Alarm On!");
    local beacon_counter = 0;
    reactor_scram();

    while true do
        if (beacon_counter == 3) then
            rs_disable_cable(CABLE_PORT, CIVIL_ALERT_SIREN);
            beacon_counter = 0;
        else
            rs_enable_cable(CABLE_PORT, CIVIL_ALERT_SIREN);
            beacon_counter = beacon_counter + 1;
        end

        sleep(SIREN_TIME);
    end
end

local function async_strobe_fire_alarm()
    local beacon_counter = 0;

    while true do
        if (beacon_counter == 3) then
            beacon_counter = 0;
            sleep(SIREN_TIME);
        else
            rs_enable_cable(CABLE_PORT, CIVIL_ALERT_STROBE);
            sleep(STROBE_TIME);
            rs_disable_cable(CABLE_PORT, CIVIL_ALERT_STROBE);
            beacon_counter = beacon_counter + 1;
            sleep(SIREN_TIME - STROBE_TIME);
        end
    end
end

local function raise_fire_alarm()
    async.spawn(async_raise_fire_alarm);
    async.spawn(async_strobe_fire_alarm);
    async.drive();
end

local function lower_fire_alarm()
    local output = rs.getBundledOutput(CABLE_PORT);
    rs.setBundledOutput(CABLE_PORT, output);
end
