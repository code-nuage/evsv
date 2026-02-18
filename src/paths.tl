local fs <const> = require("fs")

local config_dir = fs.join(fs.config_dir, "evsv")
local config_lua = "evasiveconfig.lua"
local config_teal = "evasiveconfig.teal"
local main_lua = "main.lua"
local main_teal = "main.teal"

return {
   config = config_dir,
   modules = fs.join(config_dir, "Modules"),
   templates = fs.join(config_dir, "Templates"),
   config_lua_name = config_lua,
   config_teal_name = config_teal,
   main_lua_name = main_lua,
   main_teal_name = main_teal,
   project_config_lua = fs.join(config_dir, config_lua),
   project_config_teal = fs.join(config_dir, config_teal)
}
