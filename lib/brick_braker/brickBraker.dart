import 'dart:async';
import 'dart:math';
import 'package:brick_breaker/brick_braker/brick.dart';
import 'package:brick_breaker/brick_braker/gameStartScreen.dart';
import 'package:brick_breaker/brick_braker/gameBall.dart';
import 'package:brick_breaker/brick_braker/gameOverScreen.dart';
import 'package:brick_breaker/brick_braker/gameWonScreen.dart';
import 'package:brick_breaker/brick_braker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class brickBraker extends StatefulWidget {
  @override
  State<brickBraker> createState() => _brickBrakerState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _brickBrakerState extends State<brickBraker> {
  // ball settings
  double ballX = 0;
  double ballY = 0;
  double ballXIncrement = 0.02;
  double ballYIncrement = 0.01;
  var ballXDirection = direction.LEFT;
  var ballYDirection = direction.DOWN;

  // player settings
  double playerX = -0.2;
  double playerWidth = 0.4;

  // brick settings
  // double brickX = -0.15;
  // double brickY = -0.9;
  // double brickHeight = 0.07;
  // double brickWidth = 0.3;
  // bool isBrickBroke = false;

  static double firstXBrick = -1 + wallGap;
  static double firstYBrick = -0.9;
  static double brickGap = 0.02;
  static double brickWidth = 0.3;
  static double brickHeight = 0.07;
  static int noOfBricks = 4;
  static double wallGap =
      0.5 * (2 - (noOfBricks * brickWidth) - ((noOfBricks - 1) * brickGap));

  List myBricks = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < noOfBricks; i++) {
      myBricks.add([
        firstXBrick + i * (brickWidth + brickGap),
        firstYBrick,
        false,
      ]);
    }
  }

  // cover pages info
  bool isGameStarted = false;
  bool isGameOver = false;
  bool didPlayerWon = false;

  // ball movement
  void _startGame() {
    isGameStarted = true;
    Timer.periodic(Duration(microseconds: 500), (checkballTimer) {
      updateDirection();
    });
    Timer.periodic(Duration(milliseconds: 10), (gameTimer) {
      moveBall();

      if (playerOut()) {
        gameTimer.cancel();
        isGameOver = true;
      }

      brickDead();

      if (isGameCompleted()) {
        gameTimer.cancel();
      }
    });
  }

  void restGame() {
    setState(() {
      isGameStarted = false;
      isGameOver = false;
      didPlayerWon = false;
      ballX = 0;
      ballY = 0;
      ballXDirection = direction.LEFT;
      ballYDirection = direction.DOWN;
      playerX = -0.2;
      for (int i = 0; i < noOfBricks; i++) {
        myBricks[i][2] = false;
      }
    });
  }

  bool isGameCompleted() {
    bool allBrickStatus = true;
    for (int i = 0; i < noOfBricks; i++) {
      allBrickStatus = allBrickStatus && myBricks[i][2];
    }

    if (allBrickStatus == true) {
      setState(() {
        didPlayerWon = true;
      });
    }
    return allBrickStatus;
  }

  bool playerOut() {
    if (ballY > 1) return true;
    return false;
  }

  void brickDead() {
    for (int i = 0; i < noOfBricks; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + brickWidth &&
          ballY <= myBricks[i][1] + brickHeight &&
          !myBricks[i][2]) {
        setState(() {
          myBricks[i][2] = true;

          double leftDist = (myBricks[i][0] - ballX).abs();
          double rightDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topDist = (myBricks[i][1] - ballY).abs();
          double bottomDist = (myBricks[i][1] + brickHeight - ballY).abs();

          String minDirection = findMinDirection(
            leftDist,
            rightDist,
            topDist,
            bottomDist,
          );

          print(minDirection);

          switch (minDirection) {
            case 'left':
              ballXDirection = direction.LEFT;
              break;
            case 'right':
              ballXDirection = direction.RIGHT;
              break;
            case 'top':
              ballYDirection = direction.UP;
              break;
            case 'down':
              ballYDirection = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMinDirection(double left, double right, double top, double down) {
    double minDist = min(min(left, right), min(top, down));

    if ((minDist - left).abs() < 0.01) {
      return 'left';
    }
    if ((minDist - down).abs() < 0.01) {
      return 'down';
    }
    if ((minDist - right).abs() < 0.01) {
      return 'right';
    }
    if ((minDist - top).abs() < 0.01) {
      return 'top';
    } else {
      return '';
    }
  }

  void updateDirection() {
    if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
      ballYDirection = direction.UP;
    } else if (ballY < -1) {
      ballYDirection = direction.DOWN;
    }
    if (ballX <= -1) {
      ballXDirection = direction.RIGHT;
    } else if (ballX >= 1) {
      ballXDirection = direction.LEFT;
    }
  }

  void moveBall() {
    setState(() {
      // to move top - bottom
      if (ballYDirection == direction.UP) {
        ballY -= ballYIncrement;
      } else if (ballYDirection == direction.DOWN) {
        ballY += ballYIncrement;
      }

      // to move left - right
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXIncrement;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXIncrement;
      }
    });
  }

  void _moveLeft() {
    setState(() {
      if (playerX - 0.2 >= -1) playerX -= 0.2;
    });
  }

  void _moveRight() {
    setState(() {
      if (playerX + 0.2 + playerWidth <= 1) playerX += 0.2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          _moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          _moveRight();
        }
      },

      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            // convert drag distance to player movement
            playerX += details.delta.dx / MediaQuery.of(context).size.width * 2;

            // keep paddle inside screen bounds
            if (playerX < -1) playerX = -1;
            if (playerX + playerWidth > 1) playerX = 1 - playerWidth;
          });
        },
        onTap: isGameStarted ? null : _startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[200],
          body: Center(
            child: Stack(
              children: [
                GameStart(isGameStarted: isGameStarted),

                GameOver(isGameOver: isGameOver, reset: restGame),

                GameWon(isGamecomplete: didPlayerWon, reset: restGame),

                GameBall(ballX: ballX, ballY: ballY),

                Player(playerX: playerX, playerWidth: playerWidth),

                for (int i = 0; i < noOfBricks; i++)
                  Brick(
                    myBricks[i][0],
                    myBricks[i][1],
                    brickHeight,
                    brickWidth,
                    isBrickBroke: myBricks[i][2],
                  ),

                // Container(
                //   alignment: Alignment(playerX, 0.9),
                //   child: Container(height: 15, width: 4, color: Colors.red),
                // ),
                // Container(
                //   alignment: Alignment(playerX + playerWidth, 0.9),
                //   child: Container(height: 15, width: 4, color: Colors.green),
                // ),
                // isGameStarted
                //     ? !isGameOver && !didPlayerWon ? Row(
                //         children: [
                //           Expanded(
                //             child: GestureDetector(
                //               onTap: _moveLeft,
                //               child: Container(color: Colors.transparent),
                //             ),
                //           ),
                //           Expanded(
                //             child: GestureDetector(
                //               onTap: _moveRight,
                //               child: Container(color: Colors.transparent),
                //             ),
                //           ),
                //         ],
                //       )
                //     : Container():Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Offset? pos;
  // Timer? timer;

  // void _trackPlayerPostion(details) {
  //   Timer.periodic(Duration(milliseconds: 100), (timer) {
  //     playerX =
  //         (details.globalPosition.dx / MediaQuery.of(context).size.width) * 2 -
  //         1;
  //     final y = details.globalPosition.dy;
  //     print("Touched at: x = $playerX, y = $y");
  //   });
  // }