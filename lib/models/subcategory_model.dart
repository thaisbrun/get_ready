
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategory{

  //propriétés
    String? id;
  final String name;
  //final Category category;
  //final Timestamp dateCreation;
  //final bool activation;

    //constructeur
  SubCategory({
    this.id,
    required this.name,
    //required this.category,
    //required this.dateCreation,
    //required this.activation,
  });

  //méthodes
   factory SubCategory.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    String id = snapshot.reference.id;
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
