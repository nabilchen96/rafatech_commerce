// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_field, unused_element

import 'package:flutter/material.dart';

import 'list_produk.dart';
import 'order_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  //fungsi untuk merubah variabel index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Daftar Halaman
  final List<Widget> _pages = [
    ListProduk(), 
    OrderPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_selectedIndex],

        //membuat menu di bawah
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            //membuat nama-nama menu
            BottomNavigationBarItem(
              icon: Icon(Icons.home), //memberikan icon home
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment), //memberikan icon assignment
              label: 'Order',
            ),
          ],

          currentIndex: _selectedIndex, //index saat ini
          onTap: _onItemTapped, //fungsi yang dijalankan saat ditekan
        ),
      ),
    );
  }
}
