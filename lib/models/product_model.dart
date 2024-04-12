
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/subcategory_model.dart';
import 'package:get_ready/services/subcategory_service.dart';
import '../services/brand_service.dart';
import 'brand_model.dart';

class Product{
  //propriétés
  final String? id;
  final String libelle;
  final String description;
  final String? brandId;
  final Brand? brand;
  final String? subCategoryId;
  final SubCategory? subCategory;
  final String? conseilUtilisation;
  final String mesure;
  final double prix;
  final List<dynamic> listIngredients;
  final bool? activation;
  //final int? nombre;
  //final DateTime? dateCreation;

  //constructeur
  Product({
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
    this.activation
      /*  this.nombre,
        this.dateCreation, */
      }
      );

  //méthodes
  static Future<Product?> fromMap(Map<String, dynamic> productMap) async {
    String? brandId = productMap['idMarque'].id;
    String? subCategoryId = productMap['idSousCategorie'].id;
    if (brandId == null) return null;
    // Charger les données de la marque
    Brand? brand = await BrandService.fetchBrandData(brandId);
    //Charger les données de la sous-catégorie
    SubCategory? subCategory = await SubCategoryService.fetchSubCategoryData(subCategoryId);

    return Product(
      libelle: productMap['libelle'],
      description: productMap['description'],
      listIngredients: productMap['listIngredients'],
      conseilUtilisation: productMap['conseilUtil'],
      mesure: productMap['mesure'],
      prix: productMap['prix'],
      activation: productMap['activation'],
      brand: brand,
      subCategory: subCategory,
      brandId: productMap['idMarque'].id,
      subCategoryId: productMap['idSousCategorie'].id,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'idMarque': brandId,
      'idSousCategorie' : subCategoryId,
      'conseilUtil': conseilUtilisation,
      'mesure': mesure,
      'prix': prix,
      'activation':activation,
      'listIngredients':listIngredients,
    };
  }
  factory Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    String id = snapshot.id;
    String? brandId = data['idMarque'].id;
    String? subCategoryId = data['idSousCategorie'].id;
    String libelle = data['libelle'];
    String description = data['description'];
    String conseilUtilisation = data['conseilUtil'];
    String mesure = data['mesure'];
    double prix = data['prix'];
    bool activation = data['activation'];
    List<dynamic> listIngredients = data['listIngredients'];

    return Product(
      id:id,
      libelle: libelle,
      description: description,
      brandId: brandId,
      subCategoryId: subCategoryId,
      conseilUtilisation: conseilUtilisation,
      mesure: mesure,
      prix:prix,
      activation:activation,
      listIngredients:listIngredients,
    );
  }
}