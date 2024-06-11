import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/custom_checkbox_group.dart';
import 'package:checkapp_plugin_example/features/create_block/presentation/widgets/keyword_row.dart';
import 'package:checkapp_plugin_example/features/create_location/cubit/location_cubit.dart';
import 'package:checkapp_plugin_example/features/create_location/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:go_router/go_router.dart';

class SetLocationPage extends StatefulWidget {
  final Map<String, dynamic> extra;

  const SetLocationPage({super.key, required this.extra});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  final searchTextController = TextEditingController();
  late LocationCubit locationCubit;
  List<GBSearchData> searchItem = [];
  Map<String, dynamic> details = {};
  bool isSearching = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    locationCubit = widget.extra['locationCubit'] ?? LocationCubit();
  }

  void searchLocation(String query) async {
    setState(() {
      isSearching = true;
    });
    List<GBSearchData> data = await GeocoderBuddy.query(query);
    setState(() {
      isSearching = false;
      searchItem = data;
    });
  }

  final _formKey = GlobalKey<FormBuilderState>();

  void _onLocationCheckBoxChanged() {
    _formKey.currentState!.save();
    final val = _formKey.currentState!.value;
    locationCubit.updateLocation(location: val['location']);
    print("checkboxChanged:${val['location']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose your Location"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Search Location",
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: searchTextController,
                      decoration: const InputDecoration(
                          hintText: "Search Location",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (searchTextController.text.isNotEmpty) {
                        searchLocation(searchTextController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please Enter Location")));
                      }
                    },
                    child: const Text("Search"),
                  ),
                  SizedBox(
                    height: 300,
                    child: !isSearching
                        ? FormBuilder(
                            key: _formKey,
                            onChanged: _onLocationCheckBoxChanged,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: CustomCheckboxGroup(
                              name: 'location',
                              items: searchItem,
                              content: (item) => KeywordRow(
                                keyword: item.displayName,
                                key: Key(item.displayName),
                              ),
                              initialValue: locationCubit.state,
                            ),
                          )
                        // ListView.builder(
                        //     itemCount: searchItem.length,
                        //     itemBuilder: (context, index) {
                        //       var item = searchItem[index];
                        //       return ListTile(
                        //         onTap: () {
                        //           Location location = Location(
                        //               latitude: double.parse(item.lat),
                        //               longitude: double.parse(item.lon),
                        //               location: item.displayName);
                        //           locationCubit.updateLocation(location: location);
                        //           context.goNamed('confirm-schedule',
                        //               extra: {
                        //                 ...widget.extra,
                        //                 'locationCubit': locationCubit
                        //               });
                        //         },
                        //         title: Text(item.displayName),
                        //       );
                        //     })
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 64),
              backgroundColor: Colors.blue,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            ),
            child: const Text('Save Location List',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              context.goNamed('confirm-schedule',
                  extra: {...widget.extra, 'locationCubit': locationCubit});
            },
          ),
        ],
      ),
    );
  }
}
