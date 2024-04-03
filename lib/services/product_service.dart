import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';

import '../models/brand_model.dart';
import '../models/subCategory_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<List<Product>> retrieveProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("Produits").get();
      return snapshot.docs
          .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des produits: $e");
      throw e;
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
  // Fonction asynchrone pour récupérer les données de Brand à partir de son ID
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

// Utilisation de fetchBrandData pour récupérer les données de Brand et compléter l'instance de Product
  static Future<Product> getProductWithBrandData(Product product) async {
    Brand? brand = await fetchBrandData(product.brandId);
    SubCategory? subCategory = await fetchSubCategoryData(product.subCategoryId);
    // Créer une nouvelle instance de Product avec les données de Brand

    return Product(
      id: product.id,
      libelle: product.libelle,
      description: product.description,
      conseilUtilisation: product.conseilUtilisation,
      mesure:product.mesure,
      prix: product.prix,
      brand: brand,
      subCategory: subCategory,
    );
  }
}