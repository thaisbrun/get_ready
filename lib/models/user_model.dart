
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  //propriétés
  String? id;
   String? prenom;
   String? nom;
   String? refUserAuth;
   String? telephone;
  String? mail;

//constructeur
Utilisateur({
  this.id,
   this.prenom,
   this.nom,
   this.refUserAuth,
   this.telephone,
  this.mail,
});

//méthodes
  factory Utilisateur.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    String id = snapshot.reference.id;
    String prenom = data['prenom'];
    String nom = data['nom'];
    String telephone = data['telephone'];
    String refUserAuth = data['refUserAuth'];

    return Utilisateur(
      id:id,
      prenom: prenom,
      nom: nom,
      refUserAuth: refUserAuth,
      telephone: telephone,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'prenom' : prenom,
      'nom': nom,
      'refUserAuth': refUserAuth,
      'telephone': telephone,
    };
  }

Utilisateur.fromMap(Map<String, dynamic> utilisateurMap) :
      prenom = utilisateurMap['prenom'],
      nom = utilisateurMap['nom'],
      refUserAuth = utilisateurMap['refUserAuth'],
      telephone = utilisateurMap['telephone'];
}
