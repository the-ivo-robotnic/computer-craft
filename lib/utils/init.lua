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

function sanitized_abs_path(path)
    local new_path = path

    if not path:find("^/.*") then
        new_path = "/" .. new_path
    end

    if not path:find(".*/$") then
        new_path = new_path .. "/"
    end

    return new_path
end

function add_load_path(path)
    package.path = package.path .. ";" .. sanitized_abs_path(path) .. "?";
    package.path = package.path .. ";" .. sanitized_abs_path(path) .. "?.lua";
    package.path = package.path .. ";" .. sanitized_abs_path(path) .. "?/init.lua";
end

return {
    round_float = round_float,
    sanitized_abs_path = sanitized_abs_path,
    add_load_path = add_load_path,
};
