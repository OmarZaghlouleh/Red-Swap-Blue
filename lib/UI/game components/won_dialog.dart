import 'package:flutter/material.dart';
import 'package:red_swap_blue/UI/game.dart';
import 'package:red_swap_blue/components/constants.dart';

showWonDialog(
    {required BuildContext context,
    required int level,
    required PlayerType playerType}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 150,
        height: 120,
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Solved!',
                  style: TextStyle(color: Colors.green, fontSize: 40),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const MainMenu()));
                      },
                      child: const Text(
                        'Main menu',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Game(
                              level: level,
                              playerType: playerType,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Replay',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
