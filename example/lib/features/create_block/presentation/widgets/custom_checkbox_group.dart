import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef ContentBuilder = Widget Function(dynamic app);

class CustomCheckboxGroup extends StatefulWidget {
  final List<dynamic> items;
  final List<dynamic>?
      initialValue; // needed to preserve checked when switching tabs
  final Function(List<dynamic>?)? onChanged;
  final String name;
  final ContentBuilder content;

  const CustomCheckboxGroup({
    super.key,
    required this.items,
    this.initialValue,
    this.onChanged,
    required this.name,
    required this.content,
  });

  @override
  State<CustomCheckboxGroup> createState() => _CustomCheckboxGroupState();
}

class _CustomCheckboxGroupState extends State<CustomCheckboxGroup> {
  List<dynamic> selectedValues = [];

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialValue ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<dynamic>>(
      name: widget.name,
      initialValue: selectedValues,
      autovalidateMode: AutovalidateMode.disabled,
      builder: (FormFieldState<List<dynamic>> field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            errorText: field.errorText,
          ),
          child: widget.items.isNotEmpty
              ? ListView.builder(
                  prototypeItem: CheckboxListTile(
                    title: widget.content(widget.items.first),
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // Important to avoid unbounded height error
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final app = widget.items[index];
                    final isSelected = selectedValues.contains(app);

                    return CheckboxListTile(
                      value: isSelected,
                      fillColor: WidgetStateProperty.all(Colors.black),
                      checkColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      title: widget.content(app),
                      controlAffinity: ListTileControlAffinity.trailing,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            selectedValues.add(app);
                          } else {
                            selectedValues.remove(app);
                          }
                          field.didChange(selectedValues);
                          if (widget.onChanged != null) {
                            widget.onChanged!(selectedValues);
                          }
                        },);
                      },
                    );
                  },
                )
              : const Center(child: Text('No items found')),
        );
      },
    );
  }
}
