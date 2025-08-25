import 'package:flutter/material.dart';

class GameWon extends StatelessWidget {
  final bool isGamecomplete;
  final reset;

  GameWon({required this.isGamecomplete, required this.reset});

  @override
  Widget build(BuildContext context) {
    return !isGamecomplete
        ? Container()
        : Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.25),
                child: Text("Game Won!!!", style: TextStyle(fontSize: 26)),
              ),

              Container(
                alignment: Alignment(0, 0.2),
                child: MaterialButton(
                  onPressed: reset,
                  color: Colors.deepPurple,
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Text(
                    "Play Again",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
  }
}
