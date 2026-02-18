local type Args = require("argparse").Args

local fs <const> = require("fs")
local log <const> = require("log")
local paths <const> = require("paths")

return function(args: Args)
   local ok, err: boolean, string
   local project_dir = args.name and fs.join(".", args.name as string) or "."

   if project_dir ~= "." then
      ok, err = fs.mkdir_recursive(project_dir)
      if not ok then
         log(3, "Can't initialize project", err)
         return
      end
   end

   if fs.exists(fs.join(project_dir,  paths.config_lua_name)) then
      ok, err = false, "Project already exists"
   else
      ok, err = fs.copy_file(paths.project_config_lua, fs.join(project_dir, paths.config_lua_name))
   end
   if not ok then
      log(3, "Can't initialize project", err)
      return
   end
   log(1, "Project %{yellow}initialized")
end
