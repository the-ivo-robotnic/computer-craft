DEFAULT_FLOAT_PRECISION = 3;

local function round_float(number, precision)
    precision = precision or DEFAULT_FLOAT_PRECISION;

    local base = number * (10 ^ precision);
    local rounding_fn = nil;

    if (base - math.floor(base)) >= 0.5 then
        rounding_fn = math.ceil;
    else
        rounding_fn = math.floor;
    end

    return (rounding_fn(number * (10 ^ (precision)))) / 10 ^ precision;
end

return { round_float = round_float };
