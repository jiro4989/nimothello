discard """
  exitcode: 0
"""

import unittest

include nimothello/models

block:
  checkpoint "Game status"
  var g = newGame()
  check g.isRunning()
  for y in 1..9:
    for x in 1..9:
      g.board[x, y] = player1
  check g.isFinished()

block:
  checkpoint "Player score"
  var g = newGame()
  check g.getPlayer1Score() == 2
  check g.getPlayer2Score() == 2
  g.board[1, 1] = player1
  check g.getPlayer1Score() == 3
  check g.getPlayer2Score() == 2
  g.board[1, 2] = player2
  check g.getPlayer1Score() == 3
  check g.getPlayer2Score() == 3

block:
  checkpoint "Player to cell"
  var g = newGame()
  check g.currentPlayer.playerToCell == player1
  g.turnPlayer()
  check g.currentPlayer.playerToCell == player2

block:
  # set Vertical line
  let want1 = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]
  let want2 = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]

  let tests = [
    (desc: "set cells to edge area", x1: 1, y1: 1, x2: 1, y2: 3, cell: player1, want: want1),
    (desc: "overwrite cells", x1: 5, y1: 3, x2: 5, y2: 5, cell: player1, want: want2),
    (desc: "set cells to edge area (desc)", x1: 1, y1: 3, x2: 1, y2: 1, cell: player1, want: want1),
  ]
  for tt in tests:
    checkpoint tt.desc
    var g = newGame()
    g.board.setLineVertical(tt.x1, tt.y1, tt.x2, tt.y2, tt.cell)
    check tt.want == g.board

block:
  # set Horizontal line
  let want1 = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, player1, player1, player1, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]
  let want2 = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player1, player1, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]

  let tests = [
    (desc: "set horizontal line to edge", x1: 1, y1: 1, x2: 3, y2: 1, cell: player1, want: want1),
    (desc: "overwrite cells", x1: 4, y1: 4, x2: 6, y2: 4, cell: player1, want: want2),
    (desc: "set horizontal line to edge (desc)", x1: 3, y1: 1, x2: 1, y2: 1, cell: player1, want: want1),
  ]
  for tt in tests:
    checkpoint tt.desc
    var g = newGame()
    g.board.setLineHorizontal(tt.x1, tt.y1, tt.x2, tt.y2, tt.cell)
    check tt.want == g.board

block:
  # set Oblique line
  let want1 = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, player1, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, player1, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]
  let want2 = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, empty, empty, player1, empty, empty, empty, empty, empty, wall],
      [wall, empty, player1, empty, empty, empty, empty, empty, empty, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]

  let tests = [
    (desc: "right down", x1: 1, y1: 1, x2: 3, y2: 3, cell: player1, want: want1),
    (desc: "left down", x1: 3, y1: 1, x2: 1, y2: 3, cell: player1, want: want2),
    (desc: "left up", x1: 3, y1: 3, x2: 1, y2: 1, cell: player1, want: want1),
    (desc: "right up", x1: 1, y1: 3, x2: 3, y2: 1, cell: player1, want: want2),
  ]
  for tt in tests:
    checkpoint tt.desc
    var g = newGame()
    g.board.setLineOblique(tt.x1, tt.y1, tt.x2, tt.y2, tt.cell)
    check tt.want == g.board

block:
  # set line
  let wantRightDown = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, player1, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, player1, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]
  let wantLeftDown = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, empty, empty, player1, empty, empty, empty, empty, empty, wall],
      [wall, empty, player1, empty, empty, empty, empty, empty, empty, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]
  let wantUp = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, player1, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]
  let wantLeft = 
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, player1, player1, player1, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]

  let tests = [
    (desc: "left up", x1: 3, y1: 3, x2: 1, y2: 1, cell: player1, want: wantRightDown),
    (desc: "up", x1: 1, y1: 3, x2: 1, y2: 1, cell: player1, want: wantUp),
    (desc: "right up", x1: 1, y1: 3, x2: 3, y2: 1, cell: player1, want: wantLeftDown),
    (desc: "left", x1: 3, y1: 1, x2: 1, y2: 1, cell: player1, want: wantLeft),
    (desc: "right", x1: 1, y1: 1, x2: 3, y2: 1, cell: player1, want: wantLeft),
    (desc: "left down", x1: 3, y1: 1, x2: 1, y2: 3, cell: player1, want: wantLeftDown),
    (desc: "down", x1: 1, y1: 1, x2: 1, y2: 3, cell: player1, want: wantUp),
    (desc: "right down", x1: 1, y1: 1, x2: 3, y2: 3, cell: player1, want: wantRightDown),
  ]
  for tt in tests:
    checkpoint tt.desc
    var g = newGame()
    g.board.setLine(tt.x1, tt.y1, tt.x2, tt.y2, tt.cell)
    check tt.want == g.board

