import 'package:get_ready/models/product_model.dart';

class Image {
  //proprietes
  final String lienImage;
  final Product produit;
  final DateTime dateCreation;
  final bool activation;

  //constructeur
  Image({
    required this.lienImage,
    required this.produit,
    required this.dateCreation,
    required this.activation
  });

  //methodes
  Map<String, dynamic> toMap() {
    return {
      'lienImage': lienImage,
      'produit': produit,
      'dateCreation': dateCreation,
      'activation': activation
    };
  }

  Image.fromMap(Map<String, dynamic> imageMap) :
        lienImage = imageMap['lienImage'],
        produit = imageMap['idProduit'],
      dateCreation = imageMap['dateCreation'],
        activation = imageMap['activation'];
}