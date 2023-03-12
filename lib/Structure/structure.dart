// ignore_for_file: avoid_print

import 'package:red_swap_blue/Classes/position.dart';
import 'package:red_swap_blue/components/constants.dart';

class Structure {
  int dimension;
  late List<List> board;
  late List targetBoard;
  late List<List> uiBoard;
  late Position swapPosition;
  late int realDimension;
  Structure? parent;
  PlayerType playerType;
  List<Position> bluesPosition = [];
  List<Position> redsPosition = [];

  //Position boardMove = Position(0, 0);
  int depth = 0;
  int cost = 0;
  double totalCost = 0;
  double heuristicValue = 0;

  //For UI
  List<Structure> nextStates = [];
  List<Position> moves = [];

  setDepth(int depth) {
    this.depth = depth;
  }

  setCost(int cost) {
    this.cost = cost;
  }

  setTotalCost(double totalCost) {
    this.totalCost = totalCost;
  }

  setheuristicValue(double heuristicValue) {
    this.heuristicValue = heuristicValue;
  }

  double get getTotalCost => totalCost;
  double get getheuristicValue => heuristicValue;

  setParent(Structure parent) {
    this.parent = parent;
  }

  Structure(this.dimension, this.swapPosition, this.playerType) {
    realDimension = (dimension * 2) - 1;
    targetBoard = getTargetBoard(dimension);
    board = initBoard(realDimension, dimension);
    uiBoard = List.generate(realDimension,
        (index) => List.generate(realDimension, (index) => CellType.E.name),
        growable: false);
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        uiBoard[i][j] = board[i][j] + '$i$j';
      }
    }

    //print(uiBoard);
  }

  List<List> initBoard(int realDimension, int dimension) {
    List<List> initialBoard = List.generate(realDimension,
        (index) => List.generate(realDimension, (index) => CellType.E.name),
        growable: false);

    for (int i = 0; i < initialBoard.length; i++) {
      for (int j = 0; j < initialBoard[i].length; j++) {
        if (i < realDimension ~/ 2 && dimension - j >= 1) {
          initialBoard[i][j] = CellType.R.name;
          redsPosition.add(Position(i, j));
        } else if (i > realDimension ~/ 2 && dimension - j <= 1) {
          initialBoard[i][j] = CellType.B.name;
          bluesPosition.add(Position(i, j));
        } else if (i == realDimension ~/ 2) {
          if (dimension - j > 1) {
            initialBoard[i][j] = CellType.R.name;
            redsPosition.add(Position(i, j));
          } else if (dimension - j < 1) {
            initialBoard[i][j] = CellType.B.name;
            bluesPosition.add(Position(i, j));
          } else {
            initialBoard[i][j] = CellType.S.name;
          }
        }
      }
    }
    return initialBoard;
  }

  List<List> getTargetBoard(int dimension) {
    List<List> targetBoard = List.generate(realDimension,
        (index) => List.generate(realDimension, (index) => CellType.E.name),
        growable: false);

    for (int i = 0; i < targetBoard.length; i++) {
      for (int j = 0; j < targetBoard[i].length; j++) {
        if (i < realDimension ~/ 2 && dimension - j >= 1) {
          targetBoard[i][j] = CellType.B.name;
        } else if (i > realDimension ~/ 2 && dimension - j <= 1) {
          targetBoard[i][j] = CellType.R.name;
        } else if (i == realDimension ~/ 2) {
          if (dimension - j > 1) {
            targetBoard[i][j] = CellType.B.name;
          } else if (dimension - j < 1) {
            targetBoard[i][j] = CellType.R.name;
          } else {
            targetBoard[i][j] = CellType.S.name;
          }
        }
      }
    }
    return targetBoard;
  }

  void setSwapPosition(Position newPosition) {
    swapPosition = newPosition;
  }

  List<Position> checkMoves() {
    List<Position> newPossibleBoards = [];

    //Right
    if (swapPosition.column + 1 < realDimension &&
        board[swapPosition.row][swapPosition.column + 1] != 'E') {
      //print('Right');
      newPossibleBoards
          .add(Position(swapPosition.row, swapPosition.column + 1));
    }

    //Right 2
    if (swapPosition.column + 2 < realDimension &&
        board[swapPosition.row][swapPosition.column + 2] != 'E') {
      //print('Right 2');

      newPossibleBoards
          .add(Position(swapPosition.row, swapPosition.column + 2));
    }
    //Left
    if (swapPosition.column - 1 >= 0 &&
        board[swapPosition.row][swapPosition.column - 1] != 'E') {
      //print('Left');
      newPossibleBoards
          .add(Position(swapPosition.row, swapPosition.column - 1));
    }

    //Left 2
    if (swapPosition.column - 2 >= 0 &&
        board[swapPosition.row][swapPosition.column - 2] != 'E') {
      //print('Left 2');
      newPossibleBoards
          .add(Position(swapPosition.row, swapPosition.column - 2));
    }

    //Up
    if (swapPosition.row - 1 >= 0 &&
        board[swapPosition.row - 1][swapPosition.column] != 'E') {
      //print('Up');
      newPossibleBoards
          .add(Position(swapPosition.row - 1, swapPosition.column));
    }

    //Up 2
    if (swapPosition.row - 2 >= 0 &&
        board[swapPosition.row - 2][swapPosition.column] != 'E') {
      //print('Up 2');
      newPossibleBoards
          .add(Position(swapPosition.row - 2, swapPosition.column));
    }

    //Down
    if (swapPosition.row + 1 < realDimension &&
        board[swapPosition.row + 1][swapPosition.column] != 'E') {
      // print('Down');
      newPossibleBoards
          .add(Position(swapPosition.row + 1, swapPosition.column));
    }

    //Down 2
    if (swapPosition.row + 2 < realDimension &&
        board[swapPosition.row + 2][swapPosition.column] != 'E') {
      //print('Down 2');
      newPossibleBoards
          .add(Position(swapPosition.row + 2, swapPosition.column));
    }
    return newPossibleBoards;
  }

  void move(Position movingPosition) {
    String colorCell = board[movingPosition.row][movingPosition.column];
    String swapCell = board[swapPosition.row][swapPosition.column];

    String uiColorCell = uiBoard[movingPosition.row][movingPosition.column];
    String uiSwapCell = uiBoard[swapPosition.row][swapPosition.column];

    board[movingPosition.row][movingPosition.column] = swapCell;
    board[swapPosition.row][swapPosition.column] = colorCell;

    uiBoard[movingPosition.row][movingPosition.column] = uiSwapCell;
    uiBoard[swapPosition.row][swapPosition.column] = uiColorCell;

    setSwapPosition(movingPosition);
  }

  void printBoard() {
    for (var row in board) {
      print(row.toString());
    }
    print('ــــــــــــــــــــــــــــــــــ');
  }

  List<Structure> getNextStates(List<List> board, Position swapPosition) {
    List<Structure> nextBoards = [];

    List<Position> possiblePositions = checkMoves();
    if (playerType == PlayerType.User) moves.clear();
    moves.addAll(possiblePositions);

    for (var element in possiblePositions) {
      Structure newBoard = cloneObject();

      newBoard.move(element);

      nextBoards.add(newBoard);
    }
    //print('******************************************************');
    //For UI
    nextStates.clear();
    nextStates.addAll(nextBoards);
    //edges.addAll(nextBoards);
    return nextBoards;
  }

  bool isFinal() {
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        if (board[i][j].toString() != targetBoard[i][j].toString()) {
          return false;
        }
      }
    }
    return true;
  }

  Structure cloneObject() {
    Structure newBoard = Structure(dimension, swapPosition, playerType);

    for (int i = 0; i < newBoard.board.length; i++) {
      for (int j = 0; j < newBoard.board[i].length; j++) {
        newBoard.board[i][j] = board[i][j];
        newBoard.uiBoard[i][j] = uiBoard[i][j];
      }
    }
    newBoard.swapPosition = swapPosition;
    newBoard.nextStates.addAll(nextStates);
    // moves.forEach((element) {
    //   newBoard.moves.add(element);
    // });
    newBoard.parent = parent;
    newBoard.depth = depth;
    newBoard.totalCost = totalCost;
    newBoard.heuristicValue = heuristicValue;
    newBoard.cost = cost;

    //newBoard.boardMove = move;

    return newBoard;
  }

  bool isContainMove(Position move) {
    List<Position> newMoves = checkMoves();
    for (var element in newMoves) {
      if (element.row == move.row && element.column == move.column) return true;
    }

    return false;
  }
}
