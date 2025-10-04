import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_model.dart';

class NotificationStorageService {
  static const String _notificationsKey = 'scheduled_notifications';
  
  static Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationsJson = prefs.getString(_notificationsKey);
    
    if (notificationsJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> notificationsList = json.decode(notificationsJson);
      return notificationsList
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  static Future<void> saveNotification(NotificationModel notification) async {
    final notifications = await getNotifications();
    notifications.add(notification);
    await _saveNotifications(notifications);
  }
  
  static Future<void> deleteNotification(int id) async {
    final notifications = await getNotifications();
    notifications.removeWhere((notification) => notification.id == id);
    await _saveNotifications(notifications);
  }
  
  static Future<void> updateNotification(NotificationModel updatedNotification) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == updatedNotification.id);
    if (index != -1) {
      notifications[index] = updatedNotification;
      await _saveNotifications(notifications);
    }
  }
  
  static Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }
  
  static Future<void> _saveNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = json.encode(
      notifications.map((notification) => notification.toJson()).toList(),
    );
    await prefs.setString(_notificationsKey, notificationsJson);
  }
}
