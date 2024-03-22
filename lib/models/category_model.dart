class Category{
  final String libelle;
  Category({
    required this.libelle,
  });

  factory Category.fromData(dynamic data) {
    return Category(libelle: data['libelle']);
  }
}