import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'getProduct.dart';

class EyesPage extends StatefulWidget {
  const EyesPage({super.key});

  @override
  State<EyesPage> createState() => _EyesPageState();
}

class _EyesPageState extends State<EyesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child:Flexible(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("SousCategories").where("idCategorie", isEqualTo: FirebaseFirestore.instance.doc('Categories/IJNzsCvZlQiYLgWsOT8k')).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return const Text("Aucun produit");
                    }

                    List<dynamic> sousCategories = [];
                    snapshot.data!.docs.forEach((element) {
                      sousCategories.add(element);
                    });

                    return ListView.builder(
                      itemCount: sousCategories.length,
                      itemBuilder: (context, index) {
                        final sousCategorie = sousCategories[index];
                        final libelle = sousCategorie['libelle'];

                        return Card(
                          child: ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: 1),
                            title: Text('$libelle'),
                            textColor: Colors.red[200]!,
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GetProduct(),
                                  // Pass the arguments as part of the RouteSettings. The
                                  // DetailScreen reads the arguments from these settings.
                                  settings: RouteSettings(
                                    arguments: sousCategorie[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
