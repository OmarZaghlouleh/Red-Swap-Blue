// ignore_for_file: curly_braces_in_flow_control_structures, unused_element

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphite/graphite.dart';

import 'package:red_swap_blue/Classes/algorithms.dart';
import 'package:red_swap_blue/Classes/position.dart';
import 'package:red_swap_blue/Logic/logic.dart';
import 'package:red_swap_blue/components/constants.dart';
import 'package:red_swap_blue/components/functions.dart';
import 'package:red_swap_blue/Structure/structure.dart';

class AllAlgorithms extends StatefulWidget {
  const AllAlgorithms(
      {required this.level, required this.playerType, super.key});

  final int level;
  final PlayerType playerType;

  @override
  State<AllAlgorithms> createState() => _AllAlgorithmsState();
}

class _AllAlgorithmsState extends State<AllAlgorithms> {
  late Structure board;
  late Logic logic;
  int time = 0;
  int visited = 0;
  int cost = 0;
  int path = 0;
  int solveDepth = 0;
  int fullDepth = 0;
  Algorithms algorithms = Algorithms();

  final PageController _pageController = PageController();
  @override
  void initState() {
    _init();
    super.initState();
  }

  increaseMoves(
      int time, int visited, int cost, int solveDepth, int fullDepth) {
    setState(() {
      this.time = time;
      this.visited = visited;
      this.cost = cost;
      this.solveDepth = solveDepth;
      this.fullDepth = fullDepth;
    });
  }

  _init() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    board = Structure(
        widget.level,
        Position(getRealDimension(widget.level) ~/ 2,
            getRealDimension(widget.level) ~/ 2),
        PlayerType.User);

    logic = Logic(board);
    logic.initBoard();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page == 1) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        } else
          Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              widget.playerType == PlayerType.DFS
                  ? 'DFS'
                  : widget.playerType == PlayerType.BFS
                      ? 'BFS'
                      : widget.playerType == PlayerType.UCS
                          ? 'UCS'
                          : 'A*',
              style: GoogleFonts.righteous(fontSize: 30, color: Colors.black54),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ElevatedButton(
          child: const Text('Start'),
          onPressed: () async {
            switch (widget.playerType) {
              case PlayerType.DFS:
                logic.dfs(() {
                  setState(() {});
                }, increaseMoves, () {}, algorithms);
                break;
              case PlayerType.BFS:
                logic.bfs(() {
                  setState(() {});
                }, increaseMoves, algorithms);
                break;
              case PlayerType.UCS:
                logic.ucs(() {
                  setState(() {});
                }, increaseMoves, algorithms);
                break;
              case PlayerType.ASTAR:
                logic.aStar(() {
                  setState(() {});
                }, increaseMoves, algorithms);
                break;
              default:
            }
          },
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Time: $time milliseconds',
                                style: GoogleFonts.righteous(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Visited: $visited ',
                                style: GoogleFonts.righteous(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Solve Depth: $solveDepth ',
                                style: GoogleFonts.righteous(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Full Depth: $fullDepth ',
                                style: GoogleFonts.righteous(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Cost: $cost ',
                                style: GoogleFonts.righteous(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Transform.rotate(
                                angle: -pi / 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: board.uiBoard.map((e1) {
                                    return Row(
                                      key: Key(e1.toString()),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: e1
                                          .map((e2) => _board(e1, e2, board))
                                          .toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Algorithms',
                      style: GoogleFonts.righteous(
                          fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  //_AlgorithmsUI(),
                  //Stop Algorithms
                  Expanded(
                    child: DirectGraph(
                        tipLength: 15,
                        tipAngle: pi / 4,
                        maxScale: 10,
                        minScale: 0.00000001,
                        list: algorithms.viewNodes,
                        cellWidth: widget.level == 2
                            ? 150
                            : widget.level == 3
                                ? 250
                                : 350,
                        cellPadding: 10,
                        builder: (context, node) {
                          List data = [];
                          data = jsonDecode(node.id
                              .substring(0, node.id.lastIndexOf(']') + 1));
                          List<List> algorithms =
                              data.map((e) => e as List).toList();

                          return Card(
                            elevation: 5,
                            child: Center(
                              child: Transform.rotate(
                                angle: -pi / 4,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: algorithms
                                        .toList()
                                        .map((e1) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: e1
                                                  .map((e2) =>
                                                      _boardForAlgorithms(
                                                          e1, e2))
                                                  .toList(),
                                            ))
                                        .toList()),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget _board(var e1, var e2, Structure board) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: e2.toString().contains(CellType.E.name)
          ? 0
          : e2.toString().contains(CellType.S.name)
              ? 15
              : 10,
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.transparent, width: widget.level == 4 ? 6 : 7),
            color: e2.toString().contains(CellType.R.name)
                ? Colors.red
                : (e2.toString().contains(CellType.B.name)
                    ? Colors.blue
                    : e2.toString().contains(CellType.E.name)
                        ? Colors.transparent
                        : Colors.grey.shade700),
          ),
          width: widget.level == 2
              ? MediaQuery.of(context).size.width * 0.2
              : (widget.level == 3
                  ? MediaQuery.of(context).size.width * 0.12
                  : MediaQuery.of(context).size.width * 0.08),
          height: widget.level == 2
              ? MediaQuery.of(context).size.width * 0.2
              : (widget.level == 3
                  ? MediaQuery.of(context).size.width * 0.12
                  : MediaQuery.of(context).size.width * 0.08),
        ),
      ),
    );
  }

  Widget _boardForAlgorithms(
    var e1,
    var e2,
  ) {
    return Card(
      color: e2.toString().contains(CellType.E.name)
          ? Colors.transparent
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: e2.toString().contains(CellType.E.name)
          ? 0
          : e2.toString().contains(CellType.S.name)
              ? 15
              : 10,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            decoration: BoxDecoration(
              color: e2.toString().contains(CellType.R.name)
                  ? Colors.red
                  : (e2.toString().contains(CellType.B.name)
                      ? Colors.blue
                      : e2.toString().contains(CellType.E.name)
                          ? Colors.transparent
                          : Colors.grey.shade700),
            ),
            width: 25,
            height: 25),
      ),
    );
  }

  _algorithmsUI() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: algorithms.nodes.entries
              .map(
                (e) => Column(
                  children: [
                    Text(
                      'Parent',
                      style: GoogleFonts.righteous(
                          fontSize: 20, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Transform.rotate(
                        angle: -pi / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: e.key.uiBoard.map((e1) {
                            return Row(
                              key: Key(e1.toString()),
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: e1
                                  .map((e2) => _board(e1, e2, e.key))
                                  .toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Text(
                      'Children',
                      style: GoogleFonts.righteous(
                          fontSize: 20, color: Colors.black),
                    ),
                    Column(
                      children: e.value
                          .map(
                            (parent) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Transform.rotate(
                                angle: -pi / 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: parent.uiBoard.map((e1) {
                                    return Row(
                                      key: Key(e1.toString()),
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: e1
                                          .map((e2) => Column(
                                                children: [
                                                  _board(e1, e2, parent),
                                                ],
                                              ))
                                          .toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Divider(
                      color: Colors.black,
                      endIndent: 50,
                      indent: 50,
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
