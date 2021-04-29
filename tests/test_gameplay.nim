discard """
  exitcode: 0
"""

import unittest

import nimothello/models

var game = newGame()
let tests = [
  (x: 6, y: 4, scoreP1: 4, scoreP2: 1, status: GameStatus.isRunning),
  (x: 6, y: 3, scoreP1: 3, scoreP2: 3, status: GameStatus.isRunning),
  (x: 5, y: 3, scoreP1: 5, scoreP2: 2, status: GameStatus.isRunning),
  (x: 4, y: 3, scoreP1: 3, scoreP2: 5, status: GameStatus.isRunning),
  (x: 5, y: 2, scoreP1: 5, scoreP2: 4, status: GameStatus.isRunning),
  (x: 6, y: 5, scoreP1: 2, scoreP2: 8, status: GameStatus.isRunning),
  (x: 5, y: 6, scoreP1: 5, scoreP2: 6, status: GameStatus.isRunning),
]
for tt in tests:
  game.putCell(tt.x, tt.y)
  debugPrint game.getBoard
  check game.getPlayer1Score() == tt.scoreP1
  check game.getPlayer2Score() == tt.scoreP2
  check game.getStatus == tt.status