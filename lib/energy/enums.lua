local SIUnit = {
    NONE = { 10 ^ 0, "" },
    KILO = { 10 ^ 3, "k" },
    MEGA = { 10 ^ 6, "M" },
    GIGA = { 10 ^ 9, "G" },
    TERA = { 10 ^ 12, "T" },
};

local EnergyUnit = {
    NONE = "NO_UNIT",
    JOULES = "J",
    FORGE_ENERGY = "FE"
};
DEFAULT_ENERGY_UNIT = EnergyUnit.JOULES;

return {
    SIUnit = SIUnit,
    EnergyUnit = EnergyUnit,
};
