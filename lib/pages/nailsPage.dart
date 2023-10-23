import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/pages/skinPage.dart';

import 'EyesPage.dart';
import 'browPage.dart';
import 'lipsPage.dart';

class NailsPage extends StatefulWidget {
  const NailsPage({super.key, required this.title});
  final String title;
  @override
  State<NailsPage> createState() => _NailsPageState();
}

class _NailsPageState extends State<NailsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.red[200]!,),
        body: Column(
          children: [
            Container(
              child: Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection(
                        "SousCategories").where("idCategorie",
                        isEqualTo: FirebaseFirestore.instance.doc(
                            'Categories/4UFwQChDvPHUrg7k8XiS')).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              /*onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const GetProduct(title: MyApp.appTitle),
                                    // Pass the arguments as part of the RouteSettings. The
                                    // DetailScreen reads the arguments from these settings.
                                    settings: RouteSettings(
                                      arguments: sousCategorie[index],
                                    ),
                                  ),
                                );
                              },*/
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
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFEF9A9A),
                ),
                child: Text('Get Ready'),
              ),
              ListTile(
                title: const Text('Produits teint'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SkinPage(title: MyApp.appTitle)),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits yeux'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EyesPage(
                        title: MyApp.appTitle)),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits lèvres'),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LipsPage(title: MyApp.appTitle)),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits sourcils'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BrowPage(
                        title: MyApp.appTitle)),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits ongles'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NailsPage(
                        title: MyApp.appTitle)),
                  );
                },
              ),
            ],
          ),

        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Mon Panier',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp),
              label: 'Mon Compte',
            )
          ],
          selectedItemColor: Colors.red[200],


        ),
      );
    }
  }