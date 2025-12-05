//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_flutter/views/edit_profile_screen.dart';
import 'package:firebase_flutter/views/home_page.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final String email;
  const MainLayout({super.key, required this.email});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final _screens = [
     MainPage(),
    UserSettingsPage(userId: '132',name: "Jess",),
    // StudyPlanDetailsPage(plan: ,)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 218, 218, 218),
            ],
          ),
        ),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        backgroundColor: Colors.blueGrey,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        // backgroundColor: Colors.transparent,
        selectedItemColor: Colors.amber[600],
        // unselectedItemColor: Colors.white60,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}