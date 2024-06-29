import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_view_model.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameViewModel = Provider.of<GameViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseWidth = 375.0;
    double baseHeight = 812.0;
    double scaleFactor =
        (screenWidth / baseWidth + screenHeight / baseHeight) / 2;
    double iconSize = scaleFactor * 1.5;
    double iconSpace = scaleFactor * 25;
    double fontSize = scaleFactor * 30;
    double fontSizeXO = scaleFactor * 60;
    Color bgColor = const Color(0xFFF3F3F3);
    Color buttonColor = const Color(0xFF412c5a);
    Color iconColor = const Color(0xFFCBA135);
    Color textColor = const Color(0xFF412c5a);
    Color gridColor = const Color(0xFF412c5a);

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
                    if (gameViewModel.game.opponent == 'Player')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Turn: ${gameViewModel.game.currentPlayer}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              color: textColor),
                        ),
                      ),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gameViewModel.game.gridSize,
                      ),
                      itemCount: gameViewModel.game.moves.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            gameViewModel.makeMove(index, context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(4.0),
                            color: gridColor,
                            child: Center(
                              child: Text(
                                gameViewModel.game.moves[index],
                                style: TextStyle(
                                  fontSize: fontSizeXO,
                                  color: gameViewModel.game.moves[index] == 'X'
                                      ? Colors.blue
                                      : gameViewModel.game.moves[index] == 'O'
                                          ? Colors.red
                                          : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
