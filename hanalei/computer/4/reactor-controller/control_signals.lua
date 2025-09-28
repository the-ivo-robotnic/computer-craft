local logger = require('reactor-controller.logger')
local utils = require('reactor-controller.utilities')

LOGGER = logger.Logger:new()

ControlSignals = {}
ControlSignals.__index = ControlSignals

function ControlSignals:new(dispatch_side, inputs, outputs)
    self.dispatch_side = dispatch_side
    self.inputs = inputs or {}
    self.outputs = outputs or {}
    return self
end

function ControlSignals:get_in_signal(signal_name)
    local signal_color = self.inputs[signal_name]
    if (signal_color == nil) then
        LOGGER:warn('Signal ' .. signal_name .. ' has no cable bindings in the input table!')
        return -1
    end

    return rs.testBundledInput(self.dispatch_side, signal_color)
end

function ControlSignals:set_out_signal(signal_name, state)
    local active_signal = rs.getBundledOutput(self.dispatch_side)
    local signal_color = self.outputs[signal_name]
    if (signal_color == nil) then
        LOGGER:warn('Signal ' .. signal_name .. ' has no cable bindings in the output table!')
    end

    active_signal = active_signal + utils.ternary(state, signal_color, -1 * signal_color)

    rs.setBundledOutput(self.dispatch_side, active_signal)
end

function ControlSignals:safed_scram()
    local terminal_signal =
        self.outputs['maintenance_indicator'] +
        self.outputs['scram_indicator']
    rs.setBundledOutput(self.dispatch_side, terminal_signal)
end

function ControlSignals:safed_maintenance()
    local terminal_signal = 
        self.outputs['maintenance_indicator'] +
        self.outputs['initializing_indicator']
    rs.setBundledOutput(self.dispatch_side, terminal_signal)
end

return { ControlSignals = ControlSignals }
