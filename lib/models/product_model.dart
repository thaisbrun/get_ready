class Product{
  final String libelle;
  final String description;

  Product({
    required this.libelle,
    required this.description
  });

  factory Product.fromData(dynamic data) {
    return Product(libelle: data['libelle'], description: data['description']);
  }
}