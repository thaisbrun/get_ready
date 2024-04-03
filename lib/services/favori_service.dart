import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_ready/models/favs_models.dart';

class FavService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<List<Fav>> retrieveFavoris() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("Favoris").get();
      return snapshot.docs
          .map((docSnapshot) => Fav.fromDocumentSnapshot(docSnapshot))
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des favoris: $e");
      rethrow;
    }
  }

  addFav(Fav favData) async {
    await _db.collection("Favoris").add(favData.toMap());
    print("Le favori ajouté est ${favData.userId}, ${favData.productId}, ${favData.dateCreation}");
  }
}