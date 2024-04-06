import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/services/favori_service.dart';

import '../main.dart';
import '../models/favs_models.dart';
import '../models/ingredient_model.dart';
import '../models/product_model.dart';
import 'connexion.dart';
import 'myAccount.dart';
import 'myCart.dart';

class MyFav extends StatefulWidget {
  const MyFav({super.key});

  @override
  State<MyFav> createState() => _MyFavState();

}

class _MyFavState extends State<MyFav> {

  int _selectedIndex = 0;
  List<Fav>? favList;
  FavService favService = FavService();

  @override
  void initState() {
    super.initState();
    loadFavoriWithProductData(); // Appeler la méthode pour charger les données avec les données de Brand
  }
  Future<void> loadFavoriWithProductData() async {
    // Récupérer les données de Product depuis Firestore (par exemple avec retrieveProducts())
    List<Fav> favoris = await FavService().retrieveFavoris(FirebaseAuth.instance.currentUser?.uid);
    // Charger les données de Brand pour chaque Product
    List<Fav> favorisWithBrandData = [];
    for (Fav favori in favoris) {
      Fav favoriWithBrandData = await FavService.getFavWithProductData(favori);
      favorisWithBrandData.add(favoriWithBrandData);
    }

    // Mettre à jour l'état de votre Widget avec les nouveaux produits chargés
    setState(() {
      favList = favorisWithBrandData;
    });
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
          title:const Text('Liste de mes favoris'),
          backgroundColor: Colors.red[200]!),
      body: Center(
        child: Column(
          children: [
            Text('\nVOS FAVORIS', style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.red[200]!,
                fontSize: 20)),
            Flexible(
              child:ListView.builder(
                itemCount: favList!.length,
                itemBuilder: (context, index) {
                  final favori = favList![index];
                  final id = favori.id;
                  final produit = favori.produit;
                  final utilisateur = favori.user;
                  final dateCreation = favori.dateCreation;
                  if (produit != null) {
                  return Card(
                    color:Colors.red[100]!,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/homeImg.jpg"), // No matter how big it is, it won't overflow
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: 1),
                      title: Text(produit.libelle),
                      textColor: Colors.black,
                      trailing: IconButton(
                        icon:const Icon(Icons.open_in_new),
                        onPressed: () {

                          showProductInformationsDialog(Product(
                            id:produit.id,
                            libelle: produit.libelle,
                            description: produit.description,
                            brand:produit.brand,
                            subCategory: produit.subCategory,
                            conseilUtilisation:produit.conseilUtilisation,
                            mesure:produit.mesure,
                            prix:produit.prix,
                            listIngredients: produit.listIngredients,
                          ));
                        },
                      ),
                    ),
                  );}
    else{
    Text("Vous n'avez pas encore de favoris");
    }
                },
              ),
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
