# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A teminal othello (reversi) in Nim."
license       = "MIT"
srcDir        = "src"
bin           = @["nimothello"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.4.4"
requires "illwill >= 0.2.0"

task tests, "Run test":
  exec "testament p 'tests/*.nim'"
