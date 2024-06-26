import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/partial_blocking_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/website_row.dart';
import 'package:checkapp_plugin_example/features/create_location/cubit/location_cubit.dart';
import 'package:checkapp_plugin_example/features/create_schedule/cubit/schedule_cubit.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule/schedule.dart';
import 'package:checkapp_plugin_example/features/create_schedule/models/schedule_details/schedule_details.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_blocks.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_condition.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_dialog.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/icon_selection.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/schedule_name.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/cubit/cubit/wifi_cubit.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_bloc.dart';
import 'package:checkapp_plugin_example/features/home/bloc/schedule_event.dart';
import 'package:checkapp_plugin_example/router/route_names.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:checkapp_plugin_example/shared/widgets/show_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateSchedulePage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const CreateSchedulePage({super.key, required this.extra});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  final CheckappPlugin _checkappPlugin = CheckappPlugin();

  ScheduleCubit get scheduleCubit =>
      widget.extra['scheduleCubit'] ?? ScheduleCubit();
  BlockCubit get blockCubit => widget.extra['blockCubit'];

  TimeCubit get timeCubit => widget.extra['timeCubit'] ?? TimeCubit();

  LocationCubit get locationCubit =>
      widget.extra['locationCubit'] ?? LocationCubit();
  WifiCubit get wifiCubit => widget.extra['wifiCubit'] ?? WifiCubit();
  late String _iconName;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _iconName = scheduleCubit.state.scheduleDetails.iconName != ''
        ? scheduleCubit.state.scheduleDetails.iconName
        : 'schedule';
    _controller.text = scheduleCubit.state.scheduleDetails.scheduleName;
  }

  List<Widget> appWidgets() {
    if (blockCubit.state.apps.isNotEmpty) {
      return blockCubit.state.apps
          .map((App app) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: AppRow(app: app, key: Key(app.appName), width: 30),
              ))
          .toList();
    } else {
      return [Container()];
    }
  }

  List<Widget> websiteWidgets() {
    if (blockCubit.state.websites.isNotEmpty) {
      return blockCubit.state.websites
          .map((website) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: WebsiteRow(
                  website: website,
                  key: Key(website.url),
                ),
              ))
          .toList();
    } else {
      return [Container()];
    }
  }

  List<Widget> keywordWidgets() {
    if (blockCubit.state.keywords.isNotEmpty) {
      return blockCubit.state.keywords
          .map((keyword) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: KeywordRow(
                  keyword: keyword.keyword,
                  key: Key(keyword.keyword),
                ),
              ))
          .toList();
    } else {
      return [Container()];
    }
  }

  List<Widget> partialBlockerWidgets() {
    if (blockCubit.state.partialBlockers.isNotEmpty) {
      return blockCubit.state.partialBlockers
          .map((partialBlocker) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: PartialBlockingRow(
                partialBlocker: partialBlocker,
                imageSize: 50,
              )))
          .toList();
    } else {
      return [Container()];
    }
  }

  void _updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close,
                            size: 32, color: Colors.blue),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.purple[100],
                              child: Icon(icons[_iconName],
                                  color: Colors.blue, size: 80.0),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: HoverInkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return IconDialog(
                                            currentIconName: _iconName,
                                            onChanged: (iconName) => setState(
                                                () => _iconName = iconName));
                                      });
                                },
                                inkColor: Colors.transparent,
                                inkWellPadding: const EdgeInsets.all(0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.edit,
                                        color: Colors.white, size: 24.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(child: ScheduleName(controller: _controller)),
                      const Gap(8),
                      const Divider(height: 1, color: Colors.grey),
                      AccordionWrapper(
                        header: Row(
                          children: [
                            const Text(
                              "Conditions",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () => context.pushNamed(
                                  'create-blocking-conditions',
                                  extra: widget.extra),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        content: Column(
                          children: [
                            timeCubit.state.days.isNotEmpty &&
                                    timeCubit.state.timings.isNotEmpty
                                ? ExistingCondition(
                                    conditionType: 'Time',
                                    text1: timeCubit.state.days
                                        .map((d) => d.day)
                                        .join(', '),
                                    extra: widget.extra,
                                    onTap: (BuildContext context, extra) =>
                                        context.pushNamed('create-time',
                                            extra: extra),
                                    text2: timeCubit.state.timings
                                        .map((e) =>
                                            '${e.startTiming} to ${e.endTiming}')
                                        .join(', '),
                                    updateUI: _updateUI,
                                  )
                                : Container(),
                            const Gap(16),
                            locationCubit.state.isNotEmpty
                                ? ExistingCondition(
                                    extra: widget.extra,
                                    conditionType: 'Location',
                                    onTap: (BuildContext context, extra) async {
                                      bool isLocationEnabled =
                                          await _checkappPlugin
                                              .checkLocationPermission();
                                      if (!isLocationEnabled &&
                                          context.mounted) {
                                        context.pushNamed(
                                            'create-location-permission',
                                            extra: extra);
                                      } else if (context.mounted) {
                                        context.pushNamed('create-location',
                                            extra: extra);
                                      }
                                    },
                                    text1: locationCubit.state
                                        .map((l) => l.location)
                                        .join('\n'),
                                    text2: '',
                                    updateUI: _updateUI,
                                  )
                                : Container(),
                            const Gap(16),
                            wifiCubit.state.isNotEmpty
                                ? ExistingCondition(
                                    extra: widget.extra,
                                    conditionType: 'Wifi',
                                    onTap: (BuildContext context, extra) async {
                                      List<bool> wifiPermissionsEnabled =
                                          await Future.wait([
                                        _checkappPlugin.checkGPSEnabled(),
                                        _checkappPlugin
                                            .checkLocationPermission()
                                      ]);
                                      final bool isGPSEnabled =
                                          wifiPermissionsEnabled[0];
                                      final bool isLocationEnabled =
                                          wifiPermissionsEnabled[1];
                                      if (!context.mounted) return;

                                      if (!isLocationEnabled || !isGPSEnabled) {
                                        context.pushNamed(
                                          'create-wifi-permission',
                                          extra: {
                                            ...extra as Map<String, dynamic>,
                                            'wifiPermissionsEnabled':
                                                wifiPermissionsEnabled
                                          },
                                        );
                                        return;
                                      }
                                      context.pushNamed('create-wifi',
                                          extra: extra);
                                    },
                                    text1: wifiCubit.state
                                        .map((w) => w.wifiName)
                                        .join(', '),
                                    text2: '',
                                    updateUI: _updateUI,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      AccordionWrapper(
                        header: const Text(
                          "Blocklist",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          children: [
                            ExistingBlocks(
                              extra: widget.extra,
                              blockCubit: blockCubit,
                              blockType: "Applications",
                              widgets: appWidgets,
                            ),
                            const Gap(16),
                            ExistingBlocks(
                              extra: widget.extra,
                              blockCubit: blockCubit,
                              blockType: "Websites",
                              widgets: websiteWidgets,
                            ),
                            const Gap(16),
                            ExistingBlocks(
                              extra: widget.extra,
                              blockCubit: blockCubit,
                              blockType: "Keywords",
                              widgets: keywordWidgets,
                            ),
                            const Gap(16),
                            ExistingBlocks(
                              extra: widget.extra,
                              blockCubit: blockCubit,
                              blockType: "Partial Blockers",
                              widgets: partialBlockerWidgets,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 64),
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
              ),
              onPressed: () async {
                String scheduleName = _controller.text;

                if (timeCubit.state.days.isNotEmpty &&
                        timeCubit.state.timings.isEmpty ||
                    timeCubit.state.days.isEmpty &&
                        timeCubit.state.timings.isNotEmpty ||
                    timeCubit.state.days.isEmpty &&
                        timeCubit.state.timings.isEmpty) {
                  await createAlertDialog(
                    context,
                    const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    ),
                    const Text(
                        "Please enter both days and timings if you want to create a schedule with time conditions. Click the add button under conditions and re-edit the time condition"),
                  );
                  return;
                }
                if (blockCubit.state.keywords.isNotEmpty ||
                    blockCubit.state.websites.isNotEmpty ||
                    blockCubit.state.partialBlockers.isNotEmpty) {
                  List<bool> arePermissionsEnabled = await Future.wait([
                    _checkappPlugin.checkAccessibilityPermission(),
                    _checkappPlugin.checkBatteryOptimizationDisabled(),
                  ]);
                  if (arePermissionsEnabled.contains(false) &&
                      context.mounted) {
                    context.goNamed(RouteNames.createAccessibilityPermission,
                        extra: <String, dynamic>{
                          'accessibilityPermissions': arePermissionsEnabled,
                          'blockCubit': blockCubit,
                          ...widget.extra
                        });
                    return;
                  }
                }
                if (scheduleName.isEmpty) {
                  await createAlertDialog(
                    context,
                    const Text(
                      "Error",
                      style: TextStyle(color: Colors.red),
                    ),
                    const Text("Please enter a schedule name"),
                  );
                  return;
                }

                if (scheduleCubit.state.id != null && context.mounted) {
                  //  compile everything to one schedule
                  Schedule schedule = Schedule(
                      id: scheduleCubit.state.id,
                      wifi: wifiCubit.state,
                      scheduleDetails: ScheduleDetails(
                        isActive: true,
                        scheduleName: _controller.text,
                        iconName: _iconName,
                      ),
                      location: locationCubit.state,
                      time: timeCubit.state,
                      block: blockCubit.state);

                  context.read<SchedulesBloc>().add(UpdateSchedule(schedule));
                  _checkappPlugin.reQueryActiveSchedules();
                } else if (context.mounted) {
                  //  compile everything to one schedule
                  Schedule schedule = Schedule(
                      wifi: wifiCubit.state,
                      scheduleDetails: ScheduleDetails(
                        isActive: false,
                        scheduleName: _controller.text,
                        iconName: _iconName,
                      ),
                      location: locationCubit.state,
                      time: timeCubit.state,
                      block: blockCubit.state);
                  context.read<SchedulesBloc>().add(AddSchedule(schedule));
                }
                if (context.mounted) {
                  context.read<SchedulesBloc>().add(LoadSchedules());
                  context.goNamed(RouteNames.home);
                }
              },
              child: const Text(
                "Save Schedule",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
