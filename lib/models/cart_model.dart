import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';
import 'package:get_ready/models/user_model.dart';
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
 static Future<Cart> fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
   Map<String, dynamic> data = snapshot.data()!;

   String utilisateurId = data['idUtilisateur'];
   List<dynamic> listProduitsReferences = data['listExemplaires'];
   Timestamp? dateCreation = data['dateCreation'];
   bool activation = data['activation'];
   List<Future<Product?>> futures = [];

   //Parcours produits référencés et charger tt les données
   for (var productReference in listProduitsReferences) {
     if (listProduitsReferences.isNotEmpty) {
       // Ajouter chaque future à la liste de futures
       futures.add(ProductService().loadfullProduct(productReference.id));
     }
   }

   // Attendre que toutes les futures se terminent
   List<Product?> products = await Future.wait(futures);

   // Filtrer les produits non nulls
   List<Product> productList = products.where((product) => product != null).map((product) => product!).toList();

   return Cart(
     utilisateurId: utilisateurId,
     dateCreation: dateCreation,
     activation: activation,
     listProduits: productList,
   );
 }
}
