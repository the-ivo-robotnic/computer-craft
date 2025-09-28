Logger = {}
Logger.__index = Logger

function Logger:new(log_file)
    self.log_file = log_file or '/logs/reactor-seq.log'
    fs.makeDir('/logs/')
    return self
end

function Logger:info(message)
    local file = fs.open(self.log_file, 'a')
    file.write('[' .. os.date() .. '][INFO]: ' .. message .. '\n')
    file.close()
end

function Logger:warn(message)
    local file = fs.open(self.log_file, 'a')
    file.write('[' .. os.date() .. '][WARN]: ' .. message .. '\n')
    file.close()
end

function Logger:critical(message)
    local file = fs.open(self.log_file, 'a')
    file.write('[' .. os.date() .. '][CRITICAL]: ' .. message .. '\n')
    file.close()
end

function Logger:debug(message)
    local file = fs.open(self.log_file, 'a')
    file.write('[' .. os.date() .. '][DEBUG]: ' .. message .. '\n')
    file.close()
end

return { Logger = Logger }
