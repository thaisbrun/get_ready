import 'package:flutter/material.dart';

class LipsPage extends StatelessWidget {
  const LipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Produits lèvres"),
      ),
      body: Center(
        child:Text("Prochainement disponible"),
      ),
    );
  }
}
