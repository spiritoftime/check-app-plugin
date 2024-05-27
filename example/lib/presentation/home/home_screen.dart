import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:checkapp_plugin_example/presentation/home/endless_scrolling_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  HomeScreen({super.key});
  final List<Widget> templateIconSliders = [
    const Icon(
      Icons.access_time,
      size: 100,
      color: Colors.white,
    ),
    const Icon(
      Icons.bike_scooter,
      size: 100,
      color: Colors.white,
    ),
    const Icon(
      Icons.home,
      size: 100,
      color: Colors.white,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
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
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff21222D),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
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
                            onPressed: () {
                              print('hi');
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
                  const Text(
                    "Schedule",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  ),
                  const Gap(12),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff21222D),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Plan your everyday blocking by time,\n location and more.",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                          EndlessScrollingWidget(
                              gap: 20,
                              widgetWidth: 48,
                              scrollDuration: Duration(seconds: 8),
                              widgetHeight: 48,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.access_time, // app limit
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.home,
                                        size: 48,
                                        color: Colors.red)), // location based

                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.traffic,
                                        size: 48, color: Colors.red)),
                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.snooze,
                                        size: 48, color: Colors.yellow)),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.access_time, // app limit
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.home,
                                        size: 48,
                                        color: Colors.red)), // location based

                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.traffic,
                                        size: 48, color: Colors.red)),
                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(Icons.snooze,
                                        size: 48, color: Colors.yellow)),
                              ])
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//  to demo routing
class MyButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/details'),
            child: const Text('Go to the Details screen'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/basic'),
            child: const Text('Go to the basic screen'),
          ),
        ],
      ),
    );
  }
}
