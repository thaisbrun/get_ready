import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/models/favs_models.dart';
import 'package:get_ready/pages/EyesPage.dart';
import 'package:get_ready/pages/browPage.dart';
import 'package:get_ready/pages/connexion.dart';
import 'package:get_ready/pages/lipsPage.dart';
import 'package:get_ready/pages/myAccount.dart';
import 'package:get_ready/pages/myCart.dart';
import 'package:get_ready/pages/myFav.dart';
import 'package:get_ready/pages/nailsPage.dart';
import 'package:get_ready/pages/skinPage.dart';
import 'package:get_ready/services/favori_service.dart';
import 'package:get_ready/services/product_service.dart';

import 'firebase_options.dart';
import 'models/ingredient_model.dart';
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
  FavService favService = FavService();
  List<Product>? productsList;
  int _selectedIndex = 0;

  // Méthode asynchrone pour charger les données de Product avec les données de Brand
  Future<void> loadProductWithBrandData() async {
    // Récupérer les données de Product depuis Firestore (par exemple avec retrieveProducts())
    List<Product> products = await ProductService().retrieveProducts();
    // Charger les données de Brand pour chaque Product
    List<Product> productsWithBrandData = [];
    for (Product product in products) {
      Product productWithBrandData = await ProductService.getProductWithBrandData(product);
      productsWithBrandData.add(productWithBrandData);

    }

    // Mettre à jour l'état de votre Widget avec les nouveaux produits chargés
    setState(() {
      productsList = productsWithBrandData;
    });
  }

// Exemple d'utilisation dans votre Widget
  @override
  void initState() {
    super.initState();
    loadProductWithBrandData(); // Appeler la méthode pour charger les données avec les données de Brand
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==0) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyHomePage(title: MyApp.appTitle)
            )
        );
      }
      if(_selectedIndex==1) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyCart()
            )
        );
      }
      if(_selectedIndex==2) {
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyFav()
            )
        );
      }
    if(_selectedIndex==3) {
      if(FirebaseAuth.instance.currentUser != null){
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyAccount(title:MyApp.appTitle))
        );
      }else{
        Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const Connexion())
        );
      }
    }
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
            title: Text('Informations produit', selectionColor: Colors.red[200]!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content:
            SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/imageTest.jpg'),
                  ListBody(
                    children: <Widget>[
                      Text('\nProduit ${product.subCategory?.name} - ${product.brand?.libelle.toUpperCase()} '),
                      Text('${product.libelle} \n', selectionColor: Colors.red[200]!,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.red[200]!,
                          fontSize: 18)),
                      Text('${product.prix.toString()} €',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 20),),
                      Text(product.mesure,
                          textAlign: TextAlign.right,
                        style: const TextStyle(fontStyle: FontStyle.italic)
                      ),
                      Text('Description ',
                        style: TextStyle(fontWeight: FontWeight.normal,
                            color: Colors.red[200]!,
                            fontSize: 12)),
                      Text(product.description),
                      Text("\nConseils d'utilisation ",
                          style: TextStyle(fontWeight: FontWeight.normal,
                              color: Colors.red[200]!,
                              fontSize: 12)),
                      Text(product.conseilUtilisation!),
                      Text("\nIngrédients ",
                          style: TextStyle(fontWeight: FontWeight.normal,
                              color: Colors.red[200]!,
                              fontSize: 12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          product.listIngredients.length,
                              (index) => FutureBuilder<Ingredient?>(
                            future: product.listIngredients[index], // Récupère le Future<Ingredient?>
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                final ingredient = snapshot.data;
                                if (ingredient != null) {
                                  return Text(ingredient.libelle); // Utilise libelle après la résolution
                                }
                              }
                              return CircularProgressIndicator(); // Affiche une indication de chargement en attendant la résolution du Future
                            },
                              ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                color: Colors.pink,
                icon: const Icon(Icons.favorite_border),
                iconSize: 24.0,
                onPressed: () {
                  favService.addFav(Fav(userId: FirebaseAuth.instance.currentUser?.uid,
                      productId: product.id, dateCreation: Timestamp.now(), activation: true));
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ajouter au panier', selectionColor: Colors.white),
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
    return Scaffold(
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
              Text('\nNOS BEST-SELLERS', style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.red[200]!,
                  fontSize: 20)),
              Flexible(
                child:ListView.builder(
                        itemCount: productsList!.length,
                        itemBuilder: (context, index) {
                          final product = productsList![index];
                          final id = product.id;
                          final libelle = product.libelle;
                          final brand = product.brand;
                          final subCategory = product.subCategory;
                          final conseilUtilisation = product.conseilUtilisation;
                          final mesure = product.mesure;
                          final prix = product.prix;
                          final description = product.description;
                          final listIngredients = product.listIngredients;
                          final ingredient = product.listIngredients[index];
                          return Card(
                            color:Colors.red[100]!,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/homeImg.jpg"), // No matter how big it is, it won't overflow
                              ),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: 1),
                              title: Text(libelle),
                              textColor: Colors.black,
                              trailing: IconButton(
                                  icon:const Icon(Icons.open_in_new),
                             onPressed: () {
                                showProductInformationsDialog(Product(
                                  id:id,
                                  libelle: libelle,
                                    description: description,
                                    brand:brand,
                                    subCategory: subCategory,
                                    conseilUtilisation:conseilUtilisation,
                                    mesure:mesure,
                                    prix:prix,
                                    listIngredients: listIngredients,
                                    ));
                              },
                            ),
                          ),
                          );
                    },
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
        type: BottomNavigationBarType.fixed,
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
          icon: Icon(Icons.favorite),
          label: 'Mes favoris',
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



