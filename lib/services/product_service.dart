
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';
import 'package:get_ready/services/subcategory_service.dart';

import '../models/brand_model.dart';
import '../models/ingredient_model.dart';
import '../models/subcategory_model.dart';
import 'brand_service.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //Fonction qui charge le produit en fonction de son id
  Future<Product?> loadfullProduct(String? id) async {
    if (id == null) return null;
    try{
    QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
        .collection('Produits')
        .where(FieldPath.documentId, isEqualTo: id)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> firstDoc = userSnapshot.docs.first;
      return Product.fromDocumentSnapshot(firstDoc);
    } else {
      return null;
    }}catch (e) {
      print("Erreur lors de la récupération des infos du produit : $e");
      rethrow;
    }
  }
  //Fonction qui charge la liste des produits
  Future<List<Product>> retrieveProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("Produits").get();
      return snapshot.docs
          .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des produits: $e");
      rethrow;
    }
  }
  //Fonction qui charge les produits de la souscatégorie indiquée
  Future<List<Product>> retrieveProductsByCategoryId(String categoryId) async {
    try {
      //Chargement des sous catégories présentes dans la catégorie
      DocumentReference categoryRef = _db.collection("Categories").doc(categoryId);
      QuerySnapshot<Map<String, dynamic>> subCategorySnapshot =
      await _db.collection("SousCategories")
          .where("idCategorie", isEqualTo: categoryRef)
          .get();

      List<DocumentReference> subCategoryRefs = subCategorySnapshot.docs.map((doc) => doc.reference).toList();
      //Chargement des produits appartenant aux sous catégories
      QuerySnapshot<Map<String, dynamic>> productSnapshot = await _db
          .collection("Produits")
          .where("idSousCategorie", whereIn: subCategoryRefs)
          .get();

      return productSnapshot.docs
          .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des produits par sous catégories : $e");
      rethrow;
    }
  }
  // 3 fonctions de base : ajout, update et delete
  addProduct(Product productData) async {
    await _db.collection("Produits").add(productData.toMap());
  }
  updateProduct(Product productData) async {
    await _db.collection("Produits").doc(productData.id).update(
        productData.toMap());
  }
  Future<void> deleteProduct(String documentId) async {
    await _db.collection("Produits").doc(documentId).delete();
  }
  //Fonction pour charger un ingrédient en fonction de son id
  static Future<Ingredient?> fetchIngredientData(String? ingredientId) async {

    if (ingredientId == null) return null;
    DocumentSnapshot<Map<String, dynamic>> ingredientSnapshot = await FirebaseFirestore.instance
        .collection('Ingredients')
        .doc(ingredientId)
        .get();

    if (ingredientSnapshot.exists) {
      return Ingredient.fromMap(ingredientSnapshot.data()!);
    } else {
      return null;
    }
  }
  //Fonction pour charger un produit et ses données
  static Future<Product> getProductWithData(Product product) async {
    Brand? brand = await BrandService.fetchBrandData(product.brandId);
    SubCategory? subCategory = await SubCategoryService.fetchSubCategoryData(product.subCategoryId);
    List<dynamic> ingredients = [];
    for (var ingredient in product.listIngredients) {
      if (product.listIngredients.isNotEmpty) {
      Future<Ingredient?> ing = fetchIngredientData(ingredient.id);
      ingredients.add(ing);
    }
    }

    return Product(
      id: product.id,
      libelle: product.libelle,
      description: product.description,
      conseilUtilisation: product.conseilUtilisation,
      mesure:product.mesure,
      prix: product.prix,
      brand: brand,
      subCategory: subCategory,
      listIngredients: ingredients,
    );
  }
}