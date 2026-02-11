local args = require("cli")

local command_save = require("Commands.save")

if args.init then

elseif args.save then
   command_save(args.file as string)
elseif args.load then

end