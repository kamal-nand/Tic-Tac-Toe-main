import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_game/game_screen/game_replay.dart';
import 'package:tic_tac_toe_game/game_screen/game_view_model.dart';

class ReplayScreen extends StatefulWidget {
  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GameViewModel>(context, listen: false)
          .loadGameHistoryIfNeeded();
      setState(() {}); // Refresh the screen
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameViewModel = Provider.of<GameViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final margin = EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05,
      vertical: screenHeight * 0.15,
    );
    double baseWidth = 375.0;
    double baseHeight = 812.0;
    double scaleFactor =
        (screenWidth / baseWidth + screenHeight / baseHeight) / 2;
    double iconSize = scaleFactor * 1.5;
    double iconSpace = scaleFactor * 25;
    double fontSize = scaleFactor * 30;
    double fontSize2 = scaleFactor * 8;
    Color bgColor = const Color(0xFFF3F3F3);
    Color buttonColor = const Color(0xFF412c5a);
    Color iconColor = const Color(0xFFCBA135);
    Color textColor = const Color(0xFF412c5a);

    gameViewModel.loadGameHistory();
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
              Positioned(
                right: iconSpace,
                top: iconSpace,
                child: Transform.scale(
                  scale: iconSize,
                  child: CircleAvatar(
                    backgroundColor: buttonColor,
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      color: iconColor,
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                right: iconSpace * 5,
                top: iconSpace,
                child: Transform.scale(
                  scale: iconSize,
                  child: CircleAvatar(
                    backgroundColor: buttonColor,
                    child: Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: iconColor,
                          onPressed: () {
                            gameViewModel.clearAllGameHistory();
                          },
                        ),
                        Center(
                            child: Text(
                          'ALL',
                          style: TextStyle(
                              fontSize: fontSize2,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: margin,
                child: ListView.builder(
                  itemCount: gameViewModel.gameHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Game ${index + 1}',
                        style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      onTap: () {
                        gameViewModel.replayGame(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameReplayScreen()),
                        );
                      },
                      trailing: Transform.scale(
                        scale: iconSize,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            gameViewModel.deleteGameHistory(index);
                            gameViewModel.loadGameHistory();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
