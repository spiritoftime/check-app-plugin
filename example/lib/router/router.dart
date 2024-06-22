import 'package:checkapp_plugin_example/features/basic/presentation/basic_screen.dart';
import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/blocking_conditions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/accessibility_permissions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/permissions/block_permissions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/pages/create_block_page.dart';
import 'package:checkapp_plugin_example/features/create_launch_count/launch_limit.dart';
import 'package:checkapp_plugin_example/features/create_location/widgets/location_permission.dart';
import 'package:checkapp_plugin_example/features/create_location/widgets/set_location_page.dart';
import 'package:checkapp_plugin_example/features/create_schedule/create_schedule_page.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/time_limit_page.dart';
import 'package:checkapp_plugin_example/features/create_usage_limit/usage_limit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/wifi_limit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/wifi_permission_page.dart';
import 'package:checkapp_plugin_example/features/details/presentation/details_screen.dart';
import 'package:checkapp_plugin_example/features/home/presentation/home_page.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> _permissionsRouter = <RouteBase>[
  GoRoute(
    name: 'create-block-permission',
    path: 'block-permission',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return BlockPermissionsPage(extra: extra);
    },
  ),
   GoRoute(
    name: 'create-accessibility-permission',
    path: 'accessibility-permission',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return AccessibilityPermissionsPage(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-location-permission',
    path: 'location-permission',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return LocationPermission(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-wifi-permission',
    path: 'wifi-permission',
    builder: (BuildContext context, GoRouterState state) {
      final extra = (state.extra as Map<String, dynamic>);

      return WifiPermissionPage(
        extra: extra,
      );
    },
  ),
];
final List<RouteBase> _createScheduleRouter = <RouteBase>[
  GoRoute(
    name: 'create-block',
    path: 'create-schedule',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return CreateBlockPage(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-location',
    path: 'location',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return SetLocationPage(extra: extra);
    },
  ),
  GoRoute(
    name: 'confirm-schedule',
    path: 'confirm',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return CreateSchedulePage(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-time',
    path: 'time',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return TimeLimitPage(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-wifi',
    path: 'wifi',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return WifiLimit(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-launch-count',
    path: 'launch-count',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return LaunchLimit(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-usage-limit',
    path: 'usage-limit',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return UsageLimit(extra: extra);
    },
  ),
  GoRoute(
    name: 'create-blocking-conditions',
    path: 'blocking-conditions',
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;
      return BlockingConditionsPage(extra: extra);
    },
  ),
];

/// The route configuration.
final GoRouter _router = GoRouter(
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
      routerConfig: _router,
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
