import 'package:shared_preferences/shared_preferences.dart';

class GameHistory {
  static const String _key = 'game_history';

  static Future<List<List<String>>> loadGameHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList(_key);
    return history?.map((moves) => moves.split(',')).toList() ?? [];
  }

  static Future<void> saveGameHistory(List<List<String>> history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> movesList = history.map((moves) => moves.join(',')).toList();
    await prefs.setStringList(_key, movesList);
  }

  static Future<void> clearGameHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
