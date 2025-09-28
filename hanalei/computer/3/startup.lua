local modem = peripheral.find('modem')
modem.open(1)

local alarm = peripheral.wrap('industrialAlarm_1')
alarm.setRedstoneMode('DISABLED')

modem.closeAll()

rs.setOutput('right', true)