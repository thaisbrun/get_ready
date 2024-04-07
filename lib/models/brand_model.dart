import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
   String? id;
  final String libelle;
 // final Timestamp? dateCreation;
  //final bool? activation;
  Brand({
    this.id,
    required this.libelle,
    //this.dateCreation,
    //this.activation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'libelle': libelle,
      //'dateCreation': dateCreation,
      //'activation': activation
    };
  }
   factory Brand.fromSnapshot(DocumentSnapshot snapshot) {
     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
     return Brand(
       id: snapshot.id,
       libelle: data['libelle'] ?? '', // Supposons que le nom de la marque soit stocké sous la clé 'name'
     );
   }
  Brand.fromMap(Map<String, dynamic> brandMap) :

        libelle = brandMap['libelle'];
        //dateCreation = brandMap['dateCreation'],
        //activation = brandMap['activation'];
}