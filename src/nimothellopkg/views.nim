from terminal import eraseScreen
import os, strutils, strformat
import illwill
import models

type
  GameView = ref object
    buf: TerminalBuffer
    boardView: BoardView
    scoreView: ScoreView
    currentPlayerView: CurrentPlayerView
    timeView: TimeView
    helpView: HelpView

  BoardView = object
    ## オセロ盤を表示するビュー。
    x, y: int
  
  ScoreView = object
    ## プレイヤーの得点を表示するビュー。
    x, y: int

  CurrentPlayerView = object
    ## 現在の操作プレイヤーを表示するビュー。
    x, y: int
  
  TimeView = object
    ## 経過時間を表示するビュー。
    x, y: int
  
  HelpView = object
    ## ヘルプメッセージを表示するビュー。
    x, y: int

const
  rightViewWidth = 26

proc printResult*(self: Game) =
  let
    p1 = self.getPlayer1Score
    p2 = self.getPlayer2Score
    winner =
      if p1 < p2: "PLAYER2"
      elif p2 < p1: "PLAYER1"
      else: "NONE"
    elapsedTime = self.getElapsedTime()
  echo &"""
ELAPSED TIME:
  {elapsedTime} sec

SCORE:
  PLAYER1 = {p1}
  PLAYER2 = {p2}

WINNER:
  {winner}
"""

proc exitProc*() {.noconv.} =
  ## 終了処理
  illwillDeinit()
  showCursor()
  eraseScreen()

proc init =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()

init()

proc newBoardView(): BoardView =
  BoardView(x: 0, y: 0)
  
proc newScoreView(): ScoreView =
  ScoreView(x: 22, y: 0)
  
proc newCurrentPlayerView(): CurrentPlayerView =
  CurrentPlayerView(x: 22, y: 4)
  
proc newTimeView(): TimeView =
  TimeView(x: 22, y: 7)
  
proc newHelpView(): HelpView =
  HelpView(x: 0, y: 11)

proc newTerminal: TerminalBuffer =
  let
    w = terminalWidth()
    h = terminalHeight()
  result = newTerminalBuffer(w, h)

proc newGameView*(): GameView =
  var buf = newTerminal()
  result = GameView(
    buf: buf,
    boardView: newBoardView(),
    scoreView: newScoreView(),
    currentPlayerView: newCurrentPlayerView(),
    timeView: newTimeView(),
    helpView: newHelpView(),
  )

proc color(c: Cell): BackgroundColor =
  case c
  of empty: bgNone
  of wall: bgWhite
  of player1: bgNone
  of player2: bgNone

proc text(c: Cell): string =
  case c
  of empty: "  "
  of wall: "  "
  of player1: "00"
  of player2: "--"

proc draw*(self: BoardView, buf: var TerminalBuffer, game: Game) =
  buf = newTerminal()
  let poses = game.getPuttableCellPositions()
  for yy, row in game.getBoard:
    for xx, cell in row:
      let
        x = xx + self.x
        y = yy + self.y
        pos = newCellPosition(x, y)
        cursol = game.getCursol
      if pos == cursol:
        buf.setForegroundColor(fgBlack)
        buf.setBackgroundColor(bgGreen)
      else:
        buf.setForegroundColor(fgWhite)
        buf.setBackgroundColor(cell.color)

      if pos in poses:
        buf.write(x*2, y, "**")
      else:
        buf.write(x*2, y, cell.text)

      buf.resetAttributes()

template draw(buf: var TerminalBuffer, x, y: int, text: string, alignCount: int, fg: ForegroundColor, bg: BackgroundColor, blight: bool) =
  buf.setForegroundColor(fg, blight)
  buf.setBackgroundColor(bg)
  buf.write(x, y, " " & text.alignLeft(alignCount+1))
  buf.resetAttributes()

proc drawHeader(buf: var TerminalBuffer, x, y: int, text: string, alignCount: int) =
  buf.draw(x, y, text, alignCount, fgWhite, bgBlack, true)
  
proc drawBody(buf: var TerminalBuffer, x, y: int, text: string, alignCount: int) =
  buf.draw(x, y, text, alignCount, fgBlack, bgWhite, false)
  
proc draw*(self: ScoreView, buf: var TerminalBuffer, game: Game) =
  let
    p1Score = game.getPlayer1Score()
    p2Score = game.getPlayer2Score()
    x = self.x
    y = self.y
  buf.drawHeader(x, y, "SCORE", rightViewWidth)
  buf.drawBody(x, y+1, &"PLAYER1 {p1Score}", rightViewWidth)
  buf.drawBody(x, y+2, &"PLAYER2 {p2Score}", rightViewWidth)
  buf.resetAttributes()
  
proc draw*(self: CurrentPlayerView, buf: var TerminalBuffer, game: Game) =
  let
    name = game.getCurrentPlayerName()
    x = self.x
    y = self.y
  buf.drawHeader(x, y, "CURRENT PLAYER", rightViewWidth)
  buf.drawBody(x, y+1, name, rightViewWidth)
  buf.resetAttributes()
  
proc draw*(self: TimeView, buf: var TerminalBuffer, game: Game) =
  let
    x = self.x
    y = self.y
    elapsedTime = game.getElapsedTime()
  buf.drawHeader(x, y, "TIME", rightViewWidth)
  buf.drawBody(x, y+1, &"{elapsedTime} sec", rightViewWidth)
  buf.resetAttributes()

proc draw*(self: HelpView, buf: var TerminalBuffer) =
  let
    x = self.x
    y = self.y
    width = 48
  buf.drawHeader(x, y, "KEYS", width)
  buf.drawBody(x, y+1, "LEFT = H,A | DOWN = J,S | UP = K,W | RIGHT = L,F", width)
  buf.drawBody(x, y+2, "ENTER = PUT CELL    | QUIT = ESC", width)
  buf.resetAttributes()
  
proc draw*(self: GameView, game: Game) =
  self.boardView.draw(self.buf, game)
  self.scoreView.draw(self.buf, game)
  self.currentPlayerView.draw(self.buf, game)
  self.timeView.draw(self.buf, game)
  self.helpView.draw(self.buf)
  self.buf.display()

when isMainModule:
  var gv = newGameView()
  var game = newGame()
  sleep 1000
  gv.draw(game)
  sleep 3000
  exitProc()