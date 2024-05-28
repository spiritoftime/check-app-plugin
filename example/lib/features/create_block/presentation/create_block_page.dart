import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin/checkapp_plugin_method_channel.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app_event.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app_state.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/tab_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/repository/app_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class CreateBlockPage extends StatelessWidget {
  final _checkAppPlugin = CheckappPlugin();

  CreateBlockPage({super.key});
  List<String> _tabs = ["Apps", "Websites", "Keywords"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.blue, size: 24),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => {},
                    icon:
                        const Icon(Icons.search, color: Colors.blue, size: 24),
                  )
                ],
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Blocklist",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0)),
                    const Gap(24),
                    DefaultTabController(
                      length: _tabs.length,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ButtonsTabBar(
                              buttonMargin: const EdgeInsets.only(right: 16),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              backgroundColor: Colors.blue[600],
                              unselectedBackgroundColor: Colors.grey[700],
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                              borderWidth: 1,
                              // unselectedBorderColor: Colors.blue[600],
                              radius: 20,
                              tabs: _tabs.map((e) => Tab(text: e)).toList(),
                            ),
                            const Gap(20),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        BlocProvider(
                                          create: (_) =>
                                              AppsBloc(AppRepository())
                                                ..add(const LoadApp()),
                                          child: BlocBuilder<AppsBloc,
                                              AppsState>(
                                            builder: (context, state) {
                                              if (state is AppsLoading) {
                                                return const CircularProgressIndicator();
                                              }
                                              if (state is AppsLoaded) {
                                                return Column(
                                                  children: state.apps
                                                      .map(
                                                        (app) => Row(
                                                          children: [
                                                            Image.memory(
                                                              const Base64Decoder().convert(app
                                                                  .iconBase64String
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r'\s+'),
                                                                      '')),
                                                              width: 50,
                                                              height: 50,
                                                            ),
                                                            Text(app.appName),
                                                            // Text(app
                                                            //     .packageName),
                                                          ],
                                                        ),
                                                      )
                                                      .toList(),
                                                );
                                              } else {
                                                return const Text(
                                                    'No App Found');
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text("HI"),
                                  Text("HI"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
                onPressed: () {
                  print('hi');
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
