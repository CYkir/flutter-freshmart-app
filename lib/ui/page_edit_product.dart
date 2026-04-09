import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freshmart_app/params/product_param.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:freshmart_app/models/Product_model.dart';
import 'package:freshmart_app/services/Product_service.dart';

class PageEditProduct extends StatefulWidget {
  final ProductModel product;

  const PageEditProduct({super.key, required this.product});

  @override
  State<PageEditProduct> createState() => _PageEditProductState();
}

class _PageEditProductState extends State<PageEditProduct> {
  final _repo = ProductService();
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  File? _imageFile;

  late TextEditingController nameCtrl;
  late TextEditingController brandCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;
  late TextEditingController stockCtrl;
  late TextEditingController bpomCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    nameCtrl = TextEditingController(text: p.name);
    brandCtrl = TextEditingController(text: p.brand);
    priceCtrl = TextEditingController(text: p.price.toString());
    descCtrl = TextEditingController(text: p.description);
    stockCtrl = TextEditingController(text: p.stock.toString());
    bpomCtrl = TextEditingController(text: p.bpomNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _imagePreview(),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Ganti Gambar'),
              ),
              const SizedBox(height: 20),
              _input(nameCtrl, 'Nama Produk'),
              _input(brandCtrl, 'Brand'),
              _input(priceCtrl, 'Harga', isNumber: true),
              _input(stockCtrl, 'Stok', isNumber: true),
              _input(bpomCtrl, 'BPOM (Opsional)', required: false),
              _input(descCtrl, 'Deskripsi', maxLine: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan Perubahan'),
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

    if (widget.product.imageUrl != null &&
        widget.product.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: widget.product.imageUrl!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
        ),
      );
    }

    return Container(
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      child: const Icon(Icons.image, size: 80),
    );
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Widget _input(
    TextEditingController c,
    String label, {
    bool isNumber = false,
    int maxLine = 1,
    bool required = true,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: maxLine,
        keyboardType: isNumber
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) {
          if (!required) return null;
          if (v == null || v.isEmpty) return '$label wajib diisi';
          return null;
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final param = ProductParam(
      idKategori: widget.product.idKategori, 
      name: nameCtrl.text.trim(),
      brand: brandCtrl.text.trim(),
      price: int.parse(priceCtrl.text),
      stock: int.parse(stockCtrl.text),
      description: descCtrl.text.trim(),
      bpomNumber: bpomCtrl.text.isEmpty ? null : bpomCtrl.text.trim(),
    );

    try {
      await _repo.updateProduct(
        id: widget.product.id,
        param: param, 
        image: _imageFile,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

}
