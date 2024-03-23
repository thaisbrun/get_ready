class Order{
  final String adresseLivraison;
  final DateTime dateCommande;
  final double prixTotal;
  final int quantite;

  Order({
    required this.adresseLivraison,
    required this.dateCommande,
    required this.prixTotal,
    required this.quantite
  });

  factory Order.fromData(dynamic data) {
    return Order(adresseLivraison: data['adresseLivraison'],
        dateCommande: data['dateCommande'],
        prixTotal: data['prixTotal'],
        quantite: data['quantite']
    );
  }
}