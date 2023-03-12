import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_swap_blue/UI/all_algorithms_ui.dart';
import 'package:red_swap_blue/UI/game.dart';
import 'package:red_swap_blue/UI/widget.dart';
import 'package:red_swap_blue/components/constants.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
  }

  int level = 0;
  PlayerType playerType = PlayerType.User;
  int page = 0;

  void setLevel(int newLevel) {
    setState(() {
      level = newLevel;
    });
    _pageController.addListener(() {
      setState(() {
        page = _pageController.page!.toInt();
      });
    });
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  back() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  final PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (page == 1) back();
        return false;
      },
      child: Scaffold(
        extendBody: true,
        appBar: myAppbar(context),
        body: Stack(
          children: [
            Column(
              children: List.generate(
                10,
                (index) => backgroundCubes(pi / 4, index),
              ),
            ),
            Column(
              children: List.generate(
                10,
                (index) => backgroundCubes(-pi / 4, index),
              ),
            ),
            SafeArea(
              child: Center(
                  child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              'Level',
                              style: GoogleFonts.righteous(
                                  fontSize: 35, color: Colors.black54),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                getElevatedButtonForLevels(
                                    context, 2, 'Level 1 (2x2)'),
                                getElevatedButtonForLevels(
                                    context, 3, 'Level 2 (3x3)'),
                                getElevatedButtonForLevels(
                                    context, 4, 'Level 3 (4x4)'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Player',
                            style: GoogleFonts.righteous(
                                fontSize: 35, color: Colors.black54),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                Center(
                                  child: Column(
                                    children: [
                                      getElevatedButtonForPlayers(
                                          context,
                                          level,
                                          PlayerType.User,
                                          'User',
                                          false),
                                      getElevatedButtonForPlayers(context,
                                          level, PlayerType.DFS, 'DFS', false),
                                      getElevatedButtonForPlayers(context,
                                          level, PlayerType.BFS, 'BFS', false),
                                      getElevatedButtonForPlayers(context,
                                          level, PlayerType.UCS, 'UCS', false),
                                      getElevatedButtonForPlayers(context,
                                          level, PlayerType.ASTAR, 'A*', false),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Padding getElevatedButtonForLevels(
    BuildContext context,
    int level,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: InkWell(
          onTap: () {
            setLevel(level);
          },
          child: Container(
            alignment: Alignment.center,
            width: 200,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                _customBoxShadow(const Offset(5, 5), true),
                _customBoxShadow(const Offset(-5, -5), false),
              ],
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.righteous(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow _customBoxShadow(Offset offset, bool blurRadius) {
    return BoxShadow(
      blurRadius: 5,
      color: blurRadius ? Colors.red : Colors.blue,
      offset: offset,
    );
  }

  Padding getElevatedButtonForPlayers(BuildContext context, int level,
      PlayerType playerType, String text, bool disabled) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: InkWell(
          onTap: disabled
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => playerType == PlayerType.User
                            ? Game(level: level, playerType: playerType)
                            : AllAlgorithms(
                                level: level, playerType: playerType)),
                  );
                  _pageController.jumpToPage(0);
                },
          child: Container(
            alignment: Alignment.center,
            width: 200,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                _customBoxShadow(const Offset(5, 5), true),
                _customBoxShadow(const Offset(-5, -5), false),
              ],
              shape: BoxShape.rectangle,
              color: disabled ? Colors.grey : Colors.white,
            ),
            child: Text(
              text,
              style: GoogleFonts.righteous(
                  fontSize: 25,
                  color: disabled ? Colors.black12 : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
