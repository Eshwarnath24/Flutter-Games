import 'package:flutter/material.dart';

class GameStart extends StatelessWidget {
  final bool isGameStarted;

  GameStart({required this.isGameStarted});

  @override
  Widget build(BuildContext context) {
    return isGameStarted
        ? Container()
        : Container(
            alignment: Alignment(0, -0.25),
            child: Text(
              "Tap to play", 
              style: TextStyle(
                fontSize: 20
              ),
            ),
          );
  }
}
