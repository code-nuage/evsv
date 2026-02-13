local fs <const> = require("fs")

local config_dir = fs.join(fs.config_dir, "/evsv")

return {
   config = config_dir,
   modules = fs.join(config_dir, "/Modules"),
   templates = fs.join(config_dir, "/Templates"),
   project_config = fs.join(config_dir, "/evasiveconfig.json")
}
