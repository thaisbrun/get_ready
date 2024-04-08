
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';

import '../models/brand_model.dart';
import '../models/ingredient_model.dart';
import '../models/subCategory_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<Product?> loadfullProduct(String? id) async {
    if (id == null) return null;

    QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
        .collection('Produits')
        .where("id", isEqualTo: id) // Assurez-vous que la clé utilisateur est correcte
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // Utilisez le premier document trouvé
      DocumentSnapshot<Map<String, dynamic>> firstDoc = userSnapshot.docs.first;
      return Product.fromDocumentSnapshot(firstDoc);
    } else {
      return null; // Aucun utilisateur trouvé avec la clé donnée
    }
  }
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
  Future<List<Product>> retrieveProductsByCategoryId(String categoryId) async {
    try {
      DocumentReference categoryRef = _db.collection("Categories").doc(categoryId);
      // 1. Récupérez les sous-catégories correspondant à l'ID de catégorie spécifié
      QuerySnapshot<Map<String, dynamic>> subCategorySnapshot =
      await _db.collection("SousCategories")
          .where("idCategorie", isEqualTo: categoryRef) // Assurez-vous que la clé utilisateur est correcte
          .get();

      List<DocumentReference> subCategoryRefs = subCategorySnapshot.docs.map((doc) => doc.reference).toList();

      // 2. Récupérez les produits correspondant aux sous-catégories obtenues
      QuerySnapshot<Map<String, dynamic>> productSnapshot = await _db
          .collection("Produits")
          .where("idSousCategorie", whereIn: subCategoryRefs)
          .get();

      return productSnapshot.docs
          .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des produits par sub cat : $e");
      rethrow;
    }
  }

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

// Fonction asynchrone pour récupérer les données de Brand à partir de son ID
  static Future<Brand?> fetchBrandData(String? brandId) async {
    if (brandId == null) return null;

    DocumentSnapshot<Map<String, dynamic>> brandSnapshot = await FirebaseFirestore.instance
        .collection('Marques')
        .doc(brandId)
        .get();

    if (brandSnapshot.exists) {
      return Brand.fromMap(brandSnapshot.data()!);
    } else {
      return null;
    }
  }
  static Future<SubCategory?> fetchSubCategoryData(String? subCategoryId) async {
    if (subCategoryId == null) return null;

    DocumentSnapshot<Map<String, dynamic>> subCategorySnapshot = await FirebaseFirestore.instance
        .collection('SousCategories')
        .doc(subCategoryId)
        .get();

    if (subCategorySnapshot.exists) {
      return SubCategory.fromMap(subCategorySnapshot.data()!);
    } else {
      return null;
    }
  }
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
  static Future<Product> getProductWithBrandData(Product product) async {

    Brand? brand = await fetchBrandData(product.brandId);
    SubCategory? subCategory = await fetchSubCategoryData(product.subCategoryId);
    //Ici pour la liste d'ingrédients
    List<dynamic> ingredients = []; // Liste pour stocker les détails des ingrédients
    // Récupération des détails des ingrédients pour chaque référence d'ingrédient dans le produit
    // Utilisation de forEach

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