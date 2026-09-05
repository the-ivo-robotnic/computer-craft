Alarm = {};
Alarm.__index = Alarm;

function Alarm:new(horn_code, strobe_code, relay)
    self.horn_code = horn_code;
    self.strobe_code = strobe_code;
    self.horn = false;
    self.strobe = false;

    if relay ~= nil then
        self.rs = peripheral.wrap(relay);
        print("Got relay:", self.rs);
    else
        self.rs = redstone;
    end
    return self;
end

function Alarm:arm(continue_fn)
    print("Arming strobe and horn!");
    self.horn = true;
    self.strobe = true;

    parallel.waitForAll(
        function()
            while self.horn do
                self.rs.setOutput(self.horn_code, true);
                os.sleep(3);
                self.rs.setOutput(self.horn_code, false);
                os.sleep(1);
            end
        end,
        function()
            local strobe_time = 1;                                -- seconds
            local strobe_on_time = 0.1;                           -- seconds
            local strobe_off_time = strobe_time - strobe_on_time; -- seconds
            local strobe_count = 0;

            while self.strobe do
                if strobe_count == 3 then
                    strobe_count = 0;
                    os.sleep(strobe_time);
                else
                    strobe_count = strobe_count + 1;
                    self.rs.setOutput(self.strobe_code, true);
                    os.sleep(strobe_on_time);
                    self.rs.setOutput(self.strobe_code, false);
                    os.sleep(strobe_off_time);
                end
            end
        end,
        continue_fn
    )
end

function Alarm:silence()
    print("Silencing horn!");
    self.horn = false;
end

function Alarm:disarm()
    print("Silencing strobe and horn!");
    self.horn = false;
    self.strobe = false;
end

return { Alarm = Alarm };
