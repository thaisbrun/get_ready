class Category{
  final String libelle;

  Category({
    required this.libelle,
  });


  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
    };
  }
  Category.fromMap(Map<String, dynamic> subCategoryMap) :
        libelle = subCategoryMap['libelle'];
}