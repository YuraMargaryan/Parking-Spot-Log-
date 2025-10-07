
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:parking_spot_log/screen/jurnal/jurnal_screen.dart';
import 'package:parking_spot_log/screen/navigation/navigation_screen.dart';
import 'package:parking_spot_log/screen/push/push_screen.dart';
import 'package:parking_spot_log/screen/setting/settings_screen.dart';
import 'package:parking_spot_log/core/database/database.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AppDatabase _db = AppDatabase();

  List<Widget> get _screens => [
    JurnalScreen(),
    PushScreen(),
    MapScreen(db: _db),
    SettingScreen()
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CupertinoColors.systemBackground,
            CupertinoColors.systemGrey6,
          ],
        ),
      ),
      child: CupertinoTabScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: _selectedIndex == 0 
                      ? LinearGradient(
                          colors: [
                            CupertinoColors.systemYellow,
                            CupertinoColors.systemOrange,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedIndex == 0 
                      ? [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  CupertinoIcons.car_fill,
                  color: _selectedIndex == 0 
                      ? CupertinoColors.white 
                      : CupertinoColors.systemGrey,
                  size: 24,
                ),
              ),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: _selectedIndex == 1 
                      ? LinearGradient(
                          colors: [
                            CupertinoColors.systemYellow,
                            CupertinoColors.systemOrange,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedIndex == 1 
                      ? [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  CupertinoIcons.bell_fill,
                  color: _selectedIndex == 1 
                      ? CupertinoColors.white 
                      : CupertinoColors.systemGrey,
                  size: 24,
                ),
              ),
              label: 'Reminders',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: _selectedIndex == 2 
                      ? LinearGradient(
                          colors: [
                            CupertinoColors.systemYellow,
                            CupertinoColors.systemOrange,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedIndex == 2 
                      ? [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  CupertinoIcons.location_fill,
                  color: _selectedIndex == 2 
                      ? CupertinoColors.white 
                      : CupertinoColors.systemGrey,
                  size: 24,
                ),
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: _selectedIndex == 3 
                      ? LinearGradient(
                          colors: [
                            CupertinoColors.systemYellow,
                            CupertinoColors.systemOrange,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedIndex == 3 
                      ? [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  CupertinoIcons.settings,
                  color: _selectedIndex == 3 
                      ? CupertinoColors.white 
                      : CupertinoColors.systemGrey,
                  size: 24,
                ),
              ),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: CupertinoColors.systemBackground.withOpacity(0.9),
          activeColor: CupertinoColors.systemYellow,
          inactiveColor: CupertinoColors.systemGrey,
          border: Border(
            top: BorderSide(
              color: CupertinoColors.systemYellow.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        tabBuilder: (context, index) {
          return _screens[index];
        },
      ),
    );
  }
}