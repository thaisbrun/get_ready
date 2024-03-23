import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addProduct(Product productData) async {
    await _db.collection("Produits").add(productData.toMap());
  }

  updateProduct(Product productData) async {
     await _db.collection("Produits").doc(productData.id).update(productData.toMap());
  }

  Future<void> deleteProduct(String documentId) async {
    await _db.collection("Produits").doc(documentId).delete();
  }

  Future<List<Product>> retrieveProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Produits").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}