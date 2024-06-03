import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/website_row.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_blocks.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_condition.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateSchedulePage extends StatelessWidget {
  final Map<String, dynamic> extra;

  CreateSchedulePage({super.key, required this.extra});
  BlockCubit get blockCubit => extra['blockCubit'];
  TimeCubit get timeCubit => extra['timeCubit'];
  bool isSubmitEnabled = true;
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
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(fontSize: 24),
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(top: 12),
                              hintText: "Schedule Name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
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
                                    timeCubit: timeCubit,
                                    onTap: () => context
                                        .pushNamed('create-time', extra: extra),
                                    text2: timeCubit.state.timings
                                        .map((e) => '${e.start} to ${e.end}')
                                        .join(', '),
                                  )
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
                          )),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 64),
                backgroundColor: isSubmitEnabled ? Colors.blue : Colors.grey,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
              ),
              onPressed:
                  isSubmitEnabled ? () {} : null, // null disables the button
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
