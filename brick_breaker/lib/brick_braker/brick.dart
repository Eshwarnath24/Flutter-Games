import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  double brickX;
  double brickY;
  double brickHeight;
  double brickWidth;
  final bool isBrickBroke;

  Brick(
    this.brickX,
    this.brickY,
    this.brickHeight,
    this.brickWidth, {
    required this.isBrickBroke,
  });

  @override
  Widget build(BuildContext context) {
    return isBrickBroke ? Container() : Container(
      alignment: Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
      child: Container(
        height: MediaQuery.of(context).size.height * brickHeight / 2,
        width: MediaQuery.of(context).size.width * brickWidth / 2,
        
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
