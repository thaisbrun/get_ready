import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/models/favs_models.dart';
import 'package:get_ready/pages/connexion.dart';
import 'package:get_ready/pages/my_account.dart';
import 'package:get_ready/pages/my_cart.dart';
import 'package:get_ready/pages/my_fav.dart';
import 'package:get_ready/pages/product_by_category_page.dart';
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

  Future<void> loadProductWithBrandData() async {
    List<Product> products = await ProductService().retrieveProducts();
    List<Product> productsWithBrandData = [];
    for (Product product in products) {
      Product productWithBrandData = await ProductService.getProductWithData(product);
      productsWithBrandData.add(productWithBrandData);

    }

    setState(() {
      productsList = productsWithBrandData;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProductWithBrandData();
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
                            future: product.listIngredients[index],
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                final ingredient = snapshot.data;
                                if (ingredient != null) {
                                  return Text(ingredient.libelle);
                                }
                              }
                              return const CircularProgressIndicator(); // Affiche une indication de chargement en attendant la résolution du Future
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
                          final libelle = product.libelle;
                          final brand = product.brand;
                          final subCategory = product.subCategory;
                          final conseilUtilisation = product.conseilUtilisation;
                          final mesure = product.mesure;
                          final prix = product.prix;
                          final description = product.description;
                          final listIngredients = product.listIngredients;
                          final ingredient = index < listIngredients.length ? listIngredients[index] : null;
                          return Card(
                            color:Colors.red[100]!,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/homeImg.jpg"),
                              ),
                              dense: true,
                              visualDensity: const VisualDensity(vertical: 1),
                              title: Text(libelle),
                              textColor: Colors.black,
                              trailing: IconButton(
                                  icon:const Icon(Icons.open_in_new),
                             onPressed: () {
                                showProductInformationsDialog(Product(
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
          child: ListView(
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
                    MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'S06QeCJdPDMn7E4LavRK')),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits yeux'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'IJNzsCvZlQiYLgWsOT8k')),
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
                    MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'zqlU4lCuCAfiu30KIH6h')),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits sourcils'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'3C5vfgtxttPvB0Nc79d2')),
                  );
                },
              ),
              ListTile(
                title: const Text('Produits ongles'),
                selected: _selectedIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'4UFwQChDvPHUrg7k8XiS')),
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



