import 'package:checkapp_plugin_example/features/basic/presentation/basic_screen.dart';
import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/blocking_conditions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/accessibility_permissions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/block_permissions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/pages/create_block_page.dart';
import 'package:checkapp_plugin_example/features/create_launch_count/launch_limit.dart';
import 'package:checkapp_plugin_example/features/create_location/widgets/location_permission.dart';
import 'package:checkapp_plugin_example/features/create_location/widgets/set_location_page.dart';
import 'package:checkapp_plugin_example/features/create_schedule/create_schedule_page.dart';
import 'package:checkapp_plugin_example/features/create_time/time_limit_page.dart';
import 'package:checkapp_plugin_example/features/create_usage_limit/usage_limit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/wifi_limit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/wifi_permission_page.dart';
import 'package:checkapp_plugin_example/features/details/presentation/details_screen.dart';
import 'package:checkapp_plugin_example/features/home/presentation/home_page.dart';
import 'package:checkapp_plugin_example/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> _permissionsRouter = <RouteBase>[
  GoRoute(
    name: RouteNames.createBlockPermission,
    path: 'block-permission',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const BlockPermissionsPage(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return BlockPermissionsPage(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createAccessibilityPermission,
    path: 'accessibility-permission',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) {
        return const AccessibilityPermissionsPage(extra: {});
      }

      final extra = state.extra as Map<String, dynamic>;

      return AccessibilityPermissionsPage(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createLocationPermission,
    path: 'location-permission',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const LocationPermission(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return LocationPermission(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createWifiPermission,
    path: 'wifi-permission',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const WifiPermissionPage(extra: {});

      final extra = (state.extra as Map<String, dynamic>);

      return WifiPermissionPage(
        extra: extra,
      );
    },
  ),
];
final List<RouteBase> _createScheduleRouter = <RouteBase>[
  GoRoute(
    name: RouteNames.createBlock,
    path: 'create-schedule',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const CreateBlockPage(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return CreateBlockPage(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createLocation,
    path: 'location',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const SetLocationPage(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return SetLocationPage(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.confirmSchedule  ,
    path: 'confirm',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) {
        return CreateSchedulePage(extra: {'blockCubit': BlockCubit()});
      }

      final extra = state.extra as Map<String, dynamic>;

      return CreateSchedulePage(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createTime,
    path: 'time',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const TimeLimitPage(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return TimeLimitPage(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createWifi,
    path: 'wifi',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const WifiLimit(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return WifiLimit(extra: extra);
    },
  ),
  GoRoute(
    name:   RouteNames.createLaunchCount,
    path: 'launch-count',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const LaunchLimit(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return LaunchLimit(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createUsageLimit,
    path: 'usage-limit',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const UsageLimit(extra: {});

      final extra = state.extra as Map<String, dynamic>;

      return UsageLimit(extra: extra);
    },
  ),
  GoRoute(
    name: RouteNames.createBlockingConditions,
    path: 'blocking-conditions',
    builder: (BuildContext context, GoRouterState state) {
      if (state.extra == null) return const BlockingConditionsPage(extra: {});
      final extra = state.extra as Map<String, dynamic>;
      return BlockingConditionsPage(extra: extra);
    },
  ),
];

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: 'home',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
        ),
        GoRoute(
            path: 'basic',
            builder: (BuildContext context, GoRouterState state) {
              return BasicScreen();
            }),
        ..._createScheduleRouter,
        ..._permissionsRouter
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
