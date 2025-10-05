import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parking_spot_log/core/router/router.dart';
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

final router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router.config() ,
    );
  }
}
