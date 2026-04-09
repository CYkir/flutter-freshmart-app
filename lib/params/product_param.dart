class ProductParam {
  final int idKategori;
  final String name;
  final String brand;
  final int price;
  final int stock;
  final String description;
  final String? bpomNumber;

  ProductParam({
    required this.idKategori,
    required this.name,
    required this.brand,
    required this.price,
    required this.stock,
    required this.description,
    this.bpomNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'name': name,
      'brand': brand,
      'price': price,
      'stock': stock,
      'description': description,
      'bpom_number': bpomNumber,
    };
  }
}
