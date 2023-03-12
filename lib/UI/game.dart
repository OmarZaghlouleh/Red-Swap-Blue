// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphite/graphite.dart';
import 'package:just_audio/just_audio.dart';

import 'package:red_swap_blue/Classes/algorithms.dart';
import 'package:red_swap_blue/Classes/position.dart';
import 'package:red_swap_blue/Logic/logic.dart';
import 'package:red_swap_blue/UI/game%20components/boards/graph_board.dart';
import 'package:red_swap_blue/UI/game%20components/boards/nextState_board.dart';
import 'package:red_swap_blue/components/constants.dart';
import 'package:red_swap_blue/components/functions.dart';
import 'package:red_swap_blue/Structure/structure.dart';

import 'game components/won_dialog.dart';

class Game extends StatefulWidget {
  const Game({required this.level, required this.playerType, super.key});

  final int level;
  final PlayerType playerType;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Structure board;
  late Logic logic;
  int movesNumber = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Algorithms algorithms = Algorithms();
  List<Structure> nextStates = [];
  bool graphBuilt = false;

  void setGraphBuilt(bool value) {
    setState(() {
      graphBuilt = value;
    });
  }

  final PageController _pageController = PageController();
  @override
  void initState() {
    _init();
    _initGraph();
    super.initState();
  }

  _increaseMoves() {
    movesNumber += 1;
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
    logic.userPlay();
    await _audioPlayer.setAsset('assets/audio/effect.mp3');
  }

  _initGraph() async {
    await algorithms
        .addEdge(board.cloneObject(), board.cloneObject().nextStates)
        .then((value) => setGraphBuilt(true));
    algorithms.printGraph();
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
                                'Moves: $movesNumber',
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
                                          .map((e2) => _board(
                                                e1,
                                                e2,
                                                board,
                                              ))
                                          .toList(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'New Possible States:',
                          style: GoogleFonts.righteous(
                              fontSize: 15, color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: board.nextStates
                                .map(
                                  (board) => Transform.rotate(
                                    angle: -pi / 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: board.uiBoard.map((e1) {
                                        return Row(
                                          key: Key(e1.toString()),
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: e1
                                              .map((e2) => boardForNextStates(
                                                  e1, e2, board,
                                                  context: context,
                                                  level: widget.level))
                                              .toList(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                            backgroundColor: Colors.white70,
                            child: Text(
                              'Graph',
                              style: GoogleFonts.righteous(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            onPressed: () {
                              //Stop Graph
                              _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight
                              ]);
                            }),
                      ))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Graph',
                      style: GoogleFonts.righteous(
                          fontSize: 15, color: Colors.black54),
                    ),
                  ),
                  //_graphUI(),
                  //Stop Graph
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
                          List<List> graph =
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
                                    children: graph
                                        .toList()
                                        .map((e1) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: e1
                                                  .map((e2) =>
                                                      boardForGraph(e1, e2))
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
        child: InkWell(
          onTap: e2.toString().contains(CellType.E.name)
              ? null
              : () {
                  _tapFunction(e1, e2);
                },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: searchForMove(
                          Position(
                            board.uiBoard.indexOf(e1),
                            board.uiBoard[board.uiBoard.indexOf(e1)]
                                .indexOf(e2),
                          ),
                          board.moves)
                      ? Colors.greenAccent.shade400
                      : Colors.transparent,
                  width: widget.level == 4 ? 6 : 7),
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
      ),
    );
  }

  _tapFunction(var e1, var e2) async {
    if (searchForMove(
        Position(
          board.uiBoard.indexOf(e1),
          board.uiBoard[board.uiBoard.indexOf(e1)].indexOf(e2),
        ),
        board.moves)) {
      _audioPlayer.play();
      setState(() {
        board.move(
          Position(
            board.uiBoard.indexOf(e1),
            board.uiBoard[board.uiBoard.indexOf(e1)].indexOf(e2),
          ),
        );
        _increaseMoves();
      });
      if (board.isFinal())
        showWonDialog(
          context: context,
          level: widget.level,
          playerType: widget.playerType,
        );
      //board.moves = board.checkMoves();
      board.getNextStates(board.board, board.swapPosition);
      setGraphBuilt(false);

      await algorithms
          .addEdge(board.cloneObject(), board.cloneObject().nextStates)
          .then((value) => setGraphBuilt(true));

      algorithms.printGraph();

      await _audioPlayer.setAsset('assets/audio/effect.mp3');
    }
  }
}
