local argparse <const> = require("argparse")

local parser = argparse()
   :name("evsv")
   :description("CLI tool of evasive web framework")

parser:command_target("command")

--+ Init +--
local init = parser:command("init i")
init:description("Init an evasive project")
init:argument("name", "Name of the new evasive project"):args("?")
init:option("--template -t")

--+ Module +--
local module = parser:command("module m")
module:description("Modules manipulation")

module:command_target("subcommand")

-- Save
local save_subcommand = module:command("save s")
save_subcommand:argument("name", "Name of the registered module to save")
save_subcommand:argument("file", "File to register the module from")

-- Load
local load_subcommand = module:command("load l")
load_subcommand:argument("name", "Name of the registered module to load")

return parser:parse()
