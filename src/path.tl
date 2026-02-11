local fs <const> = require("fs")

return {
   ["config"] = fs.join(os.getenv("HOME"), ".config")
}
