import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Get Ready"),
        ),
          body: const Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        "Application de vente de cosmétiques",
            style: TextStyle(
                    fontSize: 24,
    ),
          ),
                  Text("Rouge à lèvres, fard à paupières, fond de teint, blush...",
                    style: TextStyle(
                    fontSize: 24,
                      fontFamily: 'Avenir',
                  ),
          )
                ],
              )
        )
      ),
    );
  }
}

