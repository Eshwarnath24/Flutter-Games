import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final bool isGameOver;
  final reset;

  GameOver({required this.isGameOver, required this.reset});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: Alignment(0, -0.2),
                child: Text("Game Over!", style: TextStyle(fontSize: 20)),
              ),

              Container(
                alignment: Alignment(0, 0.2),
                child: MaterialButton(
                  onPressed: reset,
                  color: Colors.deepPurple,
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  child: Text("Play Again", style: TextStyle(fontSize: 16, color: Colors.white), ),
                ),
              ),
            ],
          )
        : Container();
  }
}
