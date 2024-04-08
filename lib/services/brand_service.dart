import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/brand_model.dart';

class BrandService{
  static Future<Brand?> fetchBrandData(String? brandId) async {
    if (brandId == null) return null;

    DocumentSnapshot<Map<String, dynamic>> brandSnapshot = await FirebaseFirestore.instance
        .collection('Marques')
        .doc(brandId)
        .get();

    if (brandSnapshot.exists) {
      return Brand.fromMap(brandSnapshot.data()!);
    } else {
      return null;
    }
  }

}