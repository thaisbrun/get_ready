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
      home: HomePage(),
    );
  }
}

class LipsPage extends StatelessWidget {
  const LipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Produits lèvres"),
    ),
      body: Center(
        child:Text("Prochainement disponible")
      )
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Ready"),
      ),
        body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/imageTest.jpg"),
                const Text(
                      "Application de vente de cosmétiques",
          style: TextStyle(
                  fontSize: 24,
    ),
        ),
                const Text("Rouge à lèvres, fard à paupières, fond de teint, blush...",
                  style: TextStyle(
                  fontSize: 24,
                    fontFamily: 'Avenir',
                ),
        ),
                ElevatedButton(onPressed: () => print("click button"),
                    child: Text("Page lèvres"))
              ],
            ),
      ),
    );
  }
}

