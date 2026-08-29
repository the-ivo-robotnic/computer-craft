
Reactor = {};
Reactor.Peripheral_Name = "fissionReactorLogicAdapter";

function Reactor:update_reactor_stats()
    reactor.stats = {};

    reactor.stats.actual_burn_rate = reactor.getActualBurnRate();
    reactor.stats.boil_efficiency = reactor.getBoilEfficiency();
    reactor.stats.burn_rate = reactor.getBurnRate();
    reactor.stats.coolant = reactor.getCoolant();
    reactor.stats.coolant_capacity = reactor.getCoolantCapacity();
    reactor.stats.coolant_filled_percentage = reactor.getCoolantFilledPercentage();
    reactor.stats.coolant_needed = reactor.getCoolantNeeded();
    reactor.stats.damage_percent = reactor.getDamagePercent();
    reactor.stats.environmental_loss = reactor.getEnvironmentalLoss();
    reactor.stats.fuel = reactor.getFuel();
    reactor.stats.fuel_assemblies = reactor.getFuelAssemblies();
    reactor.stats.fuel_capacity = reactor.getFuelCapacity();
    reactor.stats.fuel_filled_percentage = reactor.getFuelFilledPercentage();
    reactor.stats.fuel_needed = reactor.getFuelNeeded();
    reactor.stats.fuel_surface_area = reactor.getFuelSurfaceArea();
    reactor.stats.heat_capacity = reactor.getHeatCapacity();
    reactor.stats.heated_coolant = reactor.getHeatedCoolant();
    reactor.stats.heated_coolant_capacity = reactor.getHeatedCoolantCapacity();
    reactor.stats.heated_coolant_filled_percentage = reactor.getHeatedCoolantFilledPercentage();
    reactor.stats.heated_coolant_needed = reactor.getHeatedCoolantNeeded();
    reactor.stats.heating_rate = reactor.getHeatingRate();
    reactor.stats.height = reactor.getHeight();
    reactor.stats.length = reactor.getLength();
    reactor.stats.logic_mode = reactor.getLogicMode();
    reactor.stats.max_burn_rate = reactor.getMaxBurnRate();
    reactor.stats.max_pos = reactor.getMaxPos();
    reactor.stats.min_pos = reactor.getMinPos();
    reactor.stats.redstone_logic_status = reactor.getRedstoneLogicStatus();
    reactor.stats.redstone_mode = reactor.getRedstoneMode();
    reactor.stats.status = reactor.getStatus();
    reactor.stats.temperature = reactor.getTemperature();
    reactor.stats.waste = reactor.getWaste();
    reactor.stats.waste_capacity = reactor.getWasteCapacity();
    reactor.stats.waste_filled_percentage = reactor.getWasteFilledPercentage();
    reactor.stats.waste_needed = reactor.getWasteNeeded();
    reactor.stats.width = reactor.getWidth();
    reactor.stats.is_formed = reactor.isFormed();
    reactor.stats.is_force_disabled = reactor.isForceDisabled();
end

local function display_reactor_stats(reactor)
    local reactor_json = textutils.serialiseJSON(reactor.stats, {nbt_style=false, unicode_strings=true, allow_repetitions=false});
    local file = fs.open("reactor-data_latest.json", "w+");
    file.write(reactor_json);
    file.close();
end
