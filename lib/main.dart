import 'package:flutter/material.dart';
import 'package:red_swap_blue/UI/main_menu.dart';

void main() => runApp(const RedSwapBlueGame());

class RedSwapBlueGame extends StatelessWidget {
  const RedSwapBlueGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}
