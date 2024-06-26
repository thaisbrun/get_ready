import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UtilisateurService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
   Future<Utilisateur?> getUserLinkToFirestore(String? refUserAuth) async {
    if (refUserAuth == null) return null;

    QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
        .collection('Utilisateurs')
        .where("refUserAuth", isEqualTo: refUserAuth) // Assurez-vous que la clé utilisateur est correcte
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // Utilisez le premier document trouvé
      DocumentSnapshot<Map<String, dynamic>> firstDoc = userSnapshot.docs.first;
      return Utilisateur.fromDocumentSnapshot(firstDoc);
    } else {
      return null; // Aucun utilisateur trouvé avec la clé donnée
    }   }
   updateUser(Utilisateur userData) async {
     await _db.collection("Utilisateurs").doc(userData.id).update(
         userData.toMap());

   }


}