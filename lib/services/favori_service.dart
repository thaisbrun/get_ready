import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/models/favs_models.dart';
import 'package:get_ready/services/product_service.dart';

import '../models/brand_model.dart';
import '../models/product_model.dart';
import '../models/subCategory_model.dart';

class FavService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Fav>> retrieveFavoris(String? userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _db.collection("Favoris")
          .where("idUtilisateur", isEqualTo: userId) // Assurez-vous que la clé utilisateur est correcte
          .get();

      List<Fav> favoris = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot in querySnapshot.docs) {
        favoris.add(Fav.fromDocumentSnapshot(docSnapshot));
      }
      return favoris;
    } catch (e) {
      print("Erreur lors de la récupération des favoris: $e");
      rethrow;
    }
  }

  static Future<Product?> fetchProductData(String? productId) async {
    if (productId == null) return null;

    DocumentSnapshot<Map<String, dynamic>> productSnapshot = await FirebaseFirestore.instance
        .collection('Produits')
        .doc(productId)
        .get();
    if (productSnapshot.exists) {
      return Product.fromMap(productSnapshot.data()!);
    } else {
      return null;
    }
  }

  static Future<Fav> getFavWithProductData(Fav fav) async {

    User? utilisateur = FirebaseAuth.instance.currentUser;
    Product? produit = await fetchProductData(fav.productId);

    return Fav(
      id: fav.id,
      userId: fav.userId,
      productId: fav.productId,
      activation: fav.activation,
      dateCreation: fav.dateCreation,
      user: utilisateur,
      produit: produit,
    );
  }

  addFav(Fav favData) async {
    await _db.collection("Favoris").add(favData.toMap());
    print("Le favori ajouté est ${favData.userId}, ${favData.productId}, ${favData.dateCreation}");
  }
  Future<void> deleteFav(String? documentId) async {
    await _db.collection("Favoris").doc(documentId).delete();
  }
}