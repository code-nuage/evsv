local argparse <const> = require("argparse")

local parser = argparse()
:name("evsv")
:description("CLI tool of evasive web framework")

parser:command_target("command")

local init = parser:command("init i")
init:description("Init an evasive project")
init:option("-n --name")

local module = parser:command("module m")
module:description("Modules manipulations commands")

local module_saver = module:argument("action", "Action to perform on module")
:choices({"save", "load"})

local module_loader = parser:command("load l")
module_loader:description("Load a module template")
module_loader:option("-n --name")
module_loader:option("-r --replace")

return parser:parse()
