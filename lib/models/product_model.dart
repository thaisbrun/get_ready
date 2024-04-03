
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/subCategory_model.dart';
import 'brand_model.dart';
import 'ingredient_model.dart';

class Product{
  final String? id;
  final String libelle;
  final String description;
  final String? brandId;
  final Brand? brand; // Référence à un document Firestore
  final String? subCategoryId;
  final SubCategory? subCategory;
  final String? conseilUtilisation;
  final String mesure;
  final double prix;
  //final int? nombre;
  final List<Ingredient> listIngredients;
  //final bool? activation;
  //final DateTime? dateCreation;

  Product(
      {
     this.id,
    required this.libelle,
    required this.description,
        required this.listIngredients,
     this.brand,
        this.brandId,
        this.conseilUtilisation,
        required this.mesure,
        required this.prix,
        this.subCategoryId,
        this.subCategory,
      /*  this.nombre,
        this.subCategory,
        this.dateCreation,
        this.activation */
      }
      );

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
      'description': description,
      'idMarque': brandId, // Stocker l'ID de la référence
      'idSousCategorie' : subCategoryId,
      'conseilUtil': conseilUtilisation,
      'mesure': mesure,
      'prix': prix,
     'listIngredients': listIngredients,
    };
  }
  factory Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    String id = snapshot.reference.id;
    // Récupérer l'ID de référence du document Brand
    String? brandId = data['idMarque'].id;
    String? subCategoryId = data['idSousCategorie'].id;
    // Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
    String libelle = data['libelle'];
    String description = data['description'];
    String conseilUtilisation = data['conseilUtil'];
    String mesure = data['mesure'];
    double prix = data['prix'];
    // Convertir la liste d'ingrédients
    List<dynamic> ingredientsData = data['listIngredients'];
    List<Ingredient> listIngredients = ingredientsData.map((ingredientData) => Ingredient.fromMap(ingredientData)).toList();


    return Product(
      id:id,
      libelle: libelle,
      description: description,
      brandId: brandId,
      subCategoryId: subCategoryId,
      conseilUtilisation: conseilUtilisation,
      mesure: mesure,
      prix:prix,
       listIngredients:listIngredients,
    );
  }

}