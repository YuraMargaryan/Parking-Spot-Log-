import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parking_spot_log/core/shared/onboarding_service.dart';
import 'package:parking_spot_log/home/home_screen.dart';
import 'package:parking_spot_log/screen/onbording/onbording_screen.dart';
import 'package:parking_spot_log/screen/push/notification_service.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
  FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServiceIOS().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: AppInitializer(),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final completed = await OnboardingService.isOnboardingCompleted();
      if (mounted) {
        setState(() {
          _showOnboarding = !completed;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Если произошла ошибка, показываем онбординг
      if (mounted) {
        setState(() {
          _showOnboarding = true;
          _isLoading = false;
        });
      }
    }
  }

  void _onOnboardingCompleted() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CupertinoPageScaffold(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return _showOnboarding
        ? OnboardingScreen(onCompleted: _onOnboardingCompleted)
        : const HomeScreen();
  }
}


