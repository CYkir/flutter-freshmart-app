class CategoryParam {
  final String? name;
  final String? code;
  final String? description;

  CategoryParam({this.name, this.code, this.description});

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'nama_kategori': name,
      if (code != null) 'kode_kategori': code,
      if (description != null) 'deskripsi': description,
    };
  }
}
