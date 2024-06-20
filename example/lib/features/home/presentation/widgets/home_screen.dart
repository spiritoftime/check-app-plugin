import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_bloc.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_state.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/accordion.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/carousel_icons.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/schedule_row.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/schedule_template_carousel.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/endless_scrolling_widget.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  // final DatabaseRepository _databaseService = DatabaseRepository();

  HomeScreen({super.key});
  final CheckappPlugin checkappPlugin = CheckappPlugin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.shield,
                              color: Colors.blue,
                              size: 32.0,
                              semanticLabel: 'App Icon',
                            ),
                          ),
                          Text(
                            'Doomscroll',
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Color(0xff4F8FE9),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Gap(20),
                      GreyContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Quick Block",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0),
                              ),
                              const Gap(12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  backgroundColor: const Color(0xff5094F5),
                                ),
                                onPressed: () async {
                                  // print(await getDatabasesPath());
                                  // print(await AuthenticationRepository().userId);
                                  // await DatabaseRepository().database;
                                  // context.go('/basic');
                                  // List<Schedule> schedules =
                                  //     await DatabaseRepository().schedules();

                                  // for (final s in schedules) {
                                  //   print(s.toJson());
                                  // }
                                  // context.go('/test');
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.block,
                                      color: Colors.white,
                                    ),
                                    Gap(8),
                                    Text(
                                      "Block Now",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Schedule",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff5094F5),
                              ),
                              onPressed: () async {
                                try {
                                  List<bool> arePermissionsEnabled =
                                      await Future.wait([
                                    checkappPlugin.checkUsagePermission(),
                                    checkappPlugin.checkOverlayPermission(),
                                    checkappPlugin
                                        .checkNotificationPermission(),
                                    checkappPlugin.checkBackgroundPermission(),
                                  ]);
                                  if (arePermissionsEnabled.contains(false) &&
                                      context.mounted) {
                                    context.goNamed('create-block-permission',
                                        extra: <String, dynamic>{
                                          'blockPermissions':
                                              arePermissionsEnabled
                                        });
                                  } else if (context.mounted) {
                                    context.goNamed('create-block',
                                        extra: <String, dynamic>{});
                                  } else {
                                    print('context not mounted');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              icon: const Icon(Icons.add,
                                  color: Colors.white, size: 24),
                              label: const Text(
                                'Create Schedule',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      GreyContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: BlocBuilder<SchedulesBloc, ScheduleState>(
                          builder: (context, state) {
                            if (state is SchedulesLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is SchedulesLoaded) {
                              if (state.schedules.isEmpty) {
                                return Column(
                                  children: [
                                    const Text(
                                      "Plan your everyday blocking by time,\n location and more.",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Gap(32),
                                    EndlessScrollingWidget(
                                        gap: 20,
                                        widgetWidth: 48,
                                        scrollDuration:
                                            const Duration(seconds: 8),
                                        widgetHeight: 48,
                                        children: carouselIcons)
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    ...state.schedules.map(
                                      (Schedule s) => ScheduleRow(schedule: s),
                                    )
                                  ],
                                );
                              }
                            } else {
                              return const Text('No App Found');
                            }
                          },
                        ),
                      ),
                      const Gap(20),
                      const AccordionPage(
                        content: ScheduleTemplateCarousel(),
                        header: "Schedule Templates",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


