import 'package:flutter/material.dart';

const Map<String, IconData> icons = {
  'schedule': Icons.schedule,
  'work': Icons.work,
  'school': Icons.school,
  'home': Icons.home,
  'family': Icons.family_restroom,
  'sports': Icons.sports,
  'music': Icons.music_note,
  'movie': Icons.movie,
  'game': Icons.sports_esports,
  'food': Icons.fastfood,
  'shopping': Icons.shopping_cart,
  'travel': Icons.airplanemode_active,
  'party': Icons.celebration,
  'sleep': Icons.nights_stay,
  'relax': Icons.spa,
  'gym': Icons.fitness_center,
  'study': Icons.menu_book,
  'reading': Icons.library_books,
  'coding': Icons.code,
};

class IconSelection extends StatefulWidget {
  final String currentIcon;
  final Function(String) setIcon;
  const IconSelection(
      {super.key, required this.setIcon, required this.currentIcon});

  @override
  State<IconSelection> createState() => _IconSelectionState();
}

class _IconSelectionState extends State<IconSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: 300,
        height: 250,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            String iconName = icons.keys.elementAt(index);
            IconData iconData = icons[iconName]!;
            return IconButton(
              onPressed: () {
                widget.setIcon(iconName);
              },
              icon: Icon(iconData,
                  size: 32,
                  color: iconName == widget.currentIcon
                      ? Colors.blue
                      : Colors.white),
            );
          },
        ),
      ),
    );
  }
}
