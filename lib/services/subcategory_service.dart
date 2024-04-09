import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subcategory_model.dart';

class SubCategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<SubCategory>> retrieveSubcategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("SousCategories").get();
      return snapshot.docs
          .map((docSnapshot) => SubCategory.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des sous-catégories: $e");
      rethrow;
    }
  }
  static Future<SubCategory?> fetchSubCategoryData(String? subCategoryId) async {
    if (subCategoryId == null) return null;

    DocumentSnapshot<Map<String, dynamic>> subCategorySnapshot = await FirebaseFirestore.instance
        .collection('SousCategories')
        .doc(subCategoryId)
        .get();

    if (subCategorySnapshot.exists) {
      return SubCategory.fromMap(subCategorySnapshot.data()!);
    } else {
      return null;
    }
  }

}