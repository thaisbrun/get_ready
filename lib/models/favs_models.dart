
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/models/product_model.dart';

class Fav {
  final User user;
  final Product produit;
  final DateTime dateCreation;
  final bool activation;

  Fav({
    required this.user,
    required this.produit,
    required this.dateCreation,
    required this.activation
  });


  Map<String, dynamic> toMap() {
    return {
      'idUtilisateur': user,
      'idProduit': produit,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }

  Fav.fromMap(Map<String, dynamic> favMap) :
        user = favMap['idUtilisateur'],
        produit = favMap['idProduit'],
        dateCreation = favMap['dateCreation'],
        activation = favMap['activation'];
}