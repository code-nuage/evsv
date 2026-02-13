local type Args = require("argparse").Args

local fs <const> = require("fs")
local log <const> = require("log")
local paths <const> = require("paths")

return function(args: Args)
   local ok, err: boolean, string
   if not args.name then
      if fs.exists("./evasiveconfig.json") then
         ok, err = false, "Project already exists"
      else
         ok, err = fs.copy_file(paths.project_config, "./evasiveconfig.json")
      end
      if not ok then
         log(3, "Can't initialized project: " .. err)
         return
      end
      log(1, "Project %{yellow}initialized")
   end
end
