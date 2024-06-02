import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_bloc.dart';
import 'package:checkapp_plugin_example/features/create_block/bloc/app/app_state.dart';
import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppScreen extends StatefulWidget {
  final BlockCubit? blockCubit;
  final String? searchApplicationTerm;

  const AppScreen({
    super.key,
    required this.blockCubit,
    required this.searchApplicationTerm,
  });

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          BlocBuilder<AppsBloc, AppsState>(
            builder: (context, state) {
              if (state is AppsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AppsLoaded) {
                final filteredApps = widget.searchApplicationTerm != null
                    ? state.apps
                        .where((app) => app.appName.toLowerCase().contains(
                            widget.searchApplicationTerm!.toLowerCase()))
                        .toList()
                    : state.apps;
                return CustomCheckboxGroup(
                    name: 'apps',
                    items: filteredApps,
                    content: (app) => AppRow(app: app,key: Key(app.appName) ,),
                    initialValue: widget.blockCubit?.state.apps);
              } else {
                return const Text('No App Found');
              }
            },
          )
        ],
      ),
    );
  }
}
