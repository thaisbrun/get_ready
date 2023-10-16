import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/EyesPage.dart';
import 'package:get_ready/pages/browPage.dart';
import 'package:get_ready/pages/connexion.dart';
import 'package:get_ready/pages/homePage.dart';
import 'package:get_ready/pages/lipsPage.dart';
import 'package:get_ready/pages/myAccount.dart';
import 'package:get_ready/pages/nailsPage.dart';
import 'package:get_ready/pages/skinPage.dart';

import 'firebase_options.dart';

//Cette fonction permet de démarrer mon application

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Get Ready';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text('Get Ready'),
            ),
            ListTile(
              title: const Text('Produits teint'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SkinPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Produits yeux'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EyesPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Produits lèvres'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LipsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Produits sourcils'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrowPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Produits ongles'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NailsPage()),
                );
              },
            ),

      /*   A METTRE DANS UN FOOTER
         ListTile(
              title: const Text('Mon compte'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyAccount()),
              );
              },
            ),
            ListTile(
              title: const Text('Connexion'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Connexion()),
                );
              },
            ),
            ListTile(
              title: const Text('Accueil'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}



