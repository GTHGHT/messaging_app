import 'package:flutter/material.dart';
import 'package:messaging_app/screens/groups_page.dart';
import 'package:messaging_app/screens/personal_chats_page.dart';
import 'package:messaging_app/screens/settings_page.dart';
import 'package:provider/provider.dart';

import '../services/bottom_nav_bar_provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      PersonalChatsPage(),
      GroupsPage(),
      SettingsPage()
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<BottomNavBarProvider>().currentIndex,
        onTap: (index) =>
            context.read<BottomNavBarProvider>().currentIndex = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: 'Personal Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: _pages.elementAt(context.watch<BottomNavBarProvider>().currentIndex),
    );
  }
}