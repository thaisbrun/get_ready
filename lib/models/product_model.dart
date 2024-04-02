import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'brand_model.dart';

class Product{
  final String? id;
  final String libelle;
  final String description;
  final String? brandId;
  final Brand? brand; // Référence à un document Firestore
  final String? conseilUtilisation;
  final String mesure;
  final double prix;
  //final int? nombre;
 // final SubCategory? subCategory;
  //final List<Ingredient>? listIngredients;
  //final bool? activation;
  //final DateTime? dateCreation;

  Product(
      {
     this.id,
    required this.libelle,
    required this.description,
     this.brand,
        this.brandId,
        this.conseilUtilisation,
        required this.mesure,
        required this.prix,
      /*  this.nombre,
        this.subCategory,
        this.dateCreation,
        this.activation,
        this.listIngredients */
      }
      );

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'description': description,
      'idMarque': brandId, // Stocker l'ID de la référence
      'conseilUtil': conseilUtilisation,
      'mesure': mesure,
      'prix': prix,
    };
  }
  factory Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    // Récupérer l'ID de référence du document Brand
    String? brandId = data['idMarque'].id;

    // Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
    String libelle = data['libelle'];
    String description = data['description'];
    String conseilUtilisation = data['conseilUtil'];
    String mesure = data['mesure'];
    double prix = data['prix'];

    return Product(
      libelle: libelle,
      description: description,
      brandId: brandId,
      conseilUtilisation: conseilUtilisation,
      mesure: mesure,
      prix:prix,
    );
  }

}