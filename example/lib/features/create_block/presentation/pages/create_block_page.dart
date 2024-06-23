import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:checkapp_plugin/checkapp_plugin.dart';

import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_screen.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_screen.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/partial_blocking_screen.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/website_screen.dart';
import 'package:checkapp_plugin_example/shared/widgets/show_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class CreateBlockPage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const CreateBlockPage({super.key, required this.extra});
  @override
  State<CreateBlockPage> createState() => _CreateBlockPageState();
}

class _CreateBlockPageState extends State<CreateBlockPage> {

  late BlockCubit blockCubit;
  @override
  void initState() {
    super.initState();
    blockCubit = widget.extra['blockCubit'] ?? BlockCubit();
  }

  bool _isAppScreen = true;

  bool _showSearchIcon = true;
  final _formKey = GlobalKey<FormBuilderState>();

  String? _searchApplicationTerm;
  final List<String> tabs = [
    "Apps",
    "Websites",
    "Keywords",
    "Partial Blocking"
  ];

  void _onScreenChanged(TabController controller) {
    if (!controller.indexIsChanging) {
      if (controller.index == 0) {
        setState(() {
          _isAppScreen = true;
        });
      } else {
        setState(() {
          _isAppScreen = false;
          _searchApplicationTerm = null;
          _showSearchIcon = true;
        });
      }
    }
  }

  void _onSearchApplicationTermChanged(String? text) {
    setState(() {
      _searchApplicationTerm = text;
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
                      length: tabs.length,
                      child: Builder(builder: (BuildContext context) {
                        final TabController controller =
                            DefaultTabController.of(context);
                        controller
                            .addListener(() => _onScreenChanged(controller));
                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ButtonsTabBar(
                                  buttonMargin:
                                      const EdgeInsets.only(right: 16),
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
                                  tabs: tabs
                                      .map((e) => Tab(key: Key(e), text: e))
                                      .toList(),
                                ),
                              ),
                              Expanded(
                                child: FormBuilder(
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
                                      ),
                                      KeywordScreen(
                                        blockCubit: blockCubit,
                                      ),
                                      PartialBlockingScreen(
                                        blockCubit: blockCubit,
                                      )
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
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                ),
                onPressed: () async {
                  if (blockCubit.state.apps.isEmpty &&
                      blockCubit.state.keywords.isEmpty &&
                      blockCubit.state.websites.isEmpty &&
                      blockCubit.state.partialBlockers.isEmpty) {
                    createAlertDialog(context, const Text("No item selected"),
                        const Text("Please select at least one item to block"));
                    return;
                  }
                 

                  if (widget.extra.containsKey('blockCubit') &&
                      context.mounted) {
                    context.goNamed('confirm-schedule',
                        extra: {...widget.extra, 'blockCubit': blockCubit});
                  } else if (context.mounted) {
                    context.goNamed('create-blocking-conditions',
                        extra: {...widget.extra, 'blockCubit': blockCubit});
                  }
                },
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
