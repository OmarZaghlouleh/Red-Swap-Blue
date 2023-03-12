// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, unused_local_variable

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:graphite/core/typings.dart';
import 'package:red_swap_blue/Classes/position.dart';
import 'package:red_swap_blue/Structure/structure.dart';
import 'package:red_swap_blue/components/functions.dart';

import '../components/constants.dart';

class Algorithms {
  Map<Structure, List<Structure>> nodes = {};
  //For UI
  List<NodeInput> viewNodes = [];
  Map<String, int> addedNodes = {};
  int depthLimit = 4000;

  //For UI
  // List<Position> movesStack = [];
  // List<Position> parentsMoves = [];

  Future<void> addEdge(Structure parent, List<Structure> children) async {
    nodes.addEntries([MapEntry(parent, children)]);

    //Stop Algorithms
    List<String> next = [];
    //Add Children
    for (int i = 0; i < children.length; i++) {
      if (addedNodes.containsKey(jsonEncode(children[i].board))) {
        addedNodes.update(jsonEncode(children[i].board), (value) => value + 1);
        viewNodes.add(NodeInput(
            id: jsonEncode(children[i].board) +
                addedNodes.entries
                    .firstWhere((element) =>
                        element.key == jsonEncode(children[i].board))
                    .value
                    .toString(),
            next: []));
        next.add(jsonEncode(children[i].board) +
            addedNodes.entries
                .firstWhere(
                    (element) => element.key == jsonEncode(children[i].board))
                .value
                .toString());
      } else {
        addedNodes.putIfAbsent(jsonEncode(children[i].board), () => 1);
        viewNodes
            .add(NodeInput(id: '${jsonEncode(children[i].board)}1', next: []));
        next.add('${jsonEncode(children[i].board)}1');
      }
    }
    //Add Parent
    if (addedNodes.containsKey(jsonEncode(parent.board))) {
      int index = viewNodes.indexOf(viewNodes.firstWhere((element) =>
          element.id ==
          jsonEncode(parent.board) +
              addedNodes.entries
                  .firstWhere(
                      (element) => element.key == jsonEncode(parent.board))
                  .value
                  .toString()));
      viewNodes.removeAt(index);

      viewNodes.add(NodeInput(
          id: jsonEncode(parent.board) +
              addedNodes.entries
                  .firstWhere(
                      (element) => element.key == jsonEncode(parent.board))
                  .value
                  .toString(),
          next: next));
    } else {
      addedNodes.putIfAbsent(jsonEncode(parent.board), () => 1);
      viewNodes.add(NodeInput(id: '${jsonEncode(parent.board)}1', next: next));
    }
  }

  void printGraph() {
    print('***************************');
    print('Graph:');
    print(nodes);

    print('Graph:');
    print('***************************');
  }

  newDFS(
    Structure board,
    Function updateState,
    Function countMoves,
    Function cancelTimer,
    Algorithms algorithms,
  ) async {
    Stopwatch stopwatch = Stopwatch()..start();
    print('DFS is running'); //Init

    List<Structure> stack = [];
    HashMap visited = HashMap<int, bool>();
    Structure? path;
    bool isFound = false;
    int solveDepth = 0;
    int fullDepth = 0;
    //Add Root
    stack.add(board);
    while (stack.isNotEmpty) {
      Structure lastNode = stack.removeLast().cloneObject();
      if (visited.containsKey(lastNode.board.toString().hashCode)) continue;
      if (lastNode.depth > depthLimit) {
        stack.removeLast();
        fullDepth = lastNode.depth;
        continue;
      }

      if (lastNode.isFinal()) {
        print('Solved');
        print('Final Depth ${lastNode.depth}');
        lastNode.setDepth(lastNode.depth + 1);
        path = lastNode.cloneObject();
        isFound = true;
        solveDepth = lastNode.depth;
        break;
      }

      visited.putIfAbsent(lastNode.board.toString().hashCode, () => true);
      List<Structure> nextStates =
          lastNode.getNextStates(lastNode.board, lastNode.swapPosition);

      while (nextStates.isNotEmpty) {
        Structure currentNode = nextStates.removeAt(0).cloneObject();
        currentNode.setParent(lastNode);
        currentNode.setDepth(lastNode.depth + 1);

        if (!visited.containsKey(currentNode.board.toString().hashCode)) {
          if (currentNode.depth > depthLimit) {
            fullDepth = currentNode.depth;
            continue;
          } else {
            stack.add(currentNode);
          }
        }
      }
      if (isFound == true) break;
    }

    int time = stopwatch.elapsed.inMilliseconds;
    print('DFS is finished');
    print('Moves: ${visited.length}');
    print('Timer ${stopwatch.elapsed.inMilliseconds}');
    print('Getting Path...');
    countMoves(time, visited.length, 0, solveDepth,
        fullDepth == 0 ? solveDepth : fullDepth);

    List<Structure> realPath = [];
    if (path != null) realPath.add(path);

    while (path != null) {
      path = path.parent;
      if (path != null) {
        realPath.add(path);
      }
    }
    print('Cost: ${realPath.length}');
    int cost = 0;
    for (int i = realPath.length - 1; i >= 0; i--) {
      cost++;
      board.uiBoard = realPath[i].uiBoard;

      await Future.delayed(Duration.zero);
      countMoves(time, visited.length, cost, solveDepth,
          fullDepth == 0 ? solveDepth : fullDepth);
    }

    print('Visited: $visited');
    print('ــــــــــــــــــــــــــــــــــــــــ');
  }

