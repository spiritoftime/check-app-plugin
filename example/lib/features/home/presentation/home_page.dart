import 'package:checkapp_plugin_example/features/home/presentation/widgets/home_screen.dart';
import 'package:checkapp_plugin_example/features/profile/presentation/profile.dart';
import 'package:checkapp_plugin_example/features/presentation/statistics.dart';
import 'package:checkapp_plugin_example/strict/presentation/strict_block_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
final List<Widget> _children = [
      HomeScreen(),
     StrictBlockScreen(),
    const StatisticsScreen(),
    const FAQScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.shield_sharp),
            label: 'Block',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.block),
            label: 'Strict Block ',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

