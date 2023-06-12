// ignore_for_file: prefer_const_constructors, unnecessary_this, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderSuccess extends StatelessWidget {
  String kode_order;
  int harga;

  //konstruktor
  OrderSuccess({
    required this.kode_order,
    required this.harga
  });

  //fungsi untuk copy kode_order
  void copyToClipboard(BuildContext context, String text) {
    //copy atau salin data
    Clipboard.setData(ClipboardData(text: text));

    //menampilkan notifikasi snackbar di bawah layar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Teks berhasil disalin')),
    );
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
          'Order Success',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Text(
                'Pesanan anda berhasil dibuat',
                style: TextStyle(fontSize: 22),
              ),
               SizedBox(height: 16,),
              Icon(
                Icons.shopping_cart,
                size: 150,
                color: Colors.blue,
              ),
              SizedBox(height: 10),
              Text(
                'Berikut nomor pesanan anda, anda dapat menggunakannya untuk melacak pesanan:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this.kode_order,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      //saat diklik akan mencopy tulisan
                      copyToClipboard(context, this.kode_order);
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Segera lakukan pembayaran \n sebesar Rp '+harga.toString()+' ke norek. 99XXXXX \n agar pesanan dapat segera diproses',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
