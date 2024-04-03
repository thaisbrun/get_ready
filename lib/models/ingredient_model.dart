

class Ingredient {
  final String? id;
  final String libelle;
  final DateTime dateCreation;
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

  Ingredient.fromMap(Map<String, dynamic> categoryMap) :
      id = categoryMap['id'],
        libelle = categoryMap['libelle'],
        dateCreation = categoryMap['dateCreation'],
        activation = categoryMap['activation'];
}