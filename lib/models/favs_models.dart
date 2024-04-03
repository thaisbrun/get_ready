
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/models/product_model.dart';

class Fav {
  final String? userId;
  final String? productId;
  final User? user;
  final Product? produit;
  final Timestamp dateCreation;
  final bool activation;

  Fav({
    required this.userId,
    required this.productId,
    required this.dateCreation,
    required this.activation,
    this.user,
    this.produit,
  });


  Map<String, dynamic> toMap() {
    return {
      'idUtilisateur': userId,
      'idProduit': productId,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }

factory Fav.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
Map<String, dynamic> data = snapshot.data()!;

// Récupérer l'ID de référence du document Brand
String userId = data['idUtilisateur'].id;
String productId = data['idProduit'].id;
// Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
Timestamp dateCreation = data['dateCreation'];
bool activation = data['activation'];

return Fav(
  userId: userId,
  productId: productId,
  dateCreation: dateCreation,
  activation: activation
);
}
}