  Future<void> newBFS(
    Structure board,
    Function updateState,
    Function countMoves,
    Algorithms algorithms,
  ) async {
    Stopwatch timer = Stopwatch()..start();
    Structure? solve;
    print('BFS is running'); //Init

    List<Structure> queue = [];
    HashedObserverList visited =
        HashedObserverList(); //List<Structure> path = [];

    //Add Root
    queue.add(board);

    bool isFound = false;
    int solveDepth = 0;
    int fullDepth = 0;
    while (queue.isNotEmpty) {
      Structure lastNode = queue.removeAt(0).cloneObject();

      if (lastNode.depth > depthLimit) {
        fullDepth = lastNode.depth;
        continue;
      }
      if (visited.contains(lastNode.board.toString().hashCode)) continue;
      visited.add(lastNode.board.toString().hashCode);
      //path.add(lastNode.cloneObject());

      List<Structure> nextStates =
          lastNode.getNextStates(lastNode.board, lastNode.swapPosition);

      while (nextStates.isNotEmpty) {
        Structure currentNode = nextStates.removeAt(0).cloneObject();
        currentNode.setParent(lastNode.cloneObject());
        currentNode.setDepth(lastNode.depth + 1);

        if (currentNode.isFinal()) {
          isFound = true;
          print('Solved');
          print('Final Depth ${currentNode.depth}');
          solve = currentNode.cloneObject();
          solveDepth = currentNode.depth;
          break;
        }
        if (!visited.contains(currentNode.board.toString().hashCode)) {
          if (currentNode.depth > depthLimit) {
            fullDepth = currentNode.depth;
            continue;
          } else {
            queue.add(currentNode);
            //visited.add(currentNode.board.toString().hashCode);
          }
        }
      }

      if (isFound == true) break;
    }
    int time = timer.elapsed.inMilliseconds;
    print('BFS is finished');
    print('Moves: ${visited.length}');
    print('Timer ${timer.elapsed.inMilliseconds}');
    print('Getting Path...');
    countMoves(time, visited.length, 0, solveDepth,
        fullDepth == 0 ? solveDepth : fullDepth);

    List<Structure> realPath = [];
    Structure finalMove = solve!.cloneObject();

    while (solve != null) {
      solve = solve.parent;
      if (solve != null) {
        realPath.add(solve);
      }
    }
    print('Cost: ${realPath.length}');
    int cost = 0;
    for (int i = realPath.length - 1; i >= 0; i--) {
      cost++;
      board.uiBoard = realPath[i].uiBoard;
      await Future.delayed(Duration.zero);
      countMoves(time, visited.length, cost, solveDepth,
          fullDepth == 0 ? solveDepth : fullDepth);
    }
    board.uiBoard = finalMove.uiBoard;
    print('ــــــــــــــــــــــــــــــــــــــــ');
  }

