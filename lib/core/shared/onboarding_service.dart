import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class OnboardingService {
  static const String _onboardingKey = 'onboarding_completed';

  /// Сохраняет состояние завершения онбординга
  /// Возвращает true если сохранение прошло успешно
  static Future<bool> setOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setBool(_onboardingKey, true);
      return result;
    } catch (e) {
      // Логируем ошибку для отладки
      debugPrint('Error when saving the onboarding state: $e');
      return false;
    }
  }

  /// Проверяет, был ли завершен онбординг
  /// Возвращает false в случае ошибки (показываем онбординг)
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingKey) ?? false;
      return isCompleted;
    } catch (e) {
      // Логируем ошибку для отладки
      debugPrint('Error when saving the onboarding state: $e');
      return false; // В случае ошибки показываем онбординг
    }
  }

  /// Сбрасывает состояние онбординга (для тестирования)
  static Future<bool> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_onboardingKey);
      return result;
    } catch (e) {
      debugPrint('Error when saving the onboarding state: $e');
      return false;
    }
  }
}