local type Args = require("argparse").Args

require("setup")()
local args = require("cli")

local commands: {string:function(args: Args)} = {
   init = require("Commands.init"),
   module = require("Commands.module")
}

local c: string = args.command as string

if commands[c] then commands[c](args) end
