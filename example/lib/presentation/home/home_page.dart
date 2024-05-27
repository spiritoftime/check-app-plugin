import 'package:checkapp_plugin_example/presentation/home/home_screen.dart';
import 'package:checkapp_plugin_example/presentation/profile/profile.dart';
import 'package:checkapp_plugin_example/presentation/statistics/statistics.dart';
import 'package:checkapp_plugin_example/presentation/strict/strict_block_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
final List<Widget> _children = [
     HomeScreen(),
    const StrictBlockScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
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

