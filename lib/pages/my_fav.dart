import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/product_by_category_page.dart';
import 'package:get_ready/services/favori_service.dart';

import '../main.dart';
import '../models/favs_models.dart';
import '../models/product_model.dart';
import 'connexion.dart';
import 'my_account.dart';
import 'my_cart.dart';

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
    loadFavoriWithProductData(); //Je charge la méthode qui permet de load les favoris et ses infos
  }
  Future<void> loadFavoriWithProductData() async {
    List<Fav> favoris = await FavService().retrieveFavoris(FirebaseAuth.instance.currentUser?.uid);
    List<Fav> favorisWithBrandData = [];
    for (Fav favori in favoris) {
      Fav favoriWithBrandData = await FavService.getFavWithProductData(favori);
      favorisWithBrandData.add(favoriWithBrandData);
    }
    setState(() {
      favList = favorisWithBrandData;
    });
  }
  String getImagePath(String? id) {
    if (id == 'AXg2ouAmz9t6115IFvdM') {
      return 'assets/images/homeImg.jpg';
    } else if (id == 'mztE3llC2MpQ7n8cxtLO') {
      return 'assets/images/imageTest.jpg';
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
            const Padding(padding: EdgeInsets.all(16.0)),
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
                    margin: const EdgeInsets.all(10.0),
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
                            icon:const Icon(Icons.close_rounded),
                            onPressed: () {
                              favService.deleteFav(favori.id);
                            },
                          ),
                          const Text('Supprimer favoris'),
                          Container(
                            margin: const EdgeInsets.only(left: 25.0),
                            child:ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(10)),
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
                  return null;
                }
    )
      )
        ]
    )
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
