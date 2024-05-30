import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';
import 'package:checkapp_plugin/checkapp_plugin_method_channel.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_event.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_state.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/checkbox.dart';
import 'package:checkapp_plugin_example/features/create_block/repository/app_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class CreateBlockPage extends StatefulWidget {
  const CreateBlockPage({super.key});
  @override
  State<CreateBlockPage> createState() => _CreateBlockPageState();
}

class _CreateBlockPageState extends State<CreateBlockPage> {
  final blockCubit = BlockCubit();

  void _onChanged(dynamic val) {
    print("_onchanged:$val");
  }

  bool isAppScreen = true;
  bool isSubmitEnabled = false;
  bool _showSearchIcon = true;
  final _formKey = GlobalKey<FormBuilderState>();
  String? _searchApplicationTerm;
  final List<String> _tabs = ["Apps", "Websites", "Keywords"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
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
                  if (_showSearchIcon) const Spacer(),
                  _showSearchIcon
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => {
                            setState(() {
                              _showSearchIcon = false;
                            })
                          },
                          icon: const Icon(Icons.search,
                              color: Colors.blue, size: 24),
                        )
                      : Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.only(top: 12),
                              hintText: "Filter applications",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              setState(() {
                                _searchApplicationTerm = text;
                              });
                            },
                          ),
                        ),
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
                                  AppScreen(),
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
                  backgroundColor: isSubmitEnabled ? Colors.blue : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
                onPressed: isSubmitEnabled
                    ? () {
                        // navigate to the next page
                        print("enabled");
                      }
                    : null,
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

  SingleChildScrollView AppScreen() {
    return SingleChildScrollView(
      child: FormBuilder(
        onChanged: () {
          _formKey.currentState!.save();
          final val = _formKey.currentState!.value;
          debugPrint("------formbuilder onchanged ------");
          debugPrint(
              "FORMbuilder state: ${_formKey.currentState!.value.toString()}");
          blockCubit.updateBlock(
              apps: val['apps'] ?? [],
              websites: val['websites'] ?? [],
              keywords: val['keywords'] ?? []);
          setState(() {
            isSubmitEnabled = val['apps'] != null && val['apps'].isNotEmpty;
          });
          print("cubit state: ${blockCubit.state.apps}");
        },
        autovalidateMode: AutovalidateMode.disabled,
        key: _formKey,
        child: Column(
          children: [
            BlocBuilder<AppsBloc, AppsState>(
              builder: (context, state) {
                if (state is AppsLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is AppsLoaded) {
                  return FormBuilderCheckboxGroup<App>(
                      initialValue: blockCubit.state.apps,
                      orientation: OptionsOrientation.vertical,
                      controlAffinity: ControlAffinity.trailing,
                      autovalidateMode: AutovalidateMode.disabled,
                      name: 'apps',
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      options: _searchApplicationTerm != null
                          ? state.apps
                              .where((app) => app.appName
                                  .toLowerCase()
                                  .contains(
                                      _searchApplicationTerm!.toLowerCase()))
                              .map((app) => FormBuilderFieldOption<App>(
                                    value: app,
                                    child: AppRow(app: app),
                                  ))
                              .toList()
                          : state.apps
                              .map((app) => FormBuilderFieldOption<App>(
                                    value: app,
                                    child: AppRow(app: app),
                                  ))
                              .toList(),
                      onChanged: _onChanged);
                } else {
                  return const Text('No App Found');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
