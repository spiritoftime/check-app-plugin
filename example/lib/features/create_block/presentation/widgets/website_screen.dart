import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/website/website.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/website_row.dart';
import 'package:flutter/material.dart';

class WebsiteScreen extends StatefulWidget {
  final BlockCubit blockCubit;
  final Function(bool isDisabled) onAddCheckBoxDisabledChanged;
  const WebsiteScreen({
    super.key,
    required this.blockCubit,
    required this.onAddCheckBoxDisabledChanged,
  });

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Website> websites = widget.blockCubit.state.websites;
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          TextField(
            controller: myController,
            onSubmitted: (String value) {
              if (value.isNotEmpty &&
                  value.contains('.com') &&
                  value.split('.')[1] == 'com') {
                Website newWebsite = Website(url: value);
                List<Website> existingWebsites =
                    widget.blockCubit.state.websites;
                List<Website> newWebsites = [...existingWebsites, newWebsite];
                // update cubit
                widget.blockCubit.updateBlock(websites: newWebsites);
                setState(() {
                  websites = newWebsites;
                });
                myController.clear();
              }
            },
            decoration: const InputDecoration(
              hintText: 'Add Website',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.only(left: 8, top: 12),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          CustomCheckboxGroup(
              name: 'websites',
              items: websites,
              content: (website) => WebsiteRow(website: website),
              initialValue: widget.blockCubit.state.websites)
        ],
      ),
    );
  }
}
