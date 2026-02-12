local type Args = require("argparse").Args

local fs <const> = require("fs")
local colors <const> = require("ansicolors")

return function(args: Args)
   if not args.name then
      assert(not fs.exists("./evasive.lua"),
         colors("%{bright red}Project already exists"))
      print(colors("%{bright green}-- Initializing evasive project"))
      fs.write_file("./evasive.lua", [[return {
host = "0.0.0.0",
port = 8080
}
]])
   end
end
