# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "TODO"
license       = "MIT"
srcDir        = "src"
bin           = @["nimothello"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.4.4"

task tests, "Run test":
  exec "testament p 'tests/*.nim'"