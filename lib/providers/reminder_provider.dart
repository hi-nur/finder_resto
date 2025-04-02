import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/notification_service.dart';

class ReminderProvider with ChangeNotifier {
  bool _isReminderActive = false;
  final NotificationService _notificationService = NotificationService();

  bool get isReminderActive => _isReminderActive;

  static const String _reminderPreferenceKey = 'reminder_preference';

  Future<void> loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderActive = prefs.getBool(_reminderPreferenceKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleReminder(bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderActive = isActive;
    await prefs.setBool(_reminderPreferenceKey, isActive);

    if (isActive) {
      await _notificationService.scheduleDailyNotification();
    } else {
      await _notificationService.cancelNotification();
    }

    notifyListeners();
  }
}
