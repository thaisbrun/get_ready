import 'package:flutter/material.dart';
import 'package:get_ready/pages/addProductPage.dart';
import 'package:get_ready/pages/homePage.dart';
import 'package:get_ready/pages/connexion.dart';
import 'package:get_ready/pages/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//Cette fonction permet de démarrer mon application

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
//Permet de mettre une page static (readonly)
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  void _setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:const Text("Get Ready"),
            centerTitle: true,
          backgroundColor: Colors.pink,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu Icon',
            onPressed: () {},
          ),
        ),
        body: [
          const HomePage(),
          const RegisterPage(),
          const AddProductPage(),
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _setCurrentIndex,
          selectedItemColor: Colors.pink,
          elevation:10,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Mon panier',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Mon compte',
            ),
          ],
        ),
      ),
    );
  }
}



