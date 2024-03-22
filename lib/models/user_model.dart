class User {
  final String prenom;
  final String nom;
  final String mail;
  final int telephone;
  final String adressePostale;

  User({
    required this.prenom,
    required this.nom,
    required this.mail,
    required this.telephone,
    required this.adressePostale,
  });

  factory User.fromData(dynamic data) {
    return User(prenom: data['prenom'],
        nom: data['nom'],
        mail: data['mail'],
        telephone: data['telephone'],
        adressePostale: data['adressePostale'],
    );
  }
}