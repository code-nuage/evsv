local colors <const> = require("ansicolors")

local msg_level = {
   "%{cyan}Info",
   "%{yellow}Warning",
   "%{red}Error",
}

return function(level: integer, text: string, err?: string)
   print(colors(msg_level[level] .. "%{reset}\t│ " .. text .. (err ~= nil and ": %{red}" .. err or "")))
end
