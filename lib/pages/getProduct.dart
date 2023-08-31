import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';

class GetProduct extends StatefulWidget {
  const GetProduct({Key? key}) : super(key: key);

  @override
  State<GetProduct> createState() => _GetProductState();

}

class _GetProductState extends State<GetProduct> {

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        //title: Text(product.libelle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
       // child: Text(product.description),
      ),
    );
  }
  }
