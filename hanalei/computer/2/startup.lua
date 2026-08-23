function setup_term()
    term.clear();
    term.setCursorPos(1, 1);
end

function add_route(route)
    shell.setPath("" .. shell.path() .. ":" .. route);
    return shell.path();
end


add_route("/usr/programs");
setup_term();
local scada = require("usr.programs.scada");
print(scada);