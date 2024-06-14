import 'package:flutter/material.dart';
import 'package:smart_terrarium/pages/auto.dart';
import 'package:smart_terrarium/pages/camera.dart';
import 'package:smart_terrarium/pages/info.dart';
import 'package:smart_terrarium/pages/manual.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset(
            'assets/logo.png',
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "Smart Terrarium",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              },
              icon: const Icon(Icons.info_outline))
        ]),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.autorenew),
            label: 'Auto Mode',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Manual Mode',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Camera',
          ),
        ],
      ),
      body: <Widget>[
        const AutoPage(),
        const ManualPage(),
        const CameraPage()
      ][currentPageIndex],
    );
  }
}