block:
  checkpoint "turnPlayer"
  var g = newGame()
  check g.currentPlayer == p1
  g.turnPlayer()
  check g.currentPlayer == p2

block:
  checkpoint "getPuttableObliqueLinePosition"
  var nilWant: RefCellPosition
  var g1 = newGame()
  g1.board[2, 2] = player2
  g1.board[2, 4] = player2
  let tests = [
    (desc: "ok: [right up] found", game: g1, x1: 1, y1: 3, x2: 3, y2: 1, cell: player1, want: RefCellPosition(x: 3, y: 1), err: false),
    (desc: "ng: [right up] not found when same position", game: newGame(), x1: 1, y1: 3, x2: 1, y2: 3, cell: player1, want: nilWant, err: true),
    (desc: "ng: [right up] not found when distance is 1", game: newGame(), x1: 1, y1: 3, x2: 2, y2: 2, cell: player1, want: nilWant, err: true),
    (desc: "ng: [right up] not found when no player2 cell", game: newGame(), x1: 1, y1: 3, x2: 3, y2: 1, cell: player1, want: nilWant, err: true),
    (desc: "ok: [right down] found", game: g1, x1: 1, y1: 3, x2: 3, y2: 5, cell: player1, want: RefCellPosition(x: 3, y: 5), err: false),
    (desc: "ok: [right down] found when over distance", game: g1, x1: 1, y1: 3, x2: 4, y2: 6, cell: player1, want: RefCellPosition(x: 3, y: 5), err: false),
    (desc: "ok: [right down] found when over distance (2)", game: g1, x1: 1, y1: 3, x2: 5, y2: 7, cell: player1, want: RefCellPosition(x: 3, y: 5), err: false),
    (desc: "ng: [right down] not found when same position", game: newGame(), x1: 1, y1: 3, x2: 1, y2: 3, cell: player1, want: nilWant, err: true),
    (desc: "ng: [right down] not found when distance is 1", game: newGame(), x1: 1, y1: 3, x2: 2, y2: 4, cell: player1, want: nilWant, err: true),
    (desc: "ng: [right down] not found when distance is 1", game: newGame(), x1: 1, y1: 3, x2: 3, y2: 5, cell: player1, want: nilWant, err: true),
    (desc: "ok: [left up] found", game: g1, x1: 3, y1: 3, x2: 1, y2: 1, cell: player1, want: RefCellPosition(x: 1, y: 1), err: false),
    (desc: "ng: [left up] not found when same position", game: newGame(), x1: 3, y1: 3, x2: 3, y2: 3, cell: player1, want: nilWant, err: true),
    (desc: "ng: [left up] not found when distance is 1", game: newGame(), x1: 3, y1: 3, x2: 2, y2: 2, cell: player1, want: nilWant, err: true),
    (desc: "ok: [left down] found", game: g1, x1: 3, y1: 3, x2: 1, y2: 5, cell: player1, want: RefCellPosition(x: 1, y: 5), err: false),
    (desc: "ng: [left down] not found when distance is 1", game: newGame(), x1: 3, y1: 3, x2: 2, y2: 4, cell: player1, want: nilWant, err: true),
  ]
  for tt in tests:
    checkpoint tt.desc
    var g = tt.game
    let got = g.board.getPuttableObliqueLinePosition(tt.x1, tt.y1, tt.x2, tt.y2, tt.cell)
    if tt.err:
      check got.isNil
      continue
    check tt.want[] == got[]
