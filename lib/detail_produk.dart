// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, unused_field, prefer_final_fields, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rafatech_commerce/form_pemesanan.dart';

class DetailProduk extends StatefulWidget {

  int id;
  String nama_product;
  String gambar;
  String kategori;
  String deskripsi;
  String harga;

  //konstruktor
  DetailProduk({
    required this.id,
    required this.nama_product,
    required this.gambar,
    required this.kategori,
    required this.deskripsi,
    required this.harga,
  });
  
  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulasikan waktu penundaan untuk memuat gambar
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // Ganti dengan warna yang diinginkan
        ),
        title: Text(
          'Detail Produk',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      //jika widget yang dimuat dalam sebuah screen overflow
      //maka dengan SingleChildScrollView layar bisa discroll ke bawah
      body: SingleChildScrollView(
        //Column adalah widget yang dapat menampung banyak widget di dalamnya secara vertikal
        child: Column(
          //semua widget dimulai dari kiri
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              //menampilkan gambar dengan tinggi 250
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width, //max width smartphone atau device
                child: Image.network(
                  widget.gambar, 
                  fit: BoxFit.cover, //ukuran gambar memenuhi layar
                ),
              ),

            //padding berfungsi untuk memberikan jarak
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nama_product,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.kategori,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rp. ' + formatNumber(int.parse(widget.harga)),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  //HTML adalah package yang digunakan untuk memformat html menjadi teks yang bisa dibaca
                  Html(data: widget.deskripsi),
                  
                  SizedBox(height: 16),

                  //membuat button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        // DetailPage adalah halaman yang dituju
                        MaterialPageRoute(builder: (context) => FormPemesanan(
                          id: widget.id,
                          nama_product: widget.nama_product,
                          harga: widget.harga
                        )),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Pusatkan teks dan ikon secara horizontal
                      children: [
                        Text(
                            'Beli Sekarang'), // Ganti dengan teks yang diinginkan
                        SizedBox(width: 6), // Jarak antara ikon dan teks
                        Icon(Icons
                            .shopping_bag_outlined), // Ganti dengan ikon yang diinginkan
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatNumber(int price) {
    String formattedNumber = price.toString();
    final RegExp regEx = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    formattedNumber = formattedNumber.replaceAllMapped(
        regEx, (Match match) => '${match[1]},');
    return formattedNumber;
  }
}