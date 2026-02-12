package = "evsv"
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
   "argparse >= 0.7.1-1",
   "ansicolors >= 1.0.2-3"
}
build = {
   type = "builtin",
   modules = {
      ["main"] = "build/main.lua",
      ["cli"]  = "build/cli.lua",
      ["fs"] = "build/fs.lua",
      ["setup"] = "build/setup.lua",
      ["Commands.init"] = "build/Commands/init.lua",
      ["Commands.module"] = "build/Commands/module.lua",
      ["Commands.module.save"] = "build/Commands/module/save.lua",
      ["Commands.module.load"] = "build/Commands/module/load.lua"
   },
   install = {
      bin = {
         ["evsv"] = "build/main.lua"
      }
   }
}
