import sequtils, math

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
  RefCellPosition = ref CellPosition
  Player* {.pure.} = enum
    p1, p2
  GameStatus* {.pure.} = enum
    isRunning, isFinished

func newBoard*(): Board =
  ## ゲーム板を生成する。
  result =
    [
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, player1, player2, empty, empty, empty, wall],
      [wall, empty, empty, empty, player2, player1, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
      [wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
    ]

func newGame*(): Game =
  ## ゲームインスタンスを生成する。
  result = Game(board: newBoard(), currentPlayer: p1)

func getStatus*(self: Game): GameStatus =
  var emptyCount: int
  for row in self.board:
    for cell in row:
      if cell == empty:
        inc emptyCount

  result =
    if 0 < emptyCount:
      isRunning
    else:
      isFinished

func isRunning*(self: Game): bool =
  self.getStatus == GameStatus.isRunning

func isFinished*(self: Game): bool =
  self.getStatus == GameStatus.isFinished

func `[]`*(self: Board, x, y: int): Cell =
  ## x, y座標のセルを返す。
  self[y][x]

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

func playerToCell(p: Player): Cell =
  case p
  of p1: player1
  of p2: player2

func inclCnt(a, b: int): int =
  result =
    if a < b: 1
    else: -1

func setLineVertical(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 垂直方向にコマを配置する。
  ## 高さが下から上方向でもOK.
  let yp = inclCnt(y1, y2)
  let diff = abs(y1 - y2)
  var y = y1
  for i in 1..diff+1:
    self[x1, y] = cell
    y += yp

func setLineHorizontal(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 水平方向にコマを配置する。
  ## 右から左方向の配置でもOK.
  let xp = inclCnt(x1, x2)
  let diff = abs(x1 - x2)
  var x = x1
  for i in 1..diff+1:
    self[x, y1] = cell
    x += xp

func setLineOblique(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 斜め方向にコマを配置する。
  let xp = inclCnt(x1, x2)
  let yp = inclCnt(y1, y2)
  let diff = abs(x1 - x2)
  var
    x = x1
    y = y1
  for i in 1..diff+1:
    self[x, y] = cell
    x += xp
    y += yp

func setLine*(self: var Board, x1, y1, x2, y2: int, cell: Cell) =
  ## 直線上のセルを反転する。
  var
    x1 = x1
    x2 = x2
    y1 = y1
    y2 = y2

  if x2 < x1: swap(x1, x2)
  if y2 < y1: swap(y1, y2)
  if y1 == y2:
    self.setLineHorizontal x1, y1, x2, y2, cell
    return
  if x1 == x2:
    self.setLineVertical x1, y1, x2, y2, cell
    return
  self.setLineOblique x1, y1, x2, y2, cell

func turnPlayer(self: var Game) =
  let p = self.currentPlayer
  self.currentPlayer =
    case p
    of p1: p2
    of p2: p1

func getPuttableObliqueLinePosition(self: Board, x1, y1, x2, y2: int, cell: Cell): RefCellPosition =
  ## 斜め方向にコマを配置する。
  var
    x1 = x1
    x2 = x2
    y1 = y1
    y2 = y2

  if x2 < x1: swap(x1, x2)
  if y2 < y1: swap(y1, y2)
  for x2 in x1..x2:
    for y2 in y1..y2:
      if x2 != y2:
        continue
      # 自分のセルか壁が見つかったら早期リターン
      if self[x2, y2] in [cell, wall]:
        return
      # 空のセルが見つかったら返す。
      # ただし元セルに隣接する場合はNG
      if self[x2, y2] == empty:
        if abs(x1 - x2) == 1:
          return nil
        return RefCellPosition(x: x2, y: y2)
      # それ以外のときは相手のセルなのでスルー

func getPuttableHotizontalLinePosition(self: Board, x1, y1, x2, y2: int, cell: Cell): RefCellPosition =
  ## 水平方向にコマを配置する。
  let rng =
    block:
      var n: seq[int]
      if x1 < x2:
        for x in x1+1..x2:
          n.add x
        n
      else:
        for x in countdown(x2-1, x1):
          n.add x
        n
  
  for x in rng:
    let c = self[x, y2]
    debugEcho x
    debugEcho y2
    debugEcho c
    # 自分のセルか壁が見つかったら早期リターン
    if c in [cell, wall]:
      return
    # 空のセルが見つかったら返す。
    # ただし元セルに隣接する場合はNG
    if c == empty:
      if abs(x1 - x) == 1:
        return nil
      return RefCellPosition(x: x, y: y2)
    # それ以外のときは相手のセルなのでスルー

func getPuttableVerticalLinePosition(self: Board, x1, y1, x2, y2: int, cell: Cell): RefCellPosition =
  ## 垂直方向にコマを配置する。
  var
    x1 = x1
    x2 = x2
    y1 = y1
    y2 = y2

  if x2 < x1: swap(x1, x2)
  if y2 < y1: swap(y1, y2)
  for y2 in y1..y2:
    # 自分のセルか壁が見つかったら早期リターン
    if self[x2, y2] in [cell, wall]:
      return
    # 空のセルが見つかったら返す。
    # ただし元セルに隣接する場合はNG
    if self[x2, y2] == empty:
      if abs(y1 - y2) == 1:
        return nil
      return RefCellPosition(x: x2, y: y2)
    # それ以外のときは相手のセルなのでスルー

func getFarestPosition(self: Board, x, y, xp, yp: int): RefCellPosition =
  var
    x = x
    y = y

  while true:
    if x <= 0 or self[0].len < x or y <= 0 or self.len < y:
      return RefCellPosition(x: x, y: y)

    x += xp
    y += yp

func getPuttableCellPositions(self: Board, x, y: int, cell: Cell): seq[CellPosition] =
  template checkAdd(pos: RefCellPosition, fn: proc(self: Board, x, y, xp, yp: int, cell: Cell): RefCellPosition) =
    if not pos.isNil:
      debugEcho pos[]
      let got = self.fn(pos.x, pos.y, x, y, cell)
      if not got.isNil:
        result.add got[]

  # 1. 左上
  checkAdd(self.getFarestPosition(x, y, -1, -1), getPuttableObliqueLinePosition)

  # 2. 上
  checkAdd(self.getFarestPosition(x, y, 0, -1), getPuttableVerticalLinePosition)

  # 3. 右上
  checkAdd(self.getFarestPosition(x, y, 1, -1), getPuttableObliqueLinePosition)

  # 4. 左
  checkAdd(self.getFarestPosition(x, y, -1, 0), getPuttableHotizontalLinePosition)

  # 5. 右
  checkAdd(self.getFarestPosition(x, y, 1, 0), getPuttableHotizontalLinePosition)

  # 6. 左下
  checkAdd(self.getFarestPosition(x, y, -1, 1), getPuttableObliqueLinePosition)

  # 7. 下
  checkAdd(self.getFarestPosition(x, y, 0, 1), getPuttableVerticalLinePosition)

  # 8. 右下
  checkAdd(self.getFarestPosition(x, y, 1, 1), getPuttableObliqueLinePosition)

func getPuttableCellPositions(self: Game): seq[CellPosition] =
  let
    playerCell = self.currentPlayer.playerToCell
    board = self.board

  for y, row in board:
    for x, cell in row:
      if cell != playerCell:
        continue
      for pos in board.getPuttableCellPositions(x, y, playerCell):
        result.add pos
  
  deduplicate result

func putCell*(self: var Game, x, y: int) = 
  ## 現在のプレイヤーに対応するセルを指定の座標のセルにセットする。
  ## セットの結果反転される箇所があれば反転される。
  let cell = self.currentPlayer.playerToCell
  let poses = self.board.getPuttableCellPositions(x, y, cell)
  debugEcho poses
  for pos in poses:
    self.board.setLine x, y, pos.x, pos.y, cell
  self.board[x, y] = cell
  self.turnPlayer()

func getBoard*(self: Game): Board =
  self.board

func debugPrint*(self: Board) =
  for row in self:
    var line: string
    for cell in row:
      let s =
        case cell
        of wall: "w"
        of empty: "-"
        of player1: "1"
        of player2: "2"
      line.add s
      line.add " "
    debugEcho line
