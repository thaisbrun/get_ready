import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/subCategory_model.dart';

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

}