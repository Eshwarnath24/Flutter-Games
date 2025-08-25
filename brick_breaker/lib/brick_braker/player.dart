import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final double playerX;
  final double playerWidth;

  Player({required this.playerX, required this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * playerX + playerWidth) / (2 - playerWidth), 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 10,
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          child: Container(color: Colors.deepPurple),
        ),
      ),
    );
  }
}
