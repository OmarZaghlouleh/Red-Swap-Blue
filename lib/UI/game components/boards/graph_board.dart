import 'package:flutter/material.dart';
import 'package:red_swap_blue/components/constants.dart';

Widget boardForGraph(
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
            // border: Border.all(width: widget.level == 4 ? 6 : 7),
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
