import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:parking_spot_log/core/database/database.dart';
import 'package:parking_spot_log/screen/onbording/app_initializer.dart';
import 'package:parking_spot_log/screen/onbording/onbording_screen.dart';
import 'package:parking_spot_log/screen/jurnal/jurnal_screen.dart';
import 'package:parking_spot_log/screen/navigation/navigation_screen.dart';
import 'package:parking_spot_log/screen/note/note_screen.dart';
import 'package:parking_spot_log/screen/push/push_screen.dart';
import 'package:parking_spot_log/screen/setting/settings_screen.dart';
import 'package:parking_spot_log/home/home_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    // Главный маршрут - инициализатор приложения
    AutoRoute(
      page: AppInitializerRoute.page,
      initial: true,
    ),
    
    // Онбординг
    AutoRoute(
      page: OnboardingRoute.page,
    ),
    
    // Главный экран с навигацией
    AutoRoute(
      page: HomeRoute.page,
    ),
    
    // Журнал парковки
    AutoRoute(
      page: JurnalRoute.page,
    ),
    
    // Карта с парковочными местами
    AutoRoute(
      page: MapRoute.page,
    ),
    
    // Заметки о парковке (теперь интегрированы в журнал)
    // AutoRoute(
    //   page: NoteRoute.page,
    // ),
    
    // Уведомления и напоминания
    AutoRoute(
      page: PushRoute.page,
    ),
    
    // Настройки
    AutoRoute(
      page: SettingRoute.page,
    ),
  ];
}