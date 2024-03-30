import 'package:flutter/foundation.dart';

class Ingredient {
  final String libelle;
  final DateTime dateCreation;
  final bool activation;

  Ingredient({
    required this.libelle,
    required this.dateCreation,
    required this.activation
  });


  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }

  Ingredient.fromMap(Map<String, dynamic> categoryMap) :
        libelle = categoryMap['libelle'],
        dateCreation = categoryMap['dateCreation'],
        activation = categoryMap['activation'];
}