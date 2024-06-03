import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_schedule/widgets/existing_condition.dart';
import 'package:checkapp_plugin_example/features/create_time/cubit/cubit/time_cubit.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:checkapp_plugin_example/shared/widgets/hover_ink_well.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateSchedulePage extends StatelessWidget {
  final Map<String, dynamic> extra;

  const CreateSchedulePage({super.key, required this.extra});
  BlockCubit get blockCubit => extra['blockCubit'];
  TimeCubit get timeCubit => extra['timeCubit'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 32, color: Colors.blue),
                onPressed: () {
                  context.pop();
                },
              ),
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Expanded(
                  child: Column(
                    children: [
                      Row(
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
                      const Gap(16),
                      timeCubit.state.days.isNotEmpty &&
                              timeCubit.state.timings.isNotEmpty
                          ? ExistingCondition(
                              conditionType: 'Time',
                              text1: timeCubit.state.days
                                  .map((d) => d.day)
                                  .join(', '),
                              extra: extra,
                              timeCubit: timeCubit,
                              onTap: () => context.pushNamed('create-time',
                                  extra: extra),
                              text2: timeCubit.state.timings
                                  .map((e) => '${e.start} to ${e.end}')
                                  .join(', '),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Blocklist",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Gap(16),
                      HoverInkWell(
                        onTap: () =>
                            context.pushNamed('create-block', extra: extra),
                        inkWellPadding: const EdgeInsets.all(8),
                        child: GreyContainer(
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Applications",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Icon(Icons.navigate_next)
                                ],
                              ),
                              const Gap(16),
                              if (blockCubit.state.apps.isNotEmpty)
                                ...blockCubit.state.apps.map((App app) =>
                                    AppRow(
                                        app: app,
                                        key: Key(app.appName),
                                        width: 30))
                              else
                                Container(),
                            ],
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
