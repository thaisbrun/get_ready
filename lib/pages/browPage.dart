import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowPage extends StatefulWidget {
  const BrowPage({Key? key}) : super(key: key);

  @override
  State<BrowPage> createState() => _BrowPageState();
}

class _BrowPageState extends State<BrowPage> {
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(product.libelle),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        // child: Text(product.description),
      ),
    );
  }
}
