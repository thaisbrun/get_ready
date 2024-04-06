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
  String getImagePath(String? id) {
    // Logique pour déterminer le chemin de l'image en fonction de l'ID du produit
    if (id == 'AXg2ouAmz9t6115IFvdM') {
      return 'assets/images/homeImg.jpg'; // Chemin de l'image pour le produit avec ID 1
    } else if (id == 'mztE3llC2MpQ7n8cxtLO') {
      return 'assets/images/imageTest.jpg'; // Chemin de l'image pour le produit avec ID 2
    }
    else{
    return 'pas de lien';}
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
            Padding(padding: const EdgeInsets.all(16.0)),
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
                    margin: EdgeInsets.all(10.0),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                          children: [
                            Image.asset(getImagePath(favori.productId)),
                            ListTile(
                      title: Text(produit.libelle),
                      subtitle: Text(
                        ' Produit ${produit.subCategory!.name.toLowerCase()} de chez ${produit.brand!.libelle.toUpperCase()} ',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon:Icon(Icons.close_rounded),
                            onPressed: () {
                              favService.deleteFav(favori.id);
                            },
                          ),
                          Text('Supprimer favoris'),
                          Container(
                            margin: const EdgeInsets.only(left: 25.0),
                            child:ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(10)),
                              backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
                              foregroundColor: const MaterialStatePropertyAll(Colors.white),
                            ),
                            onPressed: () {
                            },
                            child: const Text('Ajouter au panier', selectionColor: Colors.white),
                          ),
                          ),
                        ]
                    ),
                    ),
                          ],
                  ),
                  );
                  }
                }
    )
      )
        ]
    )
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
