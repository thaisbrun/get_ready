import 'package:cloud_firestore/cloud_firestore.dart';

import 'brand_model.dart';


class Product{
  final String? id;
  final String libelle;
  final String description;
  final Brand brand;

  Product(
      {
     this.id,
    required this.libelle,
    required this.description,
    required this.brand}
      );

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'description': description,
      'brand': brand.toMap()
    };
  }

  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) :
    id = doc.id,
    libelle = doc.data()!['libelle'],
    description= doc.data()!['description'],
    brand=Brand.fromMap(doc.data()!['libelle']);
}