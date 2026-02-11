package = "evasive-cli"
version = "0.0-1"
source = {
   url = "git+https://www.github.com/code-nuage/evasive-cli" ,
   tag = "0.0-1"
}
description = {
   summary = "CLI tool of evasive web framework",
   homepage = "https://www.github.com/code-nuage/evasive-cli",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1",
   "luafilesystem >= 1.9.0-1",
   "argparse >= 0.7.1-1"
}
build = {
   type = "builtin",
   modules = {
      ["main"] = "build/main.lua",
      ["cli"]  = "build/cli.lua",
      ["join"] = "build/join.lua",
      ["path"] = "build/path.lua",
      ["Commands.save"] = "build/Commands/save.lua"
   },
   install = {
      bin = {
         ["evsv"] = "build/main.lua"
      }
   }
}
