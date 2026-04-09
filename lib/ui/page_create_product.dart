import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:freshmart_app/services/Product_service.dart';
import 'package:freshmart_app/models/Kategori_model.dart';
import 'package:freshmart_app/services/category_service.dart';
import 'package:freshmart_app/params/product_param.dart';

class PageCreateProduct extends StatefulWidget {
  const PageCreateProduct({super.key});

  @override
  State<PageCreateProduct> createState() => _PageCreateProductState();
}

class _PageCreateProductState extends State<PageCreateProduct> {
  final _formKey = GlobalKey<FormState>();

  final ProductService _productRepo = ProductService();
  final CategoryService _categoryRepo = CategoryService();
  final ImagePicker _picker = ImagePicker();

  List<KategoriModel> _categories = [];
  KategoriModel? _selectedCategory;

  bool _loading = false;
  bool _loadingCategory = true;

  File? _imageFile;

  late TextEditingController nameCtrl;
  late TextEditingController brandCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController stockCtrl;
  late TextEditingController descCtrl;
  late TextEditingController bpomCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController();
    brandCtrl = TextEditingController();
    priceCtrl = TextEditingController();
    stockCtrl = TextEditingController();
    descCtrl = TextEditingController();
    bpomCtrl = TextEditingController();

    _loadCategories();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    brandCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
    bpomCtrl.dispose();
    super.dispose();
  }

  
  Future<void> _loadCategories() async {
    try {
      final res = await _categoryRepo.getAllCategory();

      setState(() {
        _categories = res.data;
        _loadingCategory = false;
      });
    } catch (e) {
      _loadingCategory = false;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memuat kategori')));
    }
  }

  
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kategori wajib dipilih')));
      return;
    }

    setState(() => _loading = true);

    final param = ProductParam(
      idKategori: _selectedCategory!.idKategori, 
      name: nameCtrl.text.trim(),
      brand: brandCtrl.text.trim(),
      price: int.parse(priceCtrl.text),
      stock: int.parse(stockCtrl.text),
      description: descCtrl.text.trim(),
      bpomNumber: bpomCtrl.text.isEmpty ? null : bpomCtrl.text.trim(),
    );

    try {
      await _productRepo.createProduct(
        param: param, 
        image: _imageFile,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menambah produk')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _imagePreview(),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar (Opsional)'),
              ),

              const SizedBox(height: 24),

              _input(nameCtrl, 'Nama Produk'),
              _input(brandCtrl, 'Brand'),
              _input(priceCtrl, 'Harga', number: true),
              _input(stockCtrl, 'Stok', number: true),
              _input(descCtrl, 'Deskripsi', maxLines: 3),
              _input(bpomCtrl, 'No BPOM (Opsional)', required: false),

              const SizedBox(height: 12),

              _loadingCategory
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<KategoriModel>(
                      initialValue: _selectedCategory,
                      items: _categories.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.namaKategori),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() => _selectedCategory = v);
                      },
                      validator: (v) =>
                          v == null ? 'Kategori wajib dipilih' : null,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Produk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _imagePreview() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _imageFile!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      height: 180,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.image, size: 80),
    );
  }

  Widget _input(
    TextEditingController ctrl,
    String label, {
    bool number = false,
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: (v) {
          if (!required) return null;
          if (v == null || v.isEmpty) return '$label wajib diisi';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
