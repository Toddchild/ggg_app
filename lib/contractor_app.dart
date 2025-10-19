import 'package:flutter/material.dart';
import 'screens/contractor/dashboard_screen.dart';
import 'screens/contractor/routes_screen.dart';
import 'screens/contractor/earnings_screen.dart';

// --- Main Contractor App with Navigation ---

class ContractorApp extends StatefulWidget {
  const ContractorApp({super.key});

  @override
  State<ContractorApp> createState() => _ContractorAppState();
}

class _ContractorAppState extends State<ContractorApp> {
  // Keeps track of the currently selected tab index.
  int _selectedIndex = 0;

  // List of screens corresponding to the navigation bar items.
  final List<Widget> _screens = [
    const DashboardScreen(),
    const RoutesScreen(),
    const EarningsScreen(),
  ];

  // Function to handle tab taps.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garbage Grabber Pro'),
        backgroundColor: Colors.blue.shade700, // Contractor color theme
        foregroundColor: Colors.white,
      ),
      // The body displays the selected screen.
      body: _screens[_selectedIndex],

      // The Bottom Navigation Bar for contractors.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
