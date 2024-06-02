import 'package:checkapp_plugin_example/features/basic/presentation/basic_screen.dart';
import 'package:checkapp_plugin_example/features/blocking_conditions/presentation/blocking_conditions_page.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/create_block_page.dart';
import 'package:checkapp_plugin_example/features/create_launch_count/launch_limit.dart';
import 'package:checkapp_plugin_example/features/create_location/location_limit.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_time/time_limit_page.dart';
import 'package:checkapp_plugin_example/features/create_usage_limit/usage_limit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/wifi_limit.dart';
import 'package:checkapp_plugin_example/features/details/presentation/details_screen.dart';
import 'package:checkapp_plugin_example/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRoute _createScheduleRouter = GoRoute(
    path: 'create-schedule',
    routes: <RouteBase>[
      GoRoute(
        name: 'create-block',
        path: 'block',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateBlockPage();
        },
      ),
      GoRoute(
        name: 'create-location',
        path: 'location',
        builder: (BuildContext context, GoRouterState state) {
          return const LocationLimit();
        },
      ),
      GoRoute(
        name: 'create-time',
        path: 'time',
        builder: (BuildContext context, GoRouterState state) {
          return const TimeLimitPage();
        },
      ),
      GoRoute(
        name: 'create-wifi',
        path: 'wifi',
        builder: (BuildContext context, GoRouterState state) {
          return const WifiLimit();
        },
      ),
      GoRoute(
        name: 'create-launch-count',
        path: 'launch-count',
        builder: (BuildContext context, GoRouterState state) {
          return const LaunchLimit();
        },
      ),
      GoRoute(
        name: 'create-usage-limit',
        path: 'usage-limit',
        builder: (BuildContext context, GoRouterState state) {
          return const UsageLimit();
        },
      ),
      GoRoute(
        name: 'create-blocking-conditions',
        path: 'blocking-conditions',
        builder: (BuildContext context, GoRouterState state) {
          return BlockingConditionsPage();
        },
      ),
    ],
    builder: (BuildContext context, GoRouterState state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TimeCubit()),
          BlocProvider(create: (context) => BlockCubit()),
        ],
        child: const CreateBlockPage(),
      );
    });

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
        _createScheduleRouter
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
