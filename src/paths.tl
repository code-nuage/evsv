local fs <const> = require("fs")

local config_dir = fs.config_dir .. "/evsv"

return {
   config = config_dir,
   modules = fs.config_dir .. "/Modules",
   templates = fs.config_dir .. "/Templates",
}