import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String libelle;
 // final Timestamp? dateCreation;
  //final bool? activation;
  Brand({
    required this.libelle,
    //this.dateCreation,
    //this.activation,
  });

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      //'dateCreation': dateCreation,
      //'activation': activation
    };
  }
  Brand.fromMap(Map<String, dynamic> brandMap) :
        libelle = brandMap['libelle'];
        //dateCreation = brandMap['dateCreation'],
        //activation = brandMap['activation'];

}