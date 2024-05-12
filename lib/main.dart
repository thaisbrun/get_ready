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
        if(FirebaseAuth.instance.currentUser != null){
          Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyCart()
            )
        );}else{
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Connexion())
          );
        }
      }
      if(_selectedIndex==2) {
        if(FirebaseAuth.instance.currentUser != null){
          Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const MyFav()
            )
        );
      }else{
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Connexion())
        );
      }
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

  String getImagePathProduct(String? id) {
    if (id == '5J6KpoFPbi2xDemurgsD') {
      return 'assets/images/productImg/productOilstick.jpg';
    } else if (id == 'AXg2ouAmz9t6115IFvdM') {
      return 'assets/images/productImg/productMascara.jpg';
    } else if(id == '1gqLDOIXVeM6wnntP6Bb'){
      return 'assets/images/productImg/productBrowPencil.jpg';
    }else if(id == 'Jl1qAWHLeThugMabIV2W'){
      return 'assets/images/productImg/productLipstick.jpg';
    }else if(id == 'NZdIIVNA12qcd6Yih48j'){
      return 'assets/images/productImg/productGelbrow.jpg';
    }else if(id == 'RrrVA4gkQDDLUqZE8qIF'){
      return 'assets/images/productImg/productFakeNails.jpg';
    }else if(id == 'TFkzSOQLxVuhIIhUyufD'){
      return 'assets/images/productImg/productConcealer.jpg';
    }else if(id == 'mztE3llC2MpQ7n8cxtLO'){
      return 'assets/images/productImg/productPalette.jpg';
    }else if(id == 'zlTmJS8SvxOLiyotcley'){
      return 'assets/images/productImg/productPowder.jpg';
    }
    else{
      return 'pas de lien';}
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
                  Image.asset(getImagePathProduct(product.id)),
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
                  const snackBar = SnackBar(content: Text('Le produit a été rajouté en favori avec succès !'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                  });
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: () {
                  const snackBar = SnackBar(content: Text('Le produit a été rajouté au panier avec succès !'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          final ingredient = index < listIngredients.length ? listIngredients[index] : null;
                          return Card(
                            color:Colors.red[100]!,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(getImagePathProduct(id)),
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"), // Remplacez "votre_image.jpg" par le chemin de votre image
                  fit: BoxFit.cover,
                ),
                color: Color(0xFFEF9A9A),
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Produits teint'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'S06QeCJdPDMn7E4LavRK')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits yeux'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'IJNzsCvZlQiYLgWsOT8k')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits lèvres'),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductByCategoryPage(categoryId:'3C5vfgtxttPvB0Nc79d2')),
                );
              },
            ),
            ListTile(
              title: const Text('Produits ongles'),
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



