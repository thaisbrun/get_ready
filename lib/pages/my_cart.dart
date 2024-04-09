import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/pages/product_by_category_page.dart';
import 'package:get_ready/services/cart_service.dart';
import '../main.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'connexion.dart';
import 'my_account.dart';
import 'my_fav.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int _selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  CartService cartService = CartService();
  List<Product>? productsList;

  //Méthode utilisée pour la navbar
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
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    Cart cart = (await CartService().getCartLinkToFirestore(user?.uid)) as Cart;
    List<Product> productsWithBrandData = [];
    for (Product product in cart.listProduits!) {
      Product productWithBrandData = await ProductService.getProductWithData(product);
      productsWithBrandData.add(productWithBrandData);
    }

    setState(() {
      productsList = productsWithBrandData;
      cart = cart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
        backgroundColor: Colors.red[200]!,),
      body: Column(
        children: [
          Flexible(
            child:ListView.builder(
              itemCount: productsList?.length,
              itemBuilder: (BuildContext context, int index) {
                final product = productsList![index];
                final libelle = product.libelle;
                final brand = product.brand;
                final subCategory = product.subCategory;
                final mesure = product.mesure;
                final prix = product.prix;
                return Container(
                  height: 200,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                libelle,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text("${brand?.libelle.toUpperCase()}",
                                  style:const TextStyle(fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                              Text("${product.prix} €",
                                  style:const TextStyle(fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  const Text('Quantité : '),
                                  IconButton(iconSize: 16, padding: const EdgeInsets.only(right: 8.0),
                                    icon: const Icon(Icons.add), onPressed: () {  }),
                                  IconButton(iconSize: 16, padding: const EdgeInsets.only(right: 8.0),
                                    icon: const Icon(Icons.remove), onPressed: () {  },),
                                ]
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Colors.red[200]!),
                                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                                    ),
                                    onPressed: () {}, child: const Text('Ajouter au panier', selectionColor: Colors.white),
                                  ),
                                  const Spacer(),
                              CupertinoButton(
                                onPressed: () {},
                                child: const Text('Retirer du panier',

                                    style: TextStyle(fontSize: 14),
                                    selectionColor: Colors.black45),
                              ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
    Container(
      margin: const EdgeInsets.only(bottom: 350.0),
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.pink),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
            onPressed: () {}, child: const Text('Passer au paiement',
              selectionColor: Colors.white),
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
