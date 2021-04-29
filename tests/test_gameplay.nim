discard """
  exitcode: 0
"""

import unittest

import nimothello/models

var game = newGame()
let tests = [
  (x: 6, y: 4, scoreP1: 4, scoreP2: 1, status: GameStatus.isRunning),  # p1
  (x: 6, y: 3, scoreP1: 3, scoreP2: 3, status: GameStatus.isRunning),  # p2
  (x: 5, y: 3, scoreP1: 5, scoreP2: 2, status: GameStatus.isRunning),  # p1
  (x: 4, y: 3, scoreP1: 3, scoreP2: 5, status: GameStatus.isRunning),  # p2
  (x: 5, y: 2, scoreP1: 5, scoreP2: 4, status: GameStatus.isRunning),  # p1
  (x: 6, y: 5, scoreP1: 2, scoreP2: 8, status: GameStatus.isRunning),  # p2
  (x: 5, y: 6, scoreP1: 5, scoreP2: 6, status: GameStatus.isRunning),  # p1
  (x: 4, y: 6, scoreP1: 4, scoreP2: 8, status: GameStatus.isRunning),  # p2
  (x: 3, y: 3, scoreP1: 6, scoreP2: 7, status: GameStatus.isRunning),  # p1
  (x: 2, y: 3, scoreP1: 3, scoreP2: 11, status: GameStatus.isRunning), # p2
  (x: 7, y: 4, scoreP1: 7, scoreP2: 8, status: GameStatus.isRunning),  # p1
  (x: 8, y: 4, scoreP1: 4, scoreP2: 12, status: GameStatus.isRunning),  # p2
  (x: 1, y: 3, scoreP1: 9, scoreP2: 8, status: GameStatus.isRunning),  # p1
  (x: 5, y: 1, scoreP1: 7, scoreP2: 11, status: GameStatus.isRunning),  # p2
  (x: 4, y: 7, scoreP1: 11, scoreP2: 8, status: GameStatus.isRunning),  # p1
  (x: 5, y: 7, scoreP1: 10, scoreP2: 10, status: GameStatus.isRunning),  # p2
  (x: 6, y: 7, scoreP1: 13, scoreP2: 8, status: GameStatus.isRunning),  # p1
  (x: 5, y: 8, scoreP1: 11, scoreP2: 11, status: GameStatus.isRunning),  # p2
  (x: 6, y: 6, scoreP1: 14, scoreP2: 9, status: GameStatus.isRunning),  # p1
  (x: 7, y: 6, scoreP1: 12, scoreP2: 12, status: GameStatus.isRunning),  # p2
  (x: 8, y: 6, scoreP1: 14, scoreP2: 11, status: GameStatus.isRunning),  # p1
  (x: 3, y: 7, scoreP1: 11, scoreP2: 15, status: GameStatus.isRunning),  # p2
  (x: 7, y: 8, scoreP1: 13, scoreP2: 14, status: GameStatus.isRunning),  # p1
  (x: 7, y: 7, scoreP1: 11, scoreP2: 17, status: GameStatus.isRunning),  # p2
  (x: 8, y: 8, scoreP1: 15, scoreP2: 14, status: GameStatus.isRunning),  # p1
  (x: 8, y: 7, scoreP1: 13, scoreP2: 17, status: GameStatus.isRunning),  # p2
  (x: 2, y: 8, scoreP1: 16, scoreP2: 15, status: GameStatus.isRunning),  # p1
  (x: 4, y: 2, scoreP1: 12, scoreP2: 20, status: GameStatus.isRunning),  # p2
  (x: 7, y: 5, scoreP1: 16, scoreP2: 17, status: GameStatus.isRunning),  # p1
  (x: 8, y: 5, scoreP1: 11, scoreP2: 23, status: GameStatus.isRunning),  # p2
  (x: 8, y: 3, scoreP1: 18, scoreP2: 17, status: GameStatus.isRunning),  # p1
  (x: 7, y: 3, scoreP1: 16, scoreP2: 20, status: GameStatus.isRunning),  # p2
  (x: 6, y: 8, scoreP1: 18, scoreP2: 19, status: GameStatus.isRunning),  # p1
  (x: 2, y: 7, scoreP1: 17, scoreP2: 21, status: GameStatus.isRunning),  # p2
  (x: 3, y: 1, scoreP1: 22, scoreP2: 17, status: GameStatus.isRunning),  # p1
  (x: 2, y: 2, scoreP1: 21, scoreP2: 19, status: GameStatus.isRunning),  # p2
  (x: 3, y: 4, scoreP1: 25, scoreP2: 16, status: GameStatus.isRunning),  # p1
  (x: 3, y: 2, scoreP1: 24, scoreP2: 18, status: GameStatus.isRunning),  # p2
  (x: 2, y: 1, scoreP1: 28, scoreP2: 15, status: GameStatus.isRunning),  # p1
  (x: 3, y: 5, scoreP1: 26, scoreP2: 18, status: GameStatus.isRunning),  # p2
  (x: 2, y: 5, scoreP1: 31, scoreP2: 14, status: GameStatus.isRunning),  # p1
  (x: 3, y: 6, scoreP1: 27, scoreP2: 19, status: GameStatus.isRunning),  # p2
  (x: 1, y: 7, scoreP1: 32, scoreP2: 15, status: GameStatus.isRunning),  # p1
  (x: 1, y: 8, scoreP1: 31, scoreP2: 17, status: GameStatus.isRunning),  # p2
  (x: 2, y: 6, scoreP1: 36, scoreP2: 13, status: GameStatus.isRunning),  # p1
  (x: 1, y: 6, scoreP1: 29, scoreP2: 21, status: GameStatus.isRunning),  # p2
  (x: 6, y: 2, scoreP1: 34, scoreP2: 17, status: GameStatus.isRunning),  # p1
  (x: 3, y: 8, scoreP1: 30, scoreP2: 22, status: GameStatus.isRunning),  # p2
  (x: 2, y: 4, scoreP1: 33, scoreP2: 20, status: GameStatus.isRunning),  # p1
  (x: 1, y: 4, scoreP1: 30, scoreP2: 24, status: GameStatus.isRunning),  # p2
  (x: 1, y: 5, scoreP1: 34, scoreP2: 21, status: GameStatus.isRunning),  # p1
  (x: 1, y: 1, scoreP1: 32, scoreP2: 24, status: GameStatus.isRunning),  # p2
  (x: 1, y: 2, scoreP1: 34, scoreP2: 23, status: GameStatus.isRunning),  # p1
  (x: 4, y: 1, scoreP1: 28, scoreP2: 30, status: GameStatus.isRunning),  # p2
  (x: 6, y: 1, scoreP1: 32, scoreP2: 27, status: GameStatus.isRunning),  # p1
  (x: 7, y: 1, scoreP1: 29, scoreP2: 31, status: GameStatus.isRunning),  # p2
  (x: 4, y: 8, scoreP1: 37, scoreP2: 24, status: GameStatus.isRunning),  # p1
  (x: 7, y: 2, scoreP1: 36, scoreP2: 26, status: GameStatus.isRunning),  # p2
  (x: 8, y: 2, scoreP1: 40, scoreP2: 23, status: GameStatus.isRunning),  # p1
  (x: 8, y: 1, scoreP1: 39, scoreP2: 25, status: GameStatus.isFinished),  # p2
]
for tt in tests:
  game.putCell(tt.x, tt.y)
  debugPrint game.getBoard
  check game.getPlayer1Score() == tt.scoreP1
  check game.getPlayer2Score() == tt.scoreP2
  check game.getStatus == tt.status