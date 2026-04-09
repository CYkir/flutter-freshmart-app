import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page_product.dart';
import 'page_create_product.dart';

class PageMainMenu extends StatelessWidget {
  const PageMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
            child: const Text('1. Pencarian Data'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PageProduct()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('2. Post Data'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PageCreateProduct()),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('3. Keluar'),
            onPressed: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
