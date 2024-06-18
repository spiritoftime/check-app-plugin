import 'dart:async';

import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:checkapp_plugin_example/features/create_wifi/cubit/cubit/wifi_cubit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:checkapp_plugin_example/features/create_wifi/widgets/wifi_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class WifiLimit extends StatefulWidget {
  final Map<String, dynamic> extra;

  const WifiLimit({super.key, required this.extra});

  @override
  State<WifiLimit> createState() => _WifiLimitState();
}

class _WifiLimitState extends State<WifiLimit> {
  final CheckappPlugin _checkappPlugin = CheckappPlugin();
  late WifiCubit wifiCubit;
  final _formKey = GlobalKey<FormBuilderState>();
  late StreamController<List<Wifi>> _wifiStreamController;
  Timer? _wifiTimer;

  @override
  void initState() {
    super.initState();
    wifiCubit = widget.extra['wifiCubit'] ?? WifiCubit();
    _wifiStreamController = StreamController<List<Wifi>>();
    _startWifiStream();
  }

  void _startWifiStream() {
    _wifiTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        List<Map<String, dynamic>> rawWifiList =
            await _checkappPlugin.getNearbyWifi();
        List<Wifi> wifiList = rawWifiList.map((e) => Wifi.fromJson(e)).toList();
        _wifiStreamController.add(wifiList);
      } catch (error) {
        _wifiStreamController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _wifiTimer?.cancel();
    _wifiStreamController.close();
    super.dispose();
  }

  void _onWifiCheckBoxChanged(selectedValues) {
    wifiCubit.updateWifi(wifi: selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Wifi List'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder<List<Wifi>>(
                  stream: _wifiStreamController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Wifi>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.hasData) {
                      List<Wifi> wifiList = snapshot.data!;
                      return FormBuilder(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: SingleChildScrollView(
                          child: CustomCheckboxGroup(
                            onChanged: _onWifiCheckBoxChanged,
                            name: 'wifi',
                            items: wifiList,
                            content: (wifi) => WifiRow(
                              wifi: wifi,
                              key: Key(wifi.wifiName),
                            ),
                            initialValue: wifiCubit.state.map((w)=>Wifi(wifiName: w.wifiName)).toList(),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text('No Wi-Fi networks found'));
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                  ),
                  child: const Text('Save Wifi List',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    context.goNamed('confirm-schedule',
                        extra: {...widget.extra, 'wifiCubit': wifiCubit});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
