import 'package:flutter/material.dart';
import 'package:messaging_app/screens/groups_page.dart';
import 'package:messaging_app/screens/personal_chats_page.dart';
import 'package:messaging_app/screens/settings_page.dart';
import 'package:provider/provider.dart';

import '../services/bottom_nav_bar_provider.dart';

class MainScreen extends StatelessWidget {
  Widget? buildFloatingActionButton(BuildContext context, int index) {
    if (index == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/create_pc');
        },
        child: Icon(Icons.chat),
      );
    } else if (index == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/create_group');
        },
        child: Icon(Icons.group),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      PersonalChatsPage(),
      GroupsPage(),
      SettingsPage()
    ];

    return Scaffold(
      floatingActionButton: buildFloatingActionButton(
        context,
        context.watch<BottomNavBarProvider>().currentIndex,
      ),
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
      body:
          _pages.elementAt(context.watch<BottomNavBarProvider>().currentIndex),
    );
  }
}