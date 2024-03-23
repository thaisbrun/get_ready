import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/EyesPage.dart';
import 'package:get_ready/pages/browPage.dart';
import 'package:get_ready/pages/lipsPage.dart';
import 'package:get_ready/pages/myAccount.dart';
import 'package:get_ready/pages/nailsPage.dart';
import 'package:get_ready/pages/skinPage.dart';
import 'package:get_ready/services/product_service.dart';

import 'firebase_options.dart';
import 'models/product_model.dart';

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

  ProductService service = ProductService();
  Future<List<Product>>? products;
  List<Product>? productsList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    products = service.retrieveProducts();
    productsList = await service.retrieveProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showProductInformationsDialog(Product product) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user peut cliquer a coté pour fermer
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Informations produit'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Nom : ${product.libelle}'),
                  Text('Description : ${product.description}'),
              //    Text('Marque : ${product.brand} ')
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Ajouter au panier'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Center(
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
        backgroundColor: Colors.red[200]!),
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
              Flexible(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: products,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Product>> snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData) {
                        return const Text("Aucun produit");
                      }

                      return ListView.builder(
                        itemCount: productsList!.length,
                        itemBuilder: (context, index) {
                          final product = productsList![index];
                          final libelle = product.libelle;
                         // final brand = product.brand;
                         /* final mesure = product['mesure']; */
                          final description = productsList![index].description;
                          /*final conseilUtil = product['conseilUtil'];
                          final prix = product['prix']; */
                          return Card(
                            child: ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: 1),
                              title: Text(libelle),
                              textColor: Colors.red[200]!,
                              trailing: IconButton(
                                  icon:const Icon(Icons.open_in_new),
                             onPressed: () {
                                showProductInformationsDialog(Product(libelle: libelle, description: description,
                                    //brand:brand
                                    ));
                              },
                            ),
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

      ),
    );
  }
}



