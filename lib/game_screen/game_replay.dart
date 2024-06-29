import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_view_model.dart';

class GameReplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameViewModel = Provider.of<GameViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final margin = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.01,
      vertical: screenHeight * 0.01,
    );
    double baseWidth = 375.0;
    double baseHeight = 812.0;
    double scaleFactor =
        (screenWidth / baseWidth + screenHeight / baseHeight) / 2;
    double iconSize = scaleFactor * 1.5;
    double iconSpace = scaleFactor * 25;
    double borderSize = scaleFactor * 5;
    double fontSizeXO = scaleFactor * 30;
    Color bgColor = const Color(0xFFF3F3F3);
    Color buttonColor = const Color(0xFF412c5a);
    Color iconColor = const Color(0xFFCBA135);

    int gridSize = 0;
    if (gameViewModel.replayMoves.isNotEmpty) {
      gridSize = gameViewModel.replayMoves.length == 9
          ? 3
          : gameViewModel.replayMoves.length == 16
              ? 4
              : gameViewModel.replayMoves.length == 25
                  ? 5
                  : 0;
    }

    List<List<String>> board = List.generate(
      gridSize,
      (_) => List.filled(gridSize, ''),
    );

    int index = 0;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (index < gameViewModel.replayMoves.length) {
          board[i][j] = gameViewModel.replayMoves[index];
          index++;
        }
      }
    }

    return Scaffold(
      body: Container(
        color: bgColor,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: iconSpace,
                top: iconSpace,
                child: Transform.scale(
                  scale: iconSize,
                  child: CircleAvatar(
                    backgroundColor: buttonColor,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_sharp),
                      color: iconColor,
                      onPressed: () {
                        gameViewModel.resetGame();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < gridSize; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int j = 0; j < gridSize; j++)
                            Container(
                              margin: margin,
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.15,
                              decoration: BoxDecoration(
                                color: buttonColor,
                                border: Border.all(
                                  color: buttonColor,
                                  width: borderSize,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  board[i][j],
                                  style: TextStyle(
                                    fontSize: fontSizeXO,
                                    color: board[i][j] == 'X'
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