  Future<void> newUCS(
    Structure board,
    Function updateState,
    Function countMoves,
    Algorithms algorithms,
  ) async {
    Stopwatch timer = Stopwatch()..start();
    Structure? solve;
    print('UCS is running'); //Init

    List<Structure> queue = [];
    HashedObserverList visited = HashedObserverList();

    //Add Root
    queue.add(board);

    bool isFound = false;

    int solveDepth = 0;
    int fullDepth = 0;

    while (queue.isNotEmpty) {
      queue.sort((a, b) => a.depth.compareTo(b.depth));
      Structure lastNode = queue.removeAt(0).cloneObject();

      if (lastNode.depth > depthLimit) {
        fullDepth = lastNode.depth;
        continue;
      }
      if (visited.contains(lastNode.board.toString().hashCode)) continue;
      visited.add(lastNode.board.toString().hashCode);

      List<Structure> nextStates =
          lastNode.getNextStates(lastNode.board, lastNode.swapPosition);

      while (nextStates.isNotEmpty) {
        Structure currentNode = nextStates.removeAt(0).cloneObject();
        currentNode.setParent(lastNode.cloneObject());
        currentNode.setDepth(lastNode.depth + 1);

        if (currentNode.isFinal()) {
          isFound = true;
          print('Solved');
          print('Final Depth ${currentNode.depth}');
          solve = currentNode.cloneObject();
          solveDepth = currentNode.depth;
          break;
        }
        if (!visited.contains(currentNode.board.toString().hashCode)) {
          if (currentNode.depth > depthLimit) {
            fullDepth = currentNode.depth;
            continue;
          } else {
            queue.add(currentNode);
            //visited.add(currentNode.board.toString().hashCode);
          }
        }
      }

      if (isFound == true) break;
    }
    int time = timer.elapsed.inMilliseconds;
    print('UCS is finished');
    print('Moves: ${visited.length}');
    print('Timer ${timer.elapsed.inMilliseconds}');
    print('Getting Path...');
    countMoves(time, visited.length, 0, solveDepth,
        fullDepth == 0 ? solveDepth : fullDepth);
    Structure finalMove = solve!;
    List<Structure> realPath = [];
    while (solve != null) {
      solve = solve.parent;
      if (solve != null) {
        realPath.add(solve);
      }
    }
    print('Cost: ${realPath.length}');
    int cost = 0;
    for (int i = realPath.length - 1; i >= 0; i--) {
      cost++;
      board.uiBoard = realPath[i].uiBoard;
      await Future.delayed(Duration.zero);
      countMoves(time, visited.length, cost, solveDepth,
          fullDepth == 0 ? solveDepth : fullDepth);
    }
    board.uiBoard = finalMove.uiBoard;
    print('ــــــــــــــــــــــــــــــــــــــــ');
  }

  Future<void> aStar(
    Structure board,
    Function updateState,
    Function countMoves,
    Algorithms algorithms,
  ) async {
    Stopwatch timer = Stopwatch()..start();
    Structure? solve;
    print('A* is running'); //Init

    List<Structure> queue = [];
    Map<int, bool> visited = {};

    //Add Root
    queue.add(board);

    bool isFound = false;

    int solveDepth = 0;
    int fullDepth = 0;

    while (queue.isNotEmpty) {
      queue.sort((a, b) {
        if (a.totalCost.compareTo(b.totalCost) == 0)
          return a.heuristicValue.compareTo(b.heuristicValue);
        return a.totalCost.compareTo(b.totalCost);
      });

      Structure lastNode = queue.removeAt(0).cloneObject();

      if (visited.containsKey(lastNode.board.toString().hashCode) == true)
        continue;
      visited.putIfAbsent(lastNode.board.toString().hashCode, () => true);

      List<Structure> nextStates =
          lastNode.getNextStates(lastNode.board, lastNode.swapPosition);

      while (nextStates.isNotEmpty) {
        Structure currentNode = nextStates.removeAt(0).cloneObject();
        currentNode.setParent(lastNode.cloneObject());
        currentNode.setCost(lastNode.cost + 1);
        currentNode.setDepth(lastNode.depth + 1);

        if (currentNode.isFinal()) {
          isFound = true;
          print('Solved');
          print('Final Depth ${currentNode.depth}');
          int cost = getHeuristic(
              currentNode.board,
              currentNode.bluesPosition,
              currentNode.redsPosition,
              board.swapPosition,
              currentNode.realDimension,
              currentNode.dimension);
          currentNode.setTotalCost(cost.toDouble());
          solve = currentNode.cloneObject();
          solveDepth = currentNode.depth;
          break;
        }
        if (!visited.containsKey(currentNode.board.toString().hashCode)) {
          int cost = getHeuristic(
              currentNode.board,
              currentNode.bluesPosition,
              currentNode.redsPosition,
              board.swapPosition,
              currentNode.realDimension,
              currentNode.dimension);
          currentNode.setTotalCost(cost.toDouble() + currentNode.cost);
          currentNode.setheuristicValue(cost.toDouble());
          bool isIn = false;
          for (var state in queue) {
            if (state.board.toString().hashCode ==
                currentNode.board.toString().hashCode) {
              {
                if (currentNode.cost < state.cost)
                  state = currentNode.cloneObject();
                isIn = true;
                break;
              }
            }
          }
          if (isIn == false) queue.add(currentNode);
        } else {}
      }

      if (isFound == true) break;
    }

    int time = timer.elapsed.inMilliseconds;
    print('A* is finished');
    print('Moves: ${visited.length}');
    print('Timer ${timer.elapsed.inMilliseconds}');
    countMoves(time, visited.length, 0, solveDepth,
        fullDepth == 0 ? solveDepth : fullDepth);
    if (isFound) {
      print('Getting Path...');

      Structure finalMove = solve!;
      List<Structure> realPath = [];
      while (solve != null) {
        solve = solve.parent;
        if (solve != null) {
          realPath.add(solve);
        }
      }
      print('Cost: ${realPath.length}');
      int cost = 0;
      for (int i = realPath.length - 1; i >= 0; i--) {
        cost++;
        board.uiBoard = realPath[i].uiBoard;
        await Future.delayed(const Duration(milliseconds: 250));
        countMoves(time, visited.length, realPath.length, solveDepth,
            fullDepth == 0 ? solveDepth : fullDepth);
      }
      board.uiBoard = finalMove.uiBoard;
    } else
      print('Not Solved');
    print('ــــــــــــــــــــــــــــــــــــــــ');
  }

  static int getHeuristic(
      List<List<dynamic>> targetBoard,
      List<Position> blues,
      List<Position> reds,
      Position swapPosition,
      int realDimension,
      dimension) {
    //print('Called');
    double answer = 0;
    List<Position> bluesPosition = [];
    List<Position> redsPosition = [];

    for (int i = 0; i < targetBoard.length; i++) {
      for (int j = 0; j < targetBoard[i].length; j++) {
        if (i < realDimension ~/ 2 && dimension - j >= 1) {
          if (targetBoard[i][j] != CellType.B.name) {
            answer++;
            if (targetBoard[i][j] == CellType.R.name)
              redsPosition.add(Position(i, j));
          }
        } else if (i > realDimension ~/ 2 && dimension - j <= 1) {
          if (targetBoard[i][j] != CellType.R.name) {
            answer++;
            if (targetBoard[i][j] == CellType.B.name)
              bluesPosition.add(Position(i, j));
          }
        } else if (i == realDimension ~/ 2) {
          if (dimension - j > 1) {
            if (targetBoard[i][j] != CellType.B.name) {
              answer++;
              if (targetBoard[i][j] == CellType.R.name)
                redsPosition.add(Position(i, j));
            }
          } else if (dimension - j < 1) {
            if (targetBoard[i][j] != CellType.R.name) {
              answer++;
              if (targetBoard[i][j] == CellType.B.name)
                bluesPosition.add(Position(i, j));
            }
          } else {
            if (targetBoard[i][j] != CellType.S.name) {
              answer++;
              if (targetBoard[i][j] == CellType.B.name) {
                bluesPosition.add(Position(i, j));
                answer += 0.5;
              } else {
                redsPosition.add(Position(i, j));
                answer += 0.5;
              }
            }
          }
        }
      }
    }

    double minValue = 100000000.0;

    bool inRed = true;
    double answer2 = 0;
    for (var blue in bluesPosition) {
      double min = 1000000000;
      for (var red in reds) {
        double manhatten =
            getMahattanDistance(blue.row, red.row, blue.column, red.column);
        if (manhatten < min) min = manhatten * 2;
      }
      answer2 += min * 2;
    }

    for (var red in redsPosition) {
      double min = 1000000000;
      for (var blue in blues) {
        double manhatten =
            getMahattanDistance(blue.row, red.row, blue.column, red.column);
        if (manhatten < min) min = manhatten * 2;
      }
      answer2 += min * 2;
    }

    for (var blue in blues) {
      if (blue.row == swapPosition.row && blue.column == swapPosition.column) {
        inRed = false;
        break;
      }
    }

    if (inRed) {
      for (var blue in bluesPosition) {
        double distance = getMahattanDistance(
            blue.row, swapPosition.row, blue.column, swapPosition.column);

        if (distance < minValue) minValue = distance * 2;
      }
    } else {
      for (var red in redsPosition) {
        double distance = getMahattanDistance(
            red.row, swapPosition.row, red.column, swapPosition.column);

        if (distance < minValue) minValue = distance * 2;
      }
    }

    if (minValue == 100000000) minValue = 0;
    print('Heuristic Value: ${answer2 + minValue}');

    return (answer2 + minValue).toInt();
  }
}
