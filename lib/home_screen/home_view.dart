import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/replay_screen/replay_view.dart';
import 'package:tic_tac_toe_game/settings_screen/settings_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.5, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseWidth = 375.0;
    double baseHeight = 812.0;
    double scaleFactor =
        (screenWidth / baseWidth + screenHeight / baseHeight) / 2;
    double fontSizeHead = scaleFactor * 25;
    double fontSize = scaleFactor * 30;
    double space = screenWidth * 0.08;
    double buttonWidth = screenWidth * 0.5;
    double buttonHeight = screenWidth * 0.15;
    Color buttonColor = const Color(0xFFE6F7FF);
    Color textColor = const Color(0xFF0022FE);
    Color bgColor = const Color(0xFFE6F7FF);
    Color ticColor = const Color(0xFF333333);
    double imageSize = screenWidth * 0.6;

    return Scaffold(
      body: Container(
        color: bgColor,
        child: Stack(
          children: [
            Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/image/tictactoe.png',
                  width: imageSize,
                  height: imageSize,
                )),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: space * 2),
                  ScaleTransition(
                    scale: _animation,
                    child: Text(
                      "TIC~TAC~TOE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeHead,
                        color: ticColor,
                      ),
                    ),
                  ),
                  SizedBox(height: space * 2),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: textColor,
                        backgroundColor: buttonColor,
                        textStyle: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                      child: Text('Play'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: space),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: textColor,
                        backgroundColor: buttonColor,
                        textStyle: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                      child: Text('Replay'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReplayScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: space),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: textColor,
                        backgroundColor: buttonColor,
                        textStyle: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                      child: Text('EXIT'),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
