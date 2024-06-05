import 'package:flutter/material.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:flutter/widgets.dart';

class LocationLimit extends StatefulWidget {
  final Map<String, dynamic> extra;

  const LocationLimit({super.key, required this.extra});

  @override
  State<LocationLimit> createState() => _LocationLimitState();
}

class _LocationLimitState extends State<LocationLimit> {
  final _checkAppPlugin = CheckappPlugin();
  late bool isPermissionEnabled;
  Future<bool> isLocationPermissionEnabled() async {
    isPermissionEnabled =
        await _checkAppPlugin.checkLocationPermission() ?? false;
    return isPermissionEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: isLocationPermissionEnabled(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                // Future hasn't finished yet, return a placeholder
                return Text('Checking location permission...');
              } else {
                return Column(
                  children: [
                    Text(snapshot.hasData
                        ? 'Location permission is enabled'
                        : 'Location permission is not enabled'),
                    ElevatedButton(
                      onPressed: () async {
                        await _checkAppPlugin.requestLocationPermission();
                      },
                      child: Text('Request location permission'),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
