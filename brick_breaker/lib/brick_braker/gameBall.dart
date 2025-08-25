import 'package:flutter/material.dart';

class GameBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  
  GameBall({required this.ballX, required this.ballY});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
