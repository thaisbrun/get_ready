import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Cart?> getCartLinkToFirestore(String? refUserAuth) async {
    if (refUserAuth == null) return null;

    QuerySnapshot<Map<String, dynamic>> cartSnapshot = await FirebaseFirestore.instance
        .collection('Paniers')
        .where("idUtilisateur", isEqualTo: refUserAuth) // Assurez-vous que la clé utilisateur est correcte
        .get();

    if (cartSnapshot.docs.isNotEmpty) {
      // Utilisez le premier document trouvé
      DocumentSnapshot<Map<String, dynamic>> firstDoc = cartSnapshot.docs.first;
      return Cart.fromDocumentSnapshot(firstDoc);
    } else {
      return null; // Aucun utilisateur trouvé avec la clé donnée
    }
  }
  addToCart(Cart cartData) async {
    await _db.collection("Paniers").add(cartData.toMap());
    print("Le produit ajouté dans le panier est ");
  }
}