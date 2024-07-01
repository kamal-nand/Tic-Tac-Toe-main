import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_game/game_screen/game_view.dart';
import 'package:tic_tac_toe_game/game_screen/game_view_model.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameViewModel = Provider.of<GameViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseWidth = 375.0;
    double baseHeight = 812.0;
    double scaleFactor = (screenWidth / baseWidth + screenHeight / baseHeight) / 2;
    double iconSize = scaleFactor * 1;
    double iconSpace = scaleFactor * 25;
    double fontSize = scaleFactor * 30;
    double fontSizeHead = scaleFactor * 35;
    double space = screenWidth * 0.08;
    double buttonWidth = screenWidth * 0.5;
    double buttonHeight = screenWidth * 0.15; //0xFF2845B7
    Color bgColor = const Color(0xFFE6F7FF);
    Color buttonColor = const Color(0xFF2845B7);
    Color iconColor = const Color(0xffc3bfbf);
    Color fontColor = const Color(0xFF000000);
    Color textColor = const Color(0xFF412c5a);

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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: space * 3.5),
                    Text(
                      'Select Opponent',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeHead,
                          color: textColor),
                    ),
                    SizedBox(height: space),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            gameViewModel.setOpponent('Player');
                          },
                          child: Text(
                            'Player',
                            style: TextStyle(
                              color: gameViewModel.game.opponent == 'Player'
                                  ? fontColor
                                  : Colors.grey,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                        SizedBox(height: space),
                        TextButton(
                          onPressed: () {
                            gameViewModel.setOpponent('Computer');
                          },
                          child: Text(
                            'Computer',
                            style: TextStyle(
                              color: gameViewModel.game.opponent == 'Computer'
                                  ? fontColor
                                  : Colors.grey,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: space),
                    Text(
                      'Select Grid Size',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeHead,
                          color: textColor),
                    ),
                    SizedBox(height: space),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            gameViewModel.setGridSize(3);
                          },
                          child: Text(
                            '3X3',
                            style: TextStyle(
                              color: gameViewModel.game.gridSize == 3
                                  ? fontColor
                                  : Colors.grey,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            gameViewModel.setGridSize(4);
                          },
                          child: Text(
                            '4X4',
                            style: TextStyle(
                              color: gameViewModel.game.gridSize == 4
                                  ? fontColor
                                  : Colors.grey,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            gameViewModel.setGridSize(5);
                          },
                          child: Text(
                            '5X5',
                            style: TextStyle(
                              color: gameViewModel.game.gridSize == 5
                                  ? fontColor
                                  : Colors.grey,
                              fontSize: fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: space),
                    SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: iconColor,
                          backgroundColor: buttonColor,
                          textStyle: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        child: Text('Continue'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameScreen()),
                          );
                        },
                      ),
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
