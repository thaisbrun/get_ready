
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  //propriétés
  final String libelle;
  final Timestamp dateCreation;
  final bool activation;
  //constructeur
  Category({
    required this.libelle,
    required this.dateCreation,
    required this.activation
  });
  //méthodes
  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }
  Category.fromMap(Map<String, dynamic> categoryMap) :
        libelle = categoryMap['libelle'],
        dateCreation = categoryMap['dateCreation'],
        activation = categoryMap['activation'];
}