import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'game_model.dart';

class GameViewModel with ChangeNotifier {
  late Game _game;
  Database? _database;
  List<Map<String, dynamic>> gameHistory = [];
  List<String> replayMoves = [];
  bool isAIMoving = false;

  GameViewModel() {
    _game = Game(
      gridSize: 3,
      moves: List.generate(9, (_) => ''),
      currentPlayer: 'X',
      opponent: 'Player',
    );
    _initDb();
  }

  Game get game => _game;

  void _initDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'game_history.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE game_history(id INTEGER PRIMARY KEY, moves TEXT)",
        );
      },
      version: 1,
    );
  }

  void setOpponent(String value) {
    _game.opponent = value;
    notifyListeners();
  }

  void setGridSize(int size) {
    _game.gridSize = size;
    _game.moves = List.generate(size * size, (_) => '');
    notifyListeners();
  }

  void makeMove(int index, BuildContext? context) {
    if (!isAIMoving && _game.moves[index].isEmpty) {
      _game.moves[index] = _game.currentPlayer;
      if (checkWinner(_game.currentPlayer)) {
        _showWinnerDialog(context!, _game.currentPlayer);
      } else if (!_game.moves.contains('')) {
        _showWinnerDialog(context!, 'Draw');
      } else {
        _game.currentPlayer = _game.currentPlayer == 'X' ? 'O' : 'X';
        if (_game.opponent == 'AI' && _game.currentPlayer == 'O') {
          isAIMoving = true;
          _makeAIMove(context!);
        }
      }
      notifyListeners();
    }
  }

  bool checkWinner(String player) {
    int gridSize = _game.gridSize;
    List<String> moves = _game.moves;

    // Check rows
    for (int i = 0; i < gridSize; i++) {
      if (moves
          .skip(i * gridSize)
          .take(gridSize)
          .every((element) => element == player)) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < gridSize; i++) {
      if (List.generate(gridSize, (index) => moves[index * gridSize + i])
          .every((element) => element == player)) {
        return true;
      }
    }

    // Check diagonals
    bool diagonal1 =
        List.generate(gridSize, (index) => moves[index * (gridSize + 1)])
            .every((element) => element == player);
    bool diagonal2 =
        List.generate(gridSize, (index) => moves[(index + 1) * (gridSize - 1)])
            .every((element) => element == player);

    return diagonal1 || diagonal2;
  }

  int _trapPlayer(List<String> board, String player, int target) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = player;
        if (checkWinner(player)) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }
    return -1;
  }

  int _findMove(List<String> board, String player, int target) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = player;
        if (checkWinner(player)) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }

    int trapMove = _trapPlayer(board, player == 'X' ? 'O' : 'X', target);
    if (trapMove != -1) {
      return trapMove;
    }

    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = player;
        if (checkAlmostWin(board, player, target)) {
          return i;
        }
        board[i] = '';
      }
    }
    return -1;
  }

  bool checkAlmostWin(List<String> board, String player, int target) {
    for (int i = 0; i < board.length; i += target) {
      if (board.skip(i).take(target).where((e) => e == player).length ==
              target - 1 &&
          board.skip(i).take(target).contains('')) {
        return true;
      }
    }

    for (int i = 0; i < target; i++) {
      List<String> column = [];
      for (int j = i; j < board.length; j += target) {
        column.add(board[j]);
      }
      if (column.where((e) => e == player).length == target - 1 &&
          column.contains('')) {
        return true;
      }
    }

    List<String> diagonal1 = [];
    List<String> diagonal2 = [];
    for (int i = 0; i < board.length; i += target + 1) {
      diagonal1.add(board[i]);
    }
    for (int i = target - 1; i < board.length - 1; i += target - 1) {
      diagonal2.add(board[i]);
    }
    if (diagonal1.where((e) => e == player).length == target - 1 &&
        diagonal1.contains('')) {
      return true;
    }
    if (diagonal2.where((e) => e == player).length == target - 1 &&
        diagonal2.contains('')) {
      return true;
    }

    return false;
  }

  void _makeAIMove(BuildContext context) {
    int gridLength = sqrt(_game.moves.length).toInt();

    Future.delayed(Duration(milliseconds: 500), () {
      int blockMove = _findMove(_game.moves, _game.currentPlayer, gridLength);
      if (blockMove != -1) {
        _game.moves[blockMove] = _game.currentPlayer;
      } else {
        List<int> emptyPositions = [];
        for (int i = 0; i < _game.moves.length; i++) {
          if (_game.moves[i] == '') {
            emptyPositions.add(i);
          }
        }
        int randomIndex = Random().nextInt(emptyPositions.length);
        int randomPosition = emptyPositions[randomIndex];
        _game.moves[randomPosition] = _game.currentPlayer;
      }

      if (checkWinner(_game.currentPlayer)) {
        _showWinnerDialog(context, _game.currentPlayer);
      } else if (!_game.moves.contains('')) {
        _showWinnerDialog(context, 'Draw');
      } else {
        _game.currentPlayer = _game.currentPlayer == 'X' ? 'O' : 'X';
      }

      isAIMoving = false;
      notifyListeners();
    });
  }

  void _showWinnerDialog(BuildContext context, String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(winner == 'Draw' ? 'Draw' : '$winner Wins!'),
          actions: <Widget>[
            TextButton(
              child: Text('Save Game'),
              onPressed: () {
                saveGameHistory();
                resetGame();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    _game.moves = List.generate(_game.gridSize * _game.gridSize, (_) => '');
    _game.currentPlayer = 'X';
    notifyListeners();
  }

  void saveGameHistory() async {
    final db = _database;
    if (db != null) {
      await db.insert(
        'game_history',
        {
          'moves': _game.moves.join(','),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      loadGameHistory();
    }
  }

  Future<void> loadGameHistory() async {
    final db = _database;
    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query('game_history');
      gameHistory = List.generate(maps.length, (i) {
        final moves = maps[i]['moves'].split(',').toList();
        final gridSize = moves.length == 9
            ? '3x3'
            : moves.length == 16
                ? '4x4'
                : '5x5';
        return {
          'gridSize': gridSize,
          'moves': moves,
        };
      });
      notifyListeners();
    }
  }

  void deleteGameHistory(int index) async {
    final db = _database;
    if (db != null) {
      await db.delete(
        'game_history',
        where: "id = ?",
        whereArgs: [index + 1],
      );
      loadGameHistory();
    }
  }

  void replayGame(int index) {
    final game = gameHistory[index];
    final List<String> moves = game['moves'];
    replayMoves = List.from(moves);
    _game.moves = List.from(replayMoves);
    notifyListeners();
  }

  void clearAllGameHistory() async {
    final db = _database;
    if (db != null) {
      await db.delete('game_history');
      loadGameHistory();
    }
  }

  void loadGameHistoryIfNeeded() {
    if (gameHistory.isEmpty) {
      loadGameHistory();
    }
  }
}
