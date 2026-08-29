DEFAULT_FLOAT_PRECISION = 2

local function round_float(number, precision)
    precision = precision or DEFAULT_FLOAT_PRECISION;

    return (math.ceil(number * (10 ^ (precision)))) / 10 ^ precision;
end

local function joules_to_fe(joules)
    return joules * 0.4;
end

return {
    round_float = round_float,
    joules_to_fe = joules_to_fe
}
