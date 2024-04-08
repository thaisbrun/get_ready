import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';
import 'package:get_ready/models/utilisateur_model.dart';
import 'package:get_ready/services/product_service.dart';
import 'package:get_ready/services/utilisateur_service.dart';

class Cart {
  //propriétés
 final List<dynamic>? listProduits;
  final Utilisateur? utilisateur;
  final String? utilisateurId;
  final Timestamp? dateCreation;
  final bool activation;
  //constructeur
  Cart({
    this.listProduits,
    this.dateCreation,
    this.utilisateur,
    this.utilisateurId,
    required this.activation
  });
  //methodes
  Map<String, dynamic> toMap() {
    return {
      'idUtilisateur' : utilisateurId,
      'listExemplaires': listProduits,
      'dateCreation': dateCreation,
      'activation': activation,
    };
  }
  static Future<Cart?> fromMap(Map<String, dynamic> cartMap) async {
    //Je récupère l'id du user dans mon objet Panier
    String? utilisateurId = cartMap['idUtilisateur'];
    //Si le panier n'a pas d'utilisateur je retourne null
    if (utilisateurId == null) return null;

    // Charger les données complètes de l'objet utilisateur
    Utilisateur? utilisateur = await UtilisateurService().getUserLinkToFirestore(utilisateurId);

    return Cart(
      listProduits: cartMap['listExemplaires'],
      activation: cartMap['activation'],
      utilisateur: utilisateur,
      dateCreation: cartMap['dateCreation'],
      utilisateurId: cartMap['idUtilisateur'],
    );

  }
  static Future<Cart> getCartWithBrandData(Cart cart) async {
    //Chargement de l'objet utilisateur et de ses propriétés
    Utilisateur? utilisateur = await UtilisateurService().getUserLinkToFirestore(cart.utilisateurId);
    List<dynamic> listExemplaires = []; // Liste pour stocker les détails des produits
    //Je parcours la liste des produits du Panier
    for (var produit in cart.listProduits!) {
      if (cart.listProduits!.isNotEmpty) {
        //Pour chaque produit je charge ses infos complètes et l'ajoute à ma liste dynamique
        Future<Product?> prdt = ProductService.getProductWithBrandData(produit.id);
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
  factory Cart.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    String utilisateurId = data['idUtilisateur'];
    List<dynamic> listProduitsReferences = data['listExemplaires'];
    List<Product?> listProduits = [];
    Timestamp? dateCreation = data['dateCreation'];
    bool activation = data['activation'];

    //Je parcours la liste des produits référencés et charge leurs infos
    for (var product in listProduitsReferences) {
      if (listProduitsReferences.isNotEmpty) {
        Future<Product?> pdt = ProductService().loadfullProduct(product.id);
        listProduits.add(pdt as Product?);
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
