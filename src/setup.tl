local fs <const> = require("fs")
local colors <const> = require("ansicolors")

local config_path = fs.config_dir .. "/evsv"

return function()
   local ok, err: boolean, string
   if not (fs.exists(config_path) and fs.is_directory(config_path)) then
      io.write(colors("%{bright blue}It seems that it's the first time you use evsv.\n"))
      io.write(colors("Creating %{yellow}" .. config_path .. "%{reset}\n"))
      ok, err = fs.mkdir_recursive(config_path)
      if not ok then
         error(colors("%{bright red}" .. err))
      end

      ok, err = fs.mkdir(config_path .. "/Templates")
      if not ok then
         error(colors("%{bright red}" .. err))
      end

      ok, err = fs.mkdir(config_path .. "/Modules")
      if not ok then
         error(colors("%{bright red}" .. err))
      end

      ok, err = fs.write_file(config_path .. "/evasive.lua", [[return {
   host = "0.0.0.0",
   port = 8080
}
]])
      if not ok then
         error(colors("%{bright red}" .. err))
      end
      
      ok, err = fs.write_file(config_path .. "/evasive.tl", [[return {
   host = "0.0.0.0",
   port = 8080
} as string
]])
      if not ok then
         error(colors("%{bright red}" .. err))
      end
   end
end