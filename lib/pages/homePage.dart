import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

    @override
    Widget build(BuildContext context) {

      //SearchBar(),
      //bar avec liste catégorie
      //affichage liste produits
      return Scaffold(
        body:Center(
            child:Column(
              children: [
                Image.asset("assets/images/homeImg.jpg"),
                SearchBar(),
                TextField(
                    decoration: InputDecoration(
                    labelText: 'Liste des catégories',
                    hintText: 'Choisir une catégorie :',
                    border:OutlineInputBorder()
                )),
                Flexible(
                child:StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Produits").orderBy("libelle").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return Text("Aucun produit");
                    }

                    List<dynamic> products = [];
                    snapshot.data!.docs.forEach((element) {
                      products.add(element);
                    });

                    return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final libelle = product['libelle'];
                          final mesure = product['mesure'];
                          final description = product['description'];
                          final conseilUtil = product['conseilUtil'];
                          final prix = product['prix'];

                          return Card(
                            child: ListTile(
                              dense: true,
                              visualDensity: VisualDensity(vertical: 1),                              title: Text('$libelle'),
                              textColor: Colors.pink,
                              trailing: Icon(Icons.open_in_new),
                            ),
                          );
                        },
                    );
                  },
                  ),
                ),
              ],
            ),
      ),
      );
    }
  }
