import 'brand_model.dart';

class Product{
  final String libelle;
  final String description;
 // final Brand brand;
  Product({
    required this.libelle,
    required this.description,
  //  required this.brand
  });

  factory Product.fromData(dynamic data) {
    return Product(libelle: data['libelle'], description: data['description'],
        //brand: data['idMarque']
        );
  }
}