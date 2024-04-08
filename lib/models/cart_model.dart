import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';
import 'package:get_ready/models/utilisateur_model.dart';
import 'package:get_ready/services/product_service.dart';
import 'package:get_ready/services/utilisateur_service.dart';

class Cart {
 final List<dynamic>? listProduits;
  final Utilisateur? utilisateur;
  final String? utilisateurId;
  final Timestamp? dateCreation;
  final bool activation;

  Cart({
    this.listProduits,
    this.dateCreation,
    this.utilisateur,
    this.utilisateurId,
    required this.activation
  });

  Map<String, dynamic> toMap() {
    return {
      'idUtilisateur' : utilisateurId,
      'listExemplaires': listProduits,
      'dateCreation': dateCreation,
      'activation': activation,
    };
  }

  static Future<Cart?> fromMap(Map<String, dynamic> productMap) async {
    String? utilisateurId = productMap['idUtilisateur'];
    if (utilisateurId == null) return null;

    // Charger les données de la marque
    Utilisateur? utilisateur = await UtilisateurService().getUserLinkToFirestore(utilisateurId);

    return Cart(
      listProduits: productMap['listExemplaires'],
      activation: productMap['activation'],
      utilisateur: utilisateur,
      dateCreation: productMap['dateCreation'],
      utilisateurId: productMap['idUtilisateur'],
    );
  }
  static Future<Cart> getCartWithBrandData(Cart cart) async {

    Utilisateur? utilisateur = await UtilisateurService().getUserLinkToFirestore(cart.utilisateurId);
    //Ici pour la liste d'ingrédients
    List<dynamic> listExemplaires = []; // Liste pour stocker les détails des ingrédients
    // Récupération des détails des ingrédients pour chaque référence d'ingrédient dans le produit
    // Utilisation de forEach

    for (var produit in cart.listProduits!) {
      if (cart.listProduits!.isNotEmpty) {
        Future<Product?> ing = ProductService.getProductWithBrandData(produit.id);
        listExemplaires.add(ing);
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
  factory Cart.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

// Récupérer l'ID de référence du document Brand
    String utilisateurId = data['idUtilisateur'];
    List<dynamic> listProduitsReferences = data['listExemplaires'];
    List<Product?> listProduits = [];
// Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
    Timestamp? dateCreation = data['dateCreation'];
    bool activation = data['activation'];
    // Liste pour stocker les détails des ingrédients
    // Récupération des détails des ingrédients pour chaque référence d'ingrédient dans le produit
    // Utilisation de forEach

    for (var product in listProduitsReferences) {
      if (listProduitsReferences.isNotEmpty) {
        Future<Product?> ing = ProductService().loadfullProduct(product.id);
        listProduits.add(ing as Product?);
      }
    }
    return Cart(
        listProduits: listProduits,
        utilisateurId: utilisateurId,
        dateCreation: dateCreation,
        activation: activation
    );
  }

}
