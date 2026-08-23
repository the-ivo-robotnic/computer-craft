local async = require("/sys/packages/async");

Alarm = {};
Alarm.__index = Alarm;

function Alarm:new(horn_code, strobe_code)
    self.horn_code = horn_code;
    self.strobe_code = strobe_code;
    return self;
end

function Alarm:strobe()
    async.spawn(self:async_strobe());
end

function Alarm:async_strobe()
    print("Flashing strobe:", self.strobe_code);
    sleep(1);
    -- while true do
    -- end
end

function Alarm:horn()
    async.spawn(self:async_horn());
end

function Alarm:async_horn()
    while true do
        print("Sounding horn:", self.horn_code);
        sleep(1);
    end
end

function Alarm:run_async()
    async.drive();
end

return { Alarm = Alarm };
