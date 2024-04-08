
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/models/product_model.dart';

class Fav {

  //propriétés
  final String? id;
  final String? userId;
  final String? productId;
  final User? user;
  final Product? produit;
  final Timestamp dateCreation;
  final bool activation;

  //constructeur
  Fav({
    this.id,
    required this.userId,
    required this.productId,
    required this.dateCreation,
    required this.activation,
    this.user,
    this.produit,
  });

  //méthodes
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'idUtilisateur': userId,
      'idProduit': productId,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }

factory Fav.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
Map<String, dynamic> data = snapshot.data()!;
String id = snapshot.reference.id;
String userId = data['idUtilisateur'];
String productId = data['idProduit'];
Timestamp dateCreation = data['dateCreation'];
bool activation = data['activation'];

return Fav(
  id:id,
  userId: userId,
  productId: productId,
  dateCreation: dateCreation,
  activation: activation
);
}
}