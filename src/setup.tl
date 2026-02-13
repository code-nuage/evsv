local fs <const> = require("fs")
local log <const> = require("log")
local paths <const> = require("paths")

local function ensure_dir(path: string)
   local ok, err = fs.mkdir_recursive(path)

   if not ok then
      log(3, "Failed to create %{yellow}" .. path .. "%{reset}: " .. err)
      return
   end
   log(1, "Created %{yellow}" .. path)
end

local function ensure_file(path: string, content?: string)
   local ok, err = fs.write_file(path, content)

   if not ok then
      log(3, "Failed to create %{yellow}" .. path .. "%{reset}: " .. err)
      return
   end
   log(1, "Created %{yellow}" .. path .. "%{reset}")
end

return function()
   if not (fs.exists(paths.config) and fs.is_directory(paths.config)) then
      log(1, "%{bright blue}It seems that it's the first time you use evsv.%{reset}")

      ensure_dir(paths.modules)
      ensure_dir(paths.templates)
      ensure_file(paths.project_config, [[{
   "host": "0.0.0.0",
   "port": 8080
}
]])
   end
end