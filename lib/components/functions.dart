// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';

import 'package:red_swap_blue/Classes/position.dart';

int getRealDimension(value) {
  return ((value * 2) - 1);
}

bool searchForMove(Position position, List<Position> positions) {
  for (var element in positions) {
    if (element.row == position.row && element.column == position.column) {
      return true;
    }
  }
  return false;
}

double getEucledianDistance(int x1, int x2, int y1, int y2) {
  return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
}

double getMahattanDistance(int x1, int x2, int y1, int y2) {
  return ((x2 - x1).abs() + (y2 - y1).abs()).toDouble();
}
