// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, avoid_print, dead_code, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController kodeOrderController = TextEditingController();

  fetchData() async {
    var url = Uri.parse(
        'https://rafatoko.airportslab.com/api/search-order'); // Ganti dengan URL endpoint Anda

    var response = await http.post(url, body: {
      'kode_order': kodeOrderController.text,
    });

    print(response.body);

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    //Scaffalod untuk menambahkan layar putih
    return Scaffold(
      //appbar adalah menu yang tampil di bagian atas
      appBar: AppBar(
        backgroundColor: Colors.white, //memberikan warna pada appbar

        //menambahkan judul pada appbar
        //Row digunakan untuk menampilkan 2 widget atau lebih secara horizontal
        title: Row(
          //properti ini berfungsi untuk membagi luas widget sama rata
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          //widget atau komponen di dalam Row disebut children
          children: [
            //menambahkan teks
            Text(
              'Sahre Shop',

              //memberikan style
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),

            //membuat icon
            Icon(Icons.shopify_outlined, color: Colors.black),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Masukkan kode pesanan anda di bawah ini untuk melacak proses pesanan anda',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: kodeOrderController,
                decoration: InputDecoration(
                  labelText: 'Kode Pesanan',
                ),
              ),
              SizedBox(height: 16.0),
              //button
              ElevatedButton(
                onPressed: () {
                  
                  //jangan lupa menambahkan setState
                  //agar terjadi perubahan
                  setState(() {

                    //metod yg akan dijalankan saat tombol diklik
                    fetchData();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Pusatkan teks dan ikon secara horizontal
                  children: [
                    Text('Cari Pesanan'), // Ganti dengan teks yang diinginkan
                    SizedBox(width: 6), // Jarak antara ikon dan teks
                    Icon(Icons
                        .shopping_bag_outlined), // Ganti dengan ikon yang diinginkan
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),

              FutureBuilder(
                future: fetchData(), //metode yg dijalankan
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // Tampilkan indikator loading jika masih memuat data
                  } else {
                    var data = snapshot.data as Map<String, dynamic>;

                    if (data['success'] == true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //kode pesanan
                          Text(
                            'Kode Pesanan',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['kode_order']),
                          SizedBox(
                            height: 10,
                          ),

                          //nama produk
                          Text(
                            'Nama Produk',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['nama_product']),
                          SizedBox(
                            height: 10,
                          ),

                          //nama customer
                          Text(
                            'Nama Pembeli',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['nama']),
                          SizedBox(
                            height: 10,
                          ),

                          //No WA
                          Text(
                            'Nomor WA',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['no_wa']),
                          SizedBox(
                            height: 10,
                          ),

                          //Alamat
                          Text(
                            'Alamat',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['alamat']),
                          SizedBox(
                            height: 10,
                          ),

                          //jumlah
                          Text(
                            'Jumlah',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['jumlah']),
                          SizedBox(
                            height: 10,
                          ),

                          //status
                          Text(
                            'Status', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(data['order']['status']),
                          SizedBox(height: 10,),

                          //total harga
                          Text(
                            'Total Harga', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('Rp '+formatNumber(int.parse(data['order']['total_harga']))),
                          SizedBox(height: 10,),
                        ],
                      );
                    } else {
                      return Center(child: Text('Belum Ada Data'));
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

//fungsi untuk membuat nomor memiliki koma atau titik
String formatNumber(int price) {
  String formattedNumber = price.toString();
  final RegExp regEx = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  formattedNumber =
      formattedNumber.replaceAllMapped(regEx, (Match match) => '${match[1]},');
  return formattedNumber;
}
