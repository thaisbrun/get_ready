class Brand {
  final String libelle;
  Brand({
    required this.libelle,
  });

  Map<String, dynamic> toMap() {
    return {
      'libelle': libelle,
    };
  }
  Brand.fromMap(Map<String, dynamic> brandMap) :
        libelle = brandMap['libelle'];
}