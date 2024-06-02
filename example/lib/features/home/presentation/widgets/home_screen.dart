import 'package:checkapp_plugin_example/features/home/presentation/widgets/accordion.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/carousel_icons.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/schedule_template_carousel.dart';
import 'package:checkapp_plugin_example/features/home/presentation/widgets/endless_scrolling_widget.dart';
import 'package:checkapp_plugin_example/shared/widgets/grey_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

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
                        padding: const EdgeInsets.all(0),
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
                              onPressed: () {
                                context.go('/create-block');
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32.0),
                          child: Column(
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
                                  scrollDuration: const Duration(seconds: 8),
                                  widgetHeight: 48,
                                  children: carouselIcons)
                            ],
                          ),
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
