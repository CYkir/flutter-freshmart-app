class ProductModel {
  final int id;
  final String name;
  final int idKategori;
  final String brand;
  final double price;
  final String description;
  final int stock;
  final String bpomNumber;
  final String? imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.idKategori,
    required this.brand,
    required this.price,
    required this.description,
    required this.stock,
    required this.bpomNumber,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),

      name: json['name'] ?? '',

      
      idKategori: json['kategori'] != null
          ? int.parse(json['kategori']['id_kategori'].toString())
          : 0,

      brand: json['brand'] ?? '',

      price: json['price'] is double
          ? json['price']
          : double.parse(json['price'].toString()),

      description: json['description'] ?? '',

      stock: json['stock'] is int
          ? json['stock']
          : int.parse(json['stock'].toString()),

      bpomNumber: json['bpom_number'] ?? '',

      imageUrl: json['image_url'],
    );
  }
}
