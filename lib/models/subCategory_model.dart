
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategory{
    String? id;
  final String name;
 // final Category category;
  //final Timestamp dateCreation;
  //final bool activation;

  SubCategory({
    this.id,
    required this.name,
    //required this.category,
    //required this.dateCreation,
    //required this.activation,
  });



   factory SubCategory.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    String id = snapshot.reference.id;
    // Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
    String libelle = data['libelle'];

    return SubCategory(
      id:id,
      name: libelle,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'libelle': name,
      //'idCategorie' : category,
      //'dateCreation' : dateCreation,
      //'activation' : activation
    };
  }
  SubCategory.fromMap(Map<String, dynamic> subCategoryMap) :
        name = subCategoryMap['libelle'];
        //category = subCategoryMap['idCategorie'],
        //dateCreation = subCategoryMap['dateCreation'],
        //activation = subCategoryMap['activation'];
}
