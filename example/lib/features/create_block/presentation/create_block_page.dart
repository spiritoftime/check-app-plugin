
import 'package:buttons_tabbar/buttons_tabbar.dart';

import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_screen.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_screen.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/website_screen.dart';
import 'package:flutter/material.dart';

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
  bool _isAppScreen = true;
  bool isSubmitEnabled = false;
  bool isAddCheckboxDisabled =
      false; // disable add button for website, if the user typed something in website, but did not type in a valid website.
  bool _showSearchIcon = true;
  final _formKey = GlobalKey<FormBuilderState>();

  String? _searchApplicationTerm;
  final List<String> _tabs = ["Apps", "Websites", "Keywords"];

  void _onScreenChanged(TabController controller) {
    if (!controller.indexIsChanging) {
      if (controller.index == 0) {
        setState(() {
          _isAppScreen = true;
        });
      } 
       else {
        setState(() {
          _isAppScreen = false;
          _searchApplicationTerm = null;
          _showSearchIcon = true;
        });
      }
    }
  }

  void _onAddCheckBoxDisabledChanged(bool isDisabled) {
    setState(() {
      isAddCheckboxDisabled = isDisabled;
    });
  }

  void _onSearchApplicationTermChanged(String? text) {
    setState(() {
      _searchApplicationTerm = text;
    });
  }

  void _onBlockScreenCheckboxChanged() {
    _formKey.currentState!.save();
    final val = _formKey.currentState!.value;
    debugPrint("------formbuilder onchanged ------");
    debugPrint("FORMbuilder state: ${_formKey.currentState!.value.toString()}");
    blockCubit.updateBlock(
        apps: val['apps'] ?? [],
        websites: val['websites'] ?? [],
        keywords: val['keywords'] ?? []);
    setState(() {
      isSubmitEnabled = val['apps'] != null && val['apps'].isNotEmpty ||
          val['websites'] != null && val['websites'].isNotEmpty ||
          val['keywords'] != null && val['keywords'].isNotEmpty;
    });
  }

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
                        color: Colors.blue, size: 36),
                  ),
                  if (_showSearchIcon && _isAppScreen) const Spacer(),
                  _showSearchIcon && _isAppScreen
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
                              color: Colors.blue, size: 36),
                        )
                      : _isAppScreen && !_showSearchIcon
                          ? Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  contentPadding: EdgeInsets.only(top: 12),
                                  hintText: "Filter applications",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: Icon(Icons.search,
                                      color: Colors.grey, size: 24),
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) =>
                                    _onSearchApplicationTermChanged(text),
                              ),
                            )
                          : Container()
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
                    const Gap(16),
                    DefaultTabController(
                      length: _tabs.length,
                      child: Builder(builder: (BuildContext context) {
                        final TabController controller =
                            DefaultTabController.of(context);
                        controller
                            .addListener(() => _onScreenChanged(controller));
                        return Expanded(
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
                                radius: 20,
                                tabs: _tabs.map((e) => Tab(text: e)).toList(),
                              ),
                              Expanded(
                                child: FormBuilder(
                                  onChanged: _onBlockScreenCheckboxChanged,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  key: _formKey,
                                  child: TabBarView(
                                    children: [
                                      AppScreen(
                                          blockCubit: blockCubit,
                                          searchApplicationTerm:
                                              _searchApplicationTerm),
                                      WebsiteScreen(
                                        blockCubit: blockCubit,
                                        onAddCheckBoxDisabledChanged:
                                            _onAddCheckBoxDisabledChanged,
                                      ),
                                      KeywordScreen(
                                          blockCubit: blockCubit,
                                          onAddCheckBoxDisabledChanged:
                                              _onAddCheckBoxDisabledChanged)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
                      print("Apps: ${blockCubit.state.apps.toString()}");
                      print("Websites: ${blockCubit.state.websites.toString()}");
                      print("Keywords: ${blockCubit.state.keywords.toString()}");
                      context.goNamed('create-blocking-conditions');
                      }
                    : null, // null disables the button
                child: const Text(
                  "Save Blocklist",
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
