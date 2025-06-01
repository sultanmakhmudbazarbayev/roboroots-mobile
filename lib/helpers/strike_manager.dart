import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/user_service.dart';

class StrikeManager {
  static const _lastShownKey = 'strike_animation_last_shown';

  static Future<bool> _shouldShowStrikeAnimation() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return prefs.getString(_lastShownKey) != today;
  }

  static Future<void> _markShown() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString(_lastShownKey, today);
  }

  static Future<void> showStrikeIfNeeded(Function(int) onStrikeReady) async {
    if (!await _shouldShowStrikeAnimation()) return;

    try {
      final strikeDays = await UserService().checkStrike();
      await _markShown();
      onStrikeReady(strikeDays);
    } catch (e) {
      print('Strike check failed: $e');
    }
  }
}
