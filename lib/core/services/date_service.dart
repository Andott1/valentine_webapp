class DateService {
  // We keep the init method to avoid breaking main.dart, 
  // but it doesn't need to do anything complex anymore.
  static Future<void> init() async {
    // No-op: We use system time now, so no initialization needed.
  }

  static DateTime now() {
    return DateTime.now(); // Uses the device's local time
  }

  // TARGET DATE: Feb 14, 2026, 00:00:00 (Local Device Time)
  static DateTime get valentinesStart {
    return DateTime(2026, 2, 14, 0, 0, 0);
  }

  static bool isValentines() {
    return now().isAfter(valentinesStart);
  }

  static Duration timeUntilValentines() {
    // If we are past the date, this returns a negative duration,
    // but the AppController handles that by switching screens anyway.
    return valentinesStart.difference(now());
  }

  static String todayString() {
    final nowDate = now();
    return "${nowDate.year}-${nowDate.month}-${nowDate.day}";
  }
}