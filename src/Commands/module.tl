local type Args = require("argparse").Args

local subcommands: {string:function(args: Args)} = {
   load = require("Commands.module.load"),
   save = require("Commands.module.save")
}

return function(args: Args)
   if subcommands then subcommands[args.subcommand as string](args) end
end
