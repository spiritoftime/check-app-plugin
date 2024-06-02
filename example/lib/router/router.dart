import 'package:checkapp_plugin_example/features/basic/presentation/basic_screen.dart';
import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/blocking_conditions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/create_block_page.dart';
import 'package:checkapp_plugin_example/features/create_launch_count/launch_limit.dart';
import 'package:checkapp_plugin_example/features/create_location/location_limit.dart';
import 'package:checkapp_plugin_example/features/create_time/time_limit_page.dart';
import 'package:checkapp_plugin_example/features/create_usage_limit/usage_limit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/wifi_limit.dart';
import 'package:checkapp_plugin_example/features/details/presentation/details_screen.dart';
import 'package:checkapp_plugin_example/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
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
        GoRoute(
            path: 'create-block',
            builder: (BuildContext context, GoRouterState state) {
              return const CreateBlockPage();
              // return BlocProvider.value(
              //   value: BlocProvider.of<AppsBloc>(context),
              //   child: const CreateBlockPage(),
              // );
            }),
        GoRoute(
            path: 'blocking-conditions',
            builder: (BuildContext context, GoRouterState state) {
              return BlockingConditionsPage();
            }),
        GoRoute(
            path: 'create-schedule-location',
            builder: (BuildContext context, GoRouterState state) {
              return const LocationLimit();
            }),
        GoRoute(
          path: 'create-schedule-time',
          builder: (BuildContext context, GoRouterState state) {
            return const TimeLimitPage();
          },
        ),
        GoRoute(
          path: 'create-schedule-wifi',
          builder: (BuildContext context, GoRouterState state) {
            return const WifiLimit();
          },
        ),
        GoRoute(
          path: 'create-schedule-launch-count',
          builder: (BuildContext context, GoRouterState state) {
            return const LaunchLimit();
          },
        ),
        GoRoute(
          path: 'create-schedule-usage-limit',
          builder: (BuildContext context, GoRouterState state) {
            return const UsageLimit();
          },
        ),
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
        ));
  }
}
