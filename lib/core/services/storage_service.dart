import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ... (Keep existing transformation logic) ...

  static String? get lastTransformationDate =>
      _prefs.getString('lastTransformationDate');

  static Future<void> setLastTransformationDate(String value) async {
    await _prefs.setString('lastTransformationDate', value);
  }

  static bool get hasAccepted =>
      _prefs.getBool('hasAccepted') ?? false;

  static Future<void> setAccepted(bool value) async {
    await _prefs.setBool('hasAccepted', value);
  }

  // --- NEW: FUTURE PLANS ---
  static List<String> get futurePlans =>
      _prefs.getStringList('futurePlans') ?? [];

  static Future<void> setFuturePlans(List<String> plans) async {
    await _prefs.setStringList('futurePlans', plans);
  }
}