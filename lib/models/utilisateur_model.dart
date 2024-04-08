
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  //propriétés
  final String prenom;
  final String nom;
  final String refUserAuth;
  final String telephone;
  String? mail;

//constructeur
Utilisateur({
  required this.prenom,
  required this.nom,
  required this.refUserAuth,
  required this.telephone,
  this.mail,
});

//méthodes
  factory Utilisateur.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
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

Utilisateur.fromMap(Map<String, dynamic> utilisateurMap) :
      prenom = utilisateurMap['prenom'],
      nom = utilisateurMap['nom'],
      refUserAuth = utilisateurMap['refUserAuth'],
      telephone = utilisateurMap['telephone'];
}