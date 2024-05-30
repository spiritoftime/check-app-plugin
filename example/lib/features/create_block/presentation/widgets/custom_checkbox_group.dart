import 'package:checkapp_plugin_example/features/create_block/models/app/app.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/app_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomCheckboxGroup extends StatefulWidget {
  final List<App> apps;
  final List<App>? initialValue;
  final Function(List<App>?)? onChanged;
  final String name;
  final String? searchApplicationTerm;

  const CustomCheckboxGroup({
    super.key,
    required this.apps,
    this.initialValue,
    this.onChanged,
    required this.name,
    this.searchApplicationTerm,
  });

  @override
  State<CustomCheckboxGroup> createState() => _CustomCheckboxGroupState();
}

class _CustomCheckboxGroupState extends State<CustomCheckboxGroup> {
  List<App> selectedValues = [];

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialValue ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = widget.searchApplicationTerm != null
        ? widget.apps
            .where((app) => app.appName
                .toLowerCase()
                .contains(widget.searchApplicationTerm!.toLowerCase()))
            .toList()
        : widget.apps;

    return FormBuilderField<List<App>>(
      name: widget.name,
      initialValue: selectedValues,autovalidateMode: AutovalidateMode.disabled,
      builder: (FormFieldState<List<App>> field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            errorText: field.errorText,
          ),
          child: filteredApps.isNotEmpty
              ? ListView.builder(
                  prototypeItem: CheckboxListTile(
                    value: true,
                    contentPadding: EdgeInsets.zero,
                    title: AppRow(app: filteredApps.first),
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedValues.add(filteredApps.first);
                        } else {
                          selectedValues.remove(filteredApps.first);
                        }
                        field.didChange(selectedValues);
                        if (widget.onChanged != null) {
                          widget.onChanged!(selectedValues);
                        }
                      });
                    },
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // Important to avoid unbounded height error
                  itemCount: filteredApps.length,
                  itemBuilder: (context, index) {
                    final app = filteredApps[index];
                    final isSelected = selectedValues.contains(app);

                    return CheckboxListTile(
                      value: isSelected,
                      contentPadding: EdgeInsets.zero,
                      title: AppRow(app: app),
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
                        });
                      },
                    );
                  },
                )
              : const Center(child: Text('No apps found')),
        );
      },
    );
  }
}
