import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<List<Cart>> retrieveCart() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("Paniers").get();
      return snapshot.docs
          .map((docSnapshot) => Cart.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des favoris: $e");
      throw e;
    }
  }

  addToCart(Cart cartData) async {
    await _db.collection("Paniers").add(cartData.toMap());
    print("Le produit ajouté dans le panier est ");
  }
}