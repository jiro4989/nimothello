import illwill
import models

type
  GameView = object
    buf: TerminalBuffer
    boardView: BoardView
    scoreView: ScoreView
    currentPlayerView: CurrentPlayerView
    helpView: HelpView

  BoardView = object
    ## オセロ盤を表示するビュー。
    x, y: int
    board: Board
  
  ScoreView = object
    ## プレイヤーの得点を表示するビュー。
    x, y: int

  CurrentPlayerView = object
    ## 現在の操作プレイヤーを表示するビュー。
    x, y: int
  
  HelpView = object
    ## ヘルプメッセージを表示するビュー。
    x, y: int

proc newBoardView(): BoardView =
  discard
  
proc newScoreView(): ScoreView =
  discard
  
proc newCurrentPlayerView(): CurrentPlayerView =
  discard
  
proc newHelpView(): HelpView =
  discard

proc newGameView*(): GameView =
  discard

proc draw*(self: BoardView, buf: TerminalBuffer) =
  discard
  
proc draw*(self: ScoreView, buf: TerminalBuffer) =
  discard
  
proc draw*(self: CurrentPlayerView, buf: TerminalBuffer) =
  discard
  
proc draw*(self: HelpView, buf: TerminalBuffer) =
  discard
  
proc draw*(self: GameView) =
  self.boardView.draw(self.buf)
  self.scoreView.draw(self.buf)
  self.currentPlayerView.draw(self.buf)
  self.helpView.draw(self.buf)
  
proc width*(self: BoardView): int =
  discard
  
proc height*(self: BoardView): int =
  discard