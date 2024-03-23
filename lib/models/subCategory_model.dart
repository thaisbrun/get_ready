import 'package:get_ready/models/category_model.dart';

class SubCategory{
  final String name;
  final Category category;

  SubCategory({
    required this.name,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'libelle': name,
      'idCategorie' : category,
    };
  }
  SubCategory.fromMap(Map<String, dynamic> subCategoryMap) :
        name = subCategoryMap['libelle'],
        category = subCategoryMap['idCategorie'];
}
