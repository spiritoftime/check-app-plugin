import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:checkapp_plugin_example/features/create_wifi/cubit/cubit/wifi_cubit.dart';
import 'package:checkapp_plugin_example/features/create_wifi/models/wifi.dart';
import 'package:checkapp_plugin_example/features/create_wifi/widgets/keyword_row.dart';
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
  @override
  void initState() {
    super.initState();
    wifiCubit = widget.extra['wifiCubit'] ?? WifiCubit();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  _onWifiCheckBoxChanged() {
    _formKey.currentState!.save();
    final val = _formKey.currentState!.value;
    wifiCubit.updateWifi(wifi: val['wifi']);
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
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _checkappPlugin.getNearbyWifi(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          List<Wifi> wifiList = snapshot.data!
                              .map((e) => Wifi.fromJson(e))
                              .toList();
                              print(wifiList);
                          // return Text("Hi");
                          return FormBuilder(
                            key: _formKey,
                            onChanged: _onWifiCheckBoxChanged,
                            autovalidateMode: AutovalidateMode.disabled,
                            // child:Text("HI")
                            child: Expanded(
                              child: SingleChildScrollView(
                                child: CustomCheckboxGroup(
                                    name: 'wifi',
                                    items: wifiList,
                                    content: (wifi) => WifiRow(
                                          wifi: wifi,
                                          key: Key(wifi.wifiName),
                                        ),
                                    initialValue: wifiCubit.state),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                  ),
                  child: const Text('Save Wifi List',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    context.goNamed('confirm-schedule',
                        extra: {...widget.extra, 'wifiCubit': wifiCubit});
                  })
            ],
          ),
        ),
      ),
    );
  }
}
