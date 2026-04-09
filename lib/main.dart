import 'package:flutter/material.dart';
import 'package:freshmart_app/ui/page_main_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshMart App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromRGBO(18, 255, 2, 1)),
      ),
      home:  const PageMainMenu(),
      
    );
  }
}