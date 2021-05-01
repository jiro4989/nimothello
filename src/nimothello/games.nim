import illwill

proc mainLoop() =
  let key = getKey()
  case key
  of Key.None: discard
  of Key.Escape: discard
  of Key.H: discard
  of Key.J: discard
  of Key.K: discard
  of Key.L: discard
  of Key.Space, Key.Enter: discard
  else: discard
