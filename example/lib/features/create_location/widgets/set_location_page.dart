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
  List<Location> searchItem = [];
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
    List<Location> locationData = data
        .map((e) => Location(
            latitude: double.parse(e.lat),
            longitude: double.parse(e.lon),
            location: e.displayName))
        .toList();
    setState(() {
      isSearching = false;
      searchItem = locationData;
    });
  }

  final _formKey = GlobalKey<FormBuilderState>();

  void _onLocationCheckBoxChanged(selectedItems) {

    locationCubit.updateLocation(
        location:selectedItems);
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
                  !isSearching
                      ? FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: CustomCheckboxGroup(
                            onChanged: _onLocationCheckBoxChanged,
                            name: 'location',
                            items: searchItem,
                            content: (item) => KeywordRow(
                              keyword: item.location,
                              key: Key(item.location),
                            ),
                            initialValue: locationCubit.state,
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 64),
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
              ),
              child: const Text('Save Location List',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                context.goNamed('confirm-schedule',
                    extra: {...widget.extra, 'locationCubit': locationCubit});
              },
            ),
          ),
        ],
      ),
    );
  }
}
