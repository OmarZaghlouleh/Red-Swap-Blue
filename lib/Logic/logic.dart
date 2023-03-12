import 'package:red_swap_blue/Classes/algorithms.dart';
import 'package:red_swap_blue/Structure/structure.dart';

class Logic {
  Structure board;
  Algorithms algorithms = Algorithms();
  Logic(this.board);

  void initBoard() {
    board.printBoard();
    board.getNextStates(board.board, board.swapPosition);

    // List<Structure> nexStates =
    //     board.getNextStates(board.board, board.swapPosition);
    // List<Structure> newStates = nexStates[0]
    //     .getNextStates(nexStates[0].board, nexStates[0].swapPosition);
    // newStates[0].printBoard();
    // Algorithms.getHeuristic(newStates[0].board, newStates[0].swapPosition,
    //     board.realDimension, board.dimension);
    // for (var element in board.nextStates) {
    //   element.printBoard();
    // }
  }

  void userPlay() {
    board.moves = board.checkMoves();
    board.getNextStates(board.board, board.swapPosition);
  }

  void dfs(Function updateState, Function increaseMoves, Function cancelTimer,
      Algorithms algorithms) {
    algorithms.newDFS(
        board, updateState, increaseMoves, cancelTimer, algorithms);
  }

  Future<void> bfs(Function updateState, Function increaseMoves,
      Algorithms algorithms) async {
    await algorithms.newBFS(board, updateState, increaseMoves, algorithms);
  }

  Future<void> ucs(Function updateState, Function increaseMoves,
      Algorithms algorithms) async {
    await algorithms.newUCS(board, updateState, increaseMoves, algorithms);
  }

  Future<void> aStar(Function updateState, Function increaseMoves,
      Algorithms algorithms) async {
    await algorithms.aStar(board, updateState, increaseMoves, algorithms);
  }
}
