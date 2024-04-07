import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/models/subCategory_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/subCategory_service.dart';
import 'connexion.dart';
import 'myAccount.dart';
import 'myCart.dart';
import 'myFav.dart';

class ProductByCategoryPage extends StatefulWidget {
  const ProductByCategoryPage({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<ProductByCategoryPage> createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
  int _selectedIndex = 0;
  List<Product>? productsList;
  ProductService service = ProductService();
  SubCategoryService subCategoryService = SubCategoryService();
  SubCategory? selectedSubCategory; // Variable pour stocker la sous-catégorie sélectionnée
  List<SubCategory>? listSubCategory;
  @override
  void initState() {
    super.initState();
    loadProductWithBrandData();
    loadSubCategoryData();// Appeler la méthode pour charger les données avec les données de Brand
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
  Future<void> loadProductWithBrandData() async {
    String categoryId = widget.categoryId;
    // Récupérer les données de Product depuis Firestore (par exemple avec retrieveProducts())
    List<Product> products = await service.retrieveProductsByCategoryId(categoryId);
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
  Future<void> loadSubCategoryData() async {
    // Récupérer les données de Product depuis Firestore (par exemple avec retrieveProducts())
    List<SubCategory> subCategories = await subCategoryService.retrieveSubcategories();
    // Charger les données de Brand pour chaque Product
    List<SubCategory> subCatData = [];

    // Mettre à jour l'état de votre Widget avec les nouveaux produits chargés
    setState(() {
      listSubCategory = subCategories;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        backgroundColor: Colors.red[200]!,),
      body:Center(
        child: Column(
          children: [
             Row(
              children: [
        Center(
        child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: DropdownButton<SubCategory>(
          value: null,
            hint: Text('Trier sous-catégorie'),
          onChanged: (newValue) {
            setState(() {
              selectedSubCategory = newValue;
            });
          },
          items: listSubCategory?.map((subCategory) {
            return DropdownMenuItem<SubCategory>(
              value: subCategory,
              child: Text(subCategory.name), // Supposons que "name" est le nom de la sous-catégorie dans votre modèle de sous-catégorie
            );
          }).toList(),
                ),
        ),
      ),
    ),
                Expanded(
                  child:Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SearchBar(
                      hintText: 'Renseigner mot clé...',
                        constraints: BoxConstraints(minWidth: 0.0, maxWidth: 300.0, minHeight: 50.0)
                    ),
                  ),
                ),
              ],
            ),
      Flexible(
        child:ListView.builder(
            itemCount: productsList?.length,
            itemBuilder: (BuildContext context, int index) {
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

               return Container(
                height: 136,
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
                            Text("${brand?.libelle.toUpperCase()} - ${subCategory?.name}",
                                style:TextStyle(fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icons.favorite_border,
                                Icons.open_in_new,
                              ].map((e) {
                                return InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(e, size: 16),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        )),
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('item.imageUrl'),
                            ))),
                  ],
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