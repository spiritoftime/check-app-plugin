import 'package:checkapp_plugin_example/features/create_block/presentation/utils.dart';
import 'package:checkapp_plugin_example/shared/widgets/accordion_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlockPermissionsPage extends StatelessWidget {
  const BlockPermissionsPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.blue, size: 24),
                      ),
                      const Gap(16),
                      const Center(
                          child: Icon(Icons.settings,
                              size: 200, color: Colors.yellow)),
                      const Gap(16),
                      const Text(
                        "Permission Missing",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                      ),
                      const Gap(16),
                      const Text(
                        'Location permission required',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                      const Gap(16),
                      const Text(
                        "Please follow these instructions:",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      const Gap(8),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: instructionList.map((i) => i).toList(),
                      ),
                      const AccordionWrapper(
                        header: Row(
                          children: [
                            Icon(Icons.quiz, color: Colors.blue, size: 24),
                            Gap(16),
                            Text("Why do i need to do so?")
                          ],
                        ),
                        content: Column(
                          children: [
                            Text(
                                "We need your location at all times so that we can block your app usage based on your location.")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 64),
                ),
                onPressed: () async {
                  // await _checkAppPlugin.requestLocationPermission();
                },
                child: const Text('Enable location permission'),
              )
            ],
          ),
        ),
      ),
    );
}
}