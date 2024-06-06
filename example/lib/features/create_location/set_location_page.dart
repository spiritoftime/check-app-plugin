// import 'package:flutter/material.dart';
// import 'package:geocoder_buddy/geocoder_buddy.dart';

// class SetLocationPage extends StatefulWidget {
//   final Map<String, dynamic> extra;

//   const SetLocationPage({super.key, required this.extra});

//   @override
//   State<SetLocationPage> createState() => _SetLocationPageState();
// }

// class _SetLocationPageState extends State<SetLocationPage> {
//   final searchTextController = TextEditingController();

//   List<GBSearchData> searchItem = [];
//   Map<String, dynamic> details = {};
//   bool isSearching = false;
//   bool isLoading = false;

//   void searchLocation(String query) async {
//     setState(() {
//       isSearching = true;
//     });
//     List<GBSearchData> data = await GeocoderBuddy.query(query);
//     setState(() {
//       isSearching = false;
//       searchItem = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Choose your Location"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               "Search Location",
//             ),
//             Container(
//               padding: const EdgeInsets.all(20),
//               child: TextField(
//                 controller: searchTextController,
//                 decoration: const InputDecoration(
//                     hintText: "Search Location", border: OutlineInputBorder()),
//               ),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   if (searchTextController.text.isNotEmpty) {
//                     searchLocation(searchTextController.text);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please Enter Location")));
//                   }
//                 },
//                 child: Text("Search")),
//             SizedBox(
//               height: 300,
//               child: !isSearching
//                   ? ListView.builder(
//                       itemCount: searchItem.length,
//                       itemBuilder: (context, index) {
//                         var item = searchItem[index];
//                         return ListTile(
//                           onTap: () {
//                             print(item);
//                           },
//                           title: Text(item.displayName),
//                         );
//                       })
//                   : const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
