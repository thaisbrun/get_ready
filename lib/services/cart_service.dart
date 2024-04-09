import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/cart_model.dart';
import 'package:get_ready/services/product_service.dart';
import 'package:get_ready/services/utilisateur_service.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<Cart> getCartWithBrandData(Cart cart) async {
    //Chargement de l'objet utilisateur et de ses propriétés
    Utilisateur? utilisateur = await UtilisateurService().getUserLinkToFirestore(cart.utilisateurId);
    List<dynamic> listExemplaires = []; // Liste pour stocker les détails des produits
    //Parcours la liste des produits du Panier
    for (var produit in cart.listProduits!) {
      if (cart.listProduits!.isNotEmpty) {
        //Pour chaque produit je charge ses infos complètes + ajout
        Future<Product?> prdt = ProductService.getProductWithData(produit.id);
        listExemplaires.add(prdt);
      }
    }
    return Cart(
      dateCreation: cart.dateCreation,
      activation: cart.activation,
      utilisateurId: cart.utilisateurId,
      utilisateur: utilisateur,
      listProduits: listExemplaires,
    );
  }
  Future<Cart?> getCartLinkToFirestore(String? refUserAuth) async {
    if (refUserAuth == null) return null;

    QuerySnapshot<Map<String, dynamic>> cartSnapshot = await FirebaseFirestore.instance
        .collection('Paniers')
        .where("idUtilisateur", isEqualTo: refUserAuth)
        .get();

    if (cartSnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> firstDoc = cartSnapshot.docs.first;
      return Cart.fromDocumentSnapshot(firstDoc);
    } else {
      return null;
    }
  }
  addToCart(Cart cartData) async {
    await _db.collection("Paniers").add(cartData.toMap());
    print("Le produit ajouté dans le panier est ");
  }
}