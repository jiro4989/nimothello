import sequtils

type
  Game* = object
    board: Board
    currentPlayer: Player
  Board* = array[10, array[10, Cell]]
    ## ゲーム板を表す型。
    ## 
    ## オセロのコマの配置可能な範囲は通常 8 x 8 だが、壁を表現するために 10 x 10 で定義する。
    ## つまり、一番外の枠は常に壁セルが配置される。
    ## 壁セルは Cell.wall で表現する。
    ## 図示すると以下のようになる。
    ## 
    ##   | a b c d e f g h i j
    ## --+--------------------
    ## 0 | 0 0 0 0 0 0 0 0 0 0 
    ## 1 | 0 - - - - - - - - 0
    ## 2 | 0 - - - - - - - - 0
    ## 3 | 0 - - - - - - - - 0
    ## 4 | 0 - - - 2 3 - - - 0
    ## 5 | 0 - - - 3 2 - - - 0
    ## 6 | 0 - - - - - - - - 0
    ## 7 | 0 - - - - - - - - 0
    ## 8 | 0 - - - - - - - - 0
    ## 9 | 0 0 0 0 0 0 0 0 0 0 
  Cell* {.pure.} = enum
    wall, empty, player1, player2
    ## セルの状態を表現する。
  CellPosition* = object
    x, y: int
  Player* {.pure.} = enum
    p1, p2

func newBoard*(): Board =
  ## ゲーム板を生成する。
  discard

func newGame*(): Game =
  ## ゲームインスタンスを生成する。
  discard

func `[]`*(self: Board, x, y: int): Cell =
  ## x, y座標のセルを返す。
  discard

func `[]=`*(self: var Board, x, y: int, cell: Cell) =
  ## x, y座標のセルを返す。
  self[y][x] = cell

func countScore(self: Board, cellType: Cell): int =
  for row in self:
    for cell in row:
      if cell == cellType:
        inc result

func getPlayer1Score*(self: Game): int = 
  ## プレイヤー1の得点を返す。
  self.board.countScore(player1)

func getPlayer2Score*(self: Game): int = 
  ## プレイヤー2の得点を返す。
  self.board.countScore(player2)

func player2Cell(p: Player): Cell =
  case p
  of p1: player1
  of p2: player2

func setLineVertical(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 垂直方向にコマを配置する。
  for y in y1..y2:
    self[x1, y] = cell

func setLineHorizontal(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 水平方向にコマを配置する。
  for x in x1..x2:
    self[x, y1] = cell

func setLineOblique(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 斜め方向にコマを配置する。
  for x in x1..x2:
    block yBlock:
      for y in y1..y2:
        if x == y:
          self[x, y1] = cell
          break yBlock

func setLine(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 直線上のセルを反転する。
  if y1 == y2:
    self.setLineHorizontal x1, y1, x2, y2, cell
    return
  if x1 == x2:
    self.setLineVertical x1, y1, x2, y2, cell
    return
  self.setLineOblique x1, y1, x2, y2, cell

func putCell*(self: Game, x, y: int): int = 
  discard

func getPuttableCellPositions(self: Board, x, y: int, cell: Cell): seq[CellPosition] =
  # 1. 左上
  # 2. 上
  # 3. 右上
  # 4. 左
  # 5. 右
  # 6. 左下
  # 7. 下
  # 8. 右下
  discard

func getPuttableCellPositions(self: Game): seq[CellPosition] =
  let
    playerCell = self.currentPlayer.player2Cell
    board = self.board

  for y, row in board:
    for x, cell in row:
      if cell != playerCell:
        continue
      for pos in board.getPuttableCellPositions(x, y, playerCell):
        result.add pos
  
  deduplicate result