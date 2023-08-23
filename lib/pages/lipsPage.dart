import 'package:flutter/material.dart';

class LipsPage extends StatefulWidget {
  const LipsPage({Key? key}) : super(key: key);

  @override
  State<LipsPage> createState() => _LipsPageState();
}
class _LipsPageState extends State<LipsPage> {
  final lipsproducts = [
    {
      "product": "Rouge à lèvres"
    },
    {
      "product": "Gloss"
    },
    {
      "product": "Crayon à lèvres"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: lipsproducts.length,
          itemBuilder: (context, index) {
            final lipsProduct = lipsproducts[index];
            final product = lipsProduct['product'];
            return Card(
              child: ListTile(
                title: Text('$product'),
                trailing: const Icon(Icons.open_in_new),
              ),
            );
          }
      ),
    );
  }
}