import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/services/favori_service.dart';

import '../main.dart';
import '../models/favs_models.dart';
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
  @override
  void initState() {
    super.initState();
   // loadFavoriWithProductData(); // Appeler la méthode pour charger les données avec les données de Brand
  }
  Future<void> loadFavoriWithProductData() async {
    // Récupérer les données de Product depuis Firestore (par exemple avec retrieveProducts())
    List<Fav> favoris = await FavService().retrieveFavoris();
    // Charger les données de Brand pour chaque Product
    List<Fav> favorisWithBrandData = [];
    for (Fav favori in favoris) {
      //Fav favoriWithBrandData = await FavService.getFavWithProductData(favori);
     // favorisWithBrandData.add(favoriWithBrandData);

    }

    // Mettre à jour l'état de votre Widget avec les nouveaux produits chargés
    setState(() {
  //    favorisList = favorisWithBrandData;
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

    return Scaffold(
      appBar: AppBar(
          title:const Text('Liste de mes favoris'),
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
    /*
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
            ), */
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
