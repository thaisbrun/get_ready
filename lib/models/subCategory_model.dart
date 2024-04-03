
class SubCategory{
  final String name;
 // final Category category;
  //final Timestamp dateCreation;
  //final bool activation;

  SubCategory({
    required this.name,
    //required this.category,
    //required this.dateCreation,
    //required this.activation,
  });

  Map<String, dynamic> toMap() {
    return {
      'libelle': name,
      //'idCategorie' : category,
      //'dateCreation' : dateCreation,
      //'activation' : activation
    };
  }
  SubCategory.fromMap(Map<String, dynamic> subCategoryMap) :
        name = subCategoryMap['libelle'];
        //category = subCategoryMap['idCategorie'],
        //dateCreation = subCategoryMap['dateCreation'],
        //activation = subCategoryMap['activation'];
}
