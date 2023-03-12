// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:red_swap_blue/Structure/structure.dart';
import 'package:red_swap_blue/components/constants.dart';

Widget boardForNextStates(var e1, var e2, Structure board,
    {required BuildContext context, required int level}) {
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
          color: e2.toString().contains(CellType.R.name)
              ? Colors.red
              : (e2.toString().contains(CellType.B.name)
                  ? Colors.blue
                  : e2.toString().contains(CellType.E.name)
                      ? Colors.transparent
                      : Colors.grey.shade700),
        ),
        width: level == 2
            ? MediaQuery.of(context).size.width * 0.2
            : (level == 3
                ? MediaQuery.of(context).size.width * 0.12
                : MediaQuery.of(context).size.width * 0.08),
        height: level == 2
            ? MediaQuery.of(context).size.width * 0.2
            : (level == 3
                ? MediaQuery.of(context).size.width * 0.12
                : MediaQuery.of(context).size.width * 0.08),
      ),
    ),
  );
}
