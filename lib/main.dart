import 'package:flutter/material.dart';
import 'package:get_ready/pages/addProductPage.dart';
import 'package:get_ready/pages/homePage.dart';
import 'package:get_ready/pages/lipsPage.dart';
//Cette fonction permet de démarrer mon application
void main() {
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
          title:[
            Text("Get Ready"),
            Text("Nos produits lèvres"),
            Text("Ajouter un produit"),
          ][_currentIndex],
        ),
        body: [
          HomePage(),
          LipsPage(),
          AddProductPage() //A changer
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



