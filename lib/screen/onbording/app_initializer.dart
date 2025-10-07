import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:parking_spot_log/core/shared/onboarding_service.dart';
import 'package:parking_spot_log/home/home_screen.dart';
import 'package:parking_spot_log/screen/onbording/onbording_screen.dart';

@RoutePage()
class AppInitializerScreen extends StatefulWidget {
  const AppInitializerScreen({super.key});

  @override
  State<AppInitializerScreen> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializerScreen> {
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

    if (_showOnboarding) {
      return OnboardingScreen(onCompleted: _onOnboardingCompleted);
    } else {
      return const HomeScreen();
    }
  }
}


