import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String selectedCategorie = '0';
  void dispose() {
    super.dispose();
  }
    @override
    Widget build(BuildContext context) {

      //SearchBar(),
      //bar avec liste catégorie
      //affichage liste produits
      return Scaffold(
        body:Column(
          children: [
            Image.asset("assets/images/homeImg.jpg"),
            Container(
              child: const Row(
                children: [
              Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Saisir un mot clé :'),
              ),
              ),
              Expanded(
                child:Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SearchBar(
                    constraints: BoxConstraints(minWidth: 0.0, maxWidth: 300.0, minHeight: 50.0)
              ),
                ),
              ),
                ],
              ),
            ),
        /*     Container(
               child: Row(
                  children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Choisir une catégorie :'),
                    ),
                  ),
                    Flexible(
                    child:Expanded(
                      child:Padding(
                        padding: EdgeInsets.all(10.0),
                        child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Categories").orderBy("libelle").snapshots(),
                        builder: (context, snapshot) {
                        List<DropdownMenuItem> listeCategories = [];
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.hasData) {
                          return const Text("Aucune catégorie");
                        }
                        final categories = snapshot.data?.docs.reversed.toList();
                        listeCategories.add(const DropdownMenuItem(
                        value:'0',
                          child: Text('Sélectionner catégorie'),
                        ));
                        for(var categorie in categories!){
                          listeCategories.add(DropdownMenuItem(
                          value: categorie.id,
                          child: Text(categorie['libelle'],
                          ),
                          ),
                        );
                        }

                        return DropdownButtonFormField(
                        items: listeCategories,
                          value:selectedCategorie,
                          onChanged: (value){
                          setState(() {
                            selectedCategorie = value!;
                        });
                          },
                          isExpanded: false,
                        );
                        }),
                    ),
                ),
            ),
          ],
      ),
             ), */
            Container(
              child: Flexible(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Produits").orderBy("libelle").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return const Text("Aucun produit");
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
                              visualDensity: const VisualDensity(vertical: 1),                              title: Text('$libelle'),
                              textColor: Colors.pink,
                              trailing: const Icon(Icons.open_in_new),
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
