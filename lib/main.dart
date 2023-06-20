import 'package:flutter/material.dart';
import 'package:get_ready/pages/homePage.dart';
//Cette fonction permet de démarrer mon application
void main() {
  runApp(const MyApp());
}
//Permet de mettre une page static (readonly)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}


