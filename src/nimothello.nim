import illwill
import nimothellopkg/[models, views]

proc main() =
  var
    game = newGame()
    view = newGameView()

  while not game.isFinished():
    let key = getKey()
    case key
    of Key.None: discard
    of Key.Escape:
      break
    of Key.H, Key.A: game.moveLeft()
    of Key.J, Key.S: game.moveDown()
    of Key.K, Key.W: game.moveUp()
    of Key.L, Key.D: game.moveRight()
    of Key.Space, Key.Enter: game.putCell()
    else: discard

    view.draw(game)
  
  exitProc()
  echo ""
  game.printResult()

when isMainModule and not defined modeTest:
  main()