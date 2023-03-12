import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

PreferredSizeWidget myAppbar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    toolbarHeight: 120,
    title: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white.withOpacity(0.8),
      elevation: 6,
      child: Shimmer(
          period: const Duration(milliseconds: 5000),
          gradient: const LinearGradient(
              colors: [Colors.red, Colors.grey, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Red Swap Blue',
                  style:
                      GoogleFonts.fasterOne(fontSize: 30, color: Colors.white),
                ),
                Text(
                  '-----------------------------',
                  style: GoogleFonts.flowRounded(fontSize: 30),
                ),
              ],
            ),
          )),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

Widget backgroundCubes(double angle, int index) {
  return Expanded(
    child: Transform.scale(
      scale: 1,
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          height: 100,
          child: LinearProgressIndicator(
            // value: 1,
            backgroundColor: index % 2 == 0
                ? Colors.red.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
            color: index % 2 == 0
                ? Colors.red.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
          ),
        ),
      ),
    ),
  );
}

Widget backgroundCubesForBoard(double angle, int index) {
  return Expanded(
    child: Transform.scale(
      scaleX: 1,
      scaleY: 1,
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          height: 100,
          child: LinearProgressIndicator(
            backgroundColor: index % 2 == 0
                ? Colors.red.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
            color: index % 2 == 0
                ? Colors.red.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
          ),
        ),
      ),
    ),
  );
}
