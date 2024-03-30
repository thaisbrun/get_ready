import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_ready/models/product_model.dart';

/*
class Cart {
  final int prixTotal;
  final List<Product>? listProduits;
  final User utilisateur;
  final DateTime? dateCreation;
  final bool activation;

  Cart({
    required this.prixTotal,
    this.listProduits,
    this.dateCreation,
    required this.utilisateur,
    required this.activation
  });

  Map<String, dynamic> toMap() {
    return {
      'prixTotal': prixTotal,
      'idUtilisateur' : utilisateur,
      'listExemplaires': listProduits,
      'dateCreation': dateCreation,
      'activation': activation,
    };
  }
  Cart.fromMap(Map<String, dynamic> cartMap) :
        prixTotal = cartMap['prixTotal'],
        listProduits = cartMap['listExemplaires'],
        utilisateur = cartMap['idUtilisateur'],
      dateCreation = cartMap['dateCreation'],
      activation = cartMap['activation'];
}
*/