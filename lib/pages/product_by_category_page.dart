import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_ready/main.dart';
import 'package:get_ready/models/subcategory_model.dart';
import 'package:get_ready/services/favori_service.dart';
import '../models/favs_models.dart';
import '../models/ingredient_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/subcategory_service.dart';
import 'connexion.dart';
import 'my_account.dart';
import 'my_cart.dart';
import 'my_fav.dart';

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
  FavService favService = FavService();
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
  String getImagePath(String? id) {
    if (id == 'S06QeCJdPDMn7E4LavRK') {
      return 'assets/images/produitTeint.jpg';
    } else if (id == 'IJNzsCvZlQiYLgWsOT8k') {
      return 'assets/images/produitYeux.jpg';
    }
    else{
      return 'pas de lien';}
  }
  Future<void> loadProductWithBrandData() async {
    String categoryId = widget.categoryId;
    // Récupérer les données de Product depuis Firestore (par exemple avec retrieveProducts())
    List<Product> products = await service.retrieveProductsByCategoryId(categoryId);
    // Charger les données de Brand pour chaque Product
    List<Product> productsWithBrandData = [];
    for (Product product in products) {
      Product productWithBrandData = await ProductService.getProductWithData(product);
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
        title: const Text('Produits'),
        backgroundColor: Colors.red[200]!,),
      body:Center(
        child: Column(
          children: [
            Image.asset(getImagePath(widget.categoryId)),
             Row(
              children: [
                Center(
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: DropdownButton<SubCategory>(
          value: null,
            hint: const Text('Trier sous-catégorie'),
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
                const Expanded(
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
                height: 170,
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
                                style:const TextStyle(fontStyle: FontStyle.italic)),
                            Text('${product.prix.toString()} €',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                  fontSize: 20),),
                            const SizedBox(height: 8),
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(iconSize: 22, padding: const EdgeInsets.only(right: 8.0),
                                      icon: const Icon(Icons.favorite_border),
                                      color: Colors.pink,
                                      onPressed: () {
                                        favService.addFav(Fav(userId: FirebaseAuth.instance.currentUser?.uid,
                                            productId: product.id, dateCreation: Timestamp.now(), activation: true));

                                      }),
                                  IconButton(iconSize: 22, padding: const EdgeInsets.only(right: 8.0),
                                    icon: const Icon(Icons.open_in_new), onPressed: () {
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
                                    },),
                                ]
                            ),
                          ],
                        )),
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                            image: const DecorationImage(
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