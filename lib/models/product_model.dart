import 'package:cloud_firestore/cloud_firestore.dart';

import 'brand_model.dart';


class Product{
  final String? id;
  final String libelle;
  final String description;
  //final Brand brand;

  Product(
      {
     this.id,
    required this.libelle,
    required this.description,
    //required this.brand
      }
      );

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'description': description,
    //  'brand': brand.toMap()
    };
  }

  factory Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      Map<String, dynamic> data = snapshot.data()!;

      return Product(
        libelle: data['libelle'],
        description: data['description'],
       // brand: Brand.fromMap(snapshot.data()!['libelle']),
      );
    }catch(e){
      throw e;
    }
  }
}