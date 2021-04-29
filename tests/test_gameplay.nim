discard """
  exitcode: 0
"""

import unittest

import nimothello/models

var game = newGame()
game.putCell(6, 4)
check game.getBoard()[6, 4] == player1
debugPrint game.getBoard()
check game.getPlayer1Score() == 4
check game.getPlayer2Score() == 1
game.putCell(6, 3)
check game.getPlayer1Score() == 3
check game.getPlayer2Score() == 3
check game.isRunning()