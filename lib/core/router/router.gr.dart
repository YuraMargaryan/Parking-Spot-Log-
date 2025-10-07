// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AppInitializerScreen]
class AppInitializerRoute extends PageRouteInfo<void> {
  const AppInitializerRoute({List<PageRouteInfo>? children})
    : super(AppInitializerRoute.name, initialChildren: children);

  static const String name = 'AppInitializerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppInitializerScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [JurnalScreen]
class JurnalRoute extends PageRouteInfo<void> {
  const JurnalRoute({List<PageRouteInfo>? children})
    : super(JurnalRoute.name, initialChildren: children);

  static const String name = 'JurnalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const JurnalScreen();
    },
  );
}

/// generated route for
/// [MapScreen]
class MapRoute extends PageRouteInfo<MapRouteArgs> {
  MapRoute({Key? key, required AppDatabase db, List<PageRouteInfo>? children})
    : super(
        MapRoute.name,
        args: MapRouteArgs(key: key, db: db),
        initialChildren: children,
      );

  static const String name = 'MapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapRouteArgs>();
      return MapScreen(key: args.key, db: args.db);
    },
  );
}

class MapRouteArgs {
  const MapRouteArgs({this.key, required this.db});

  final Key? key;

  final AppDatabase db;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, db: $db}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapRouteArgs) return false;
    return key == other.key && db == other.db;
  }

  @override
  int get hashCode => key.hashCode ^ db.hashCode;
}

/// generated route for
/// [NoteScreen]
class NoteRoute extends PageRouteInfo<void> {
  const NoteRoute({List<PageRouteInfo>? children})
    : super(NoteRoute.name, initialChildren: children);

  static const String name = 'NoteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NoteScreen();
    },
  );
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    Key? key,
    VoidCallback? onCompleted,
    List<PageRouteInfo>? children,
  }) : super(
         OnboardingRoute.name,
         args: OnboardingRouteArgs(key: key, onCompleted: onCompleted),
         initialChildren: children,
       );

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingRouteArgs>(
        orElse: () => const OnboardingRouteArgs(),
      );
      return OnboardingScreen(key: args.key, onCompleted: args.onCompleted);
    },
  );
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({this.key, this.onCompleted});

  final Key? key;

  final VoidCallback? onCompleted;

  @override
  String toString() {
    return 'OnboardingRouteArgs{key: $key, onCompleted: $onCompleted}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnboardingRouteArgs) return false;
    return key == other.key && onCompleted == other.onCompleted;
  }

  @override
  int get hashCode => key.hashCode ^ onCompleted.hashCode;
}

/// generated route for
/// [PushScreen]
class PushRoute extends PageRouteInfo<void> {
  const PushRoute({List<PageRouteInfo>? children})
    : super(PushRoute.name, initialChildren: children);

  static const String name = 'PushRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PushScreen();
    },
  );
}

/// generated route for
/// [SettingScreen]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingScreen();
    },
  );
}
