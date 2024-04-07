
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  final String prenom;
final String nom;
final String refUserAuth;
final String telephone;
String? mail;

Utilisateur({
required this.prenom,
  required this.nom,
  required this.refUserAuth,
  required this.telephone,
  this.mail,
});
  factory Utilisateur.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    // Utiliser l'ID de référence pour créer une instance de Product sans le champ brand pour l'instant
    String prenom = data['prenom'];
    String nom = data['nom'];
    String telephone = data['telephone'];
    String refUserAuth = data['refUserAuth'];

    return Utilisateur(
      prenom: prenom,
      nom: nom,
      refUserAuth: refUserAuth,
      telephone: telephone,
    );
  }

Utilisateur.fromMap(Map<String, dynamic> brandMap) :
      prenom = brandMap['prenom'],
      nom = brandMap['nom'],
      refUserAuth = brandMap['refUserAuth'],
      telephone = brandMap['telephone'];
}
