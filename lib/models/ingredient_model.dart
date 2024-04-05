
import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String? id;
  final String libelle;
  final Timestamp dateCreation;
  final bool activation;

  Ingredient({
    this.id,
    required this.libelle,
    required this.dateCreation,
    required this.activation
  });


  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'libelle': libelle,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> ingredientMap) {
    return Ingredient(
      id: ingredientMap['id'],
      libelle: ingredientMap['libelle'],
      dateCreation: ingredientMap['dateCreation'],
      activation: ingredientMap['activation'],
    );
  }
factory Ingredient.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
Map<String, dynamic> data = snapshot.data()!;

String id = snapshot.reference.id;

// Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
String libelle = data['libelle'];
Timestamp dateCreation = data['dateCreation'];
bool activation = data['activation'];

return Ingredient(
id:id,
libelle: libelle,
dateCreation: dateCreation,
activation:activation,
);
}
}