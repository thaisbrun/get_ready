class Brand {
  final String libelle;
  Brand({
    required this.libelle,
  });

  factory Brand.fromData(dynamic data) {
    return Brand(libelle: data['libelle']);
  }
}