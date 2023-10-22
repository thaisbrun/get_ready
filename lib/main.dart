import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/EyesPage.dart';
import 'package:get_ready/pages/browPage.dart';
import 'package:get_ready/pages/getProduct.dart';
import 'package:get_ready/pages/lipsPage.dart';
import 'package:get_ready/pages/myAccount.dart';
import 'package:get_ready/pages/nailsPage.dart';
import 'package:get_ready/pages/skinPage.dart';

import 'firebase_options.dart';

//Cette fonction permet de démarrer mon application

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Get Ready';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/homeImg.jpg"),
            const Row(
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
            CupertinoButton(
              child: const Text("J'ai déjà un compte"),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const MyAccount()),
                );
              },
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
            Flexible(
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
                            textColor: Colors.red[200]!,
                            trailing: const Icon(Icons.open_in_new),
                           /* onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GetProduct(title: MyApp.appTitle),
                                  // Pass the arguments as part of the RouteSettings. The
                                  // DetailScreen reads the arguments from these settings.
                                  settings: RouteSettings(
                                    arguments: products[index],
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
          ],
            ),
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
                  MaterialPageRoute(builder: (context) => const SkinPage(title:MyApp.appTitle)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits yeux'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EyesPage(title: MyApp.appTitle)),
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
                  MaterialPageRoute(builder: (context) => const BrowPage(title: MyApp.appTitle,)),
                );
              },
            ),
            ListTile(
              title: const Text('Produits ongles'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NailsPage(title: MyApp.appTitle)),
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



