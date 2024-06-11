import 'package:checkapp_plugin_example/features/create_block/cubit/cubit/block_cubit.dart';
import 'package:checkapp_plugin_example/features/create_block/models/keyword/keyword.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_row.dart';
import 'package:flutter/material.dart';

class KeywordScreen extends StatefulWidget {
  final BlockCubit blockCubit;
  const KeywordScreen({
    super.key,
    required this.blockCubit,
  });

  @override
  State<KeywordScreen> createState() => _KeywordScreenState();
}

class _KeywordScreenState extends State<KeywordScreen> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Keyword> keywords = widget.blockCubit.state.keywords;
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          TextField(
            controller: myController,
            onSubmitted: (String value) {
              Keyword newKeyword = Keyword(keyword: value);
              List<Keyword> existingKeywords =
                  widget.blockCubit.state.keywords;
              List<Keyword> newKeywords = [...existingKeywords, newKeyword];
              // update cubit
              widget.blockCubit.updateBlock(keywords: newKeywords);
              setState(() {
                keywords = newKeywords;
              });
              myController.clear();
            },
            decoration: const InputDecoration(
              hintText: 'Add Keyword',
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
              name: 'keywords',
              items: keywords,
              content: (keyword) => KeywordRow(keyword: keyword.keyword),
              initialValue: widget.blockCubit.state.keywords)
        ],
      ),
    );
  }
}
