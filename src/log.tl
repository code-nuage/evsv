local colors <const> = require("ansicolors")

local msg_level = {
   "%{cyan}Infos",
   "%{yellow}Warning",
   "%{red}Error",
}

return function(level: integer, text: string)
   print(colors(msg_level[level] .. "%{reset} " .. text))
end
