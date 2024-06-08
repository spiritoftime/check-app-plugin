import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/website_row.dart';
import 'package:checkapp_plugin_example/features/create_location/cubit/location_cubit.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_blocks.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_condition.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/schedule_name.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:checkapp_plugin_example/shared/widgets/show_dialog.dart';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateSchedulePage extends StatelessWidget {
  final Map<String, dynamic> extra;

  CreateSchedulePage({super.key, required this.extra});
  BlockCubit get blockCubit => extra['blockCubit'];
  TimeCubit get timeCubit => extra['timeCubit'] ?? TimeCubit();
  LocationCubit get locationCubit => extra['locationCubit'] ?? LocationCubit();
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
                  keyword: keyword,
                  key: Key(keyword.keyword),
                ),
              ))
          .toList();
    } else {
      return [Container()];
    }
  }

  final TextEditingController _controller = TextEditingController();

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
                            const Icon(Icons.schedule,
                                color: Colors.blue, size: 80.0),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: HoverInkWell(
                                onTap: () {},
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
                                  extra: extra),
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
                                    extra: extra,
                                    onTap: () => context
                                        .pushNamed('create-time', extra: extra),
                                    text2: timeCubit.state.timings
                                        .map((e) => '${e.start} to ${e.end}')
                                        .join(', '),
                                  )
                                : Container(),
                            const Gap(16),
                            locationCubit.state.location.isNotEmpty
                                ? ExistingCondition(
                                    extra: extra,
                                    conditionType: 'Location',
                                    onTap: () => context.pushNamed(
                                        'create-location',
                                        extra: extra),
                                    text1: locationCubit.state.location,
                                    text2: '')
                                : Container()
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
                              extra: extra,
                              blockCubit: blockCubit,
                              blockType: "Applications",
                              widgets: appWidgets,
                            ),
                            const Gap(16),
                            ExistingBlocks(
                              extra: extra,
                              blockCubit: blockCubit,
                              blockType: "Websites",
                              widgets: websiteWidgets,
                            ),
                            const Gap(16),
                            ExistingBlocks(
                              extra: extra,
                              blockCubit: blockCubit,
                              blockType: "Keywords",
                              widgets: keywordWidgets,
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
                if (scheduleName.isEmpty) {
                  await createDialog(context, const Text("Error"),
                      const Text("Please enter a schedule name"));
                  return;
                }
                if (timeCubit.state.days.isNotEmpty &&
                        timeCubit.state.timings.isEmpty ||
                    timeCubit.state.days.isEmpty &&
                        timeCubit.state.timings.isNotEmpty) {
                  await createDialog(
                      context,
                      const Text("Error"),
                      const Text(
                          "Please enter both days and timings if you want to create a schedule with time conditions. Click the add button under conditions and re-edit the time condition"));
                  return;
                }
                //  compile everything to one schedule
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
