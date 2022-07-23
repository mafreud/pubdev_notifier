import 'package:flutter/material.dart';
import 'package:pubdev_notifier/app/top/top_page.dart';

import '../timeline/timeline_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.update),
            label: 'UPDATE',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'TIMELINE',
          ),
        ],
      ),
      body: <Widget>[
        const TopPage(),
        const TimelinePage(),
      ][currentPageIndex],
    );
  }
}
