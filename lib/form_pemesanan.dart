// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_final_fields, use_key_in_widget_constructors, unused_field, prefer_const_literals_to_create_immutables, non_constant_identifiernamas, avoid_print, must_be_immutable, unused_import, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'order_success.dart';

class FormPemesanan extends StatefulWidget {
  int id;
  String nama_product;
  String harga;

  //konstruktor
  FormPemesanan({
    required this.id,
    required this.nama_product,
    required this.harga,
  });

  @override
  _FormPemesananState createState() => _FormPemesananState();
}

class _FormPemesananState extends State<FormPemesanan> {

  //variabel ini igunakan dalam Flutter untuk mengidentifikasi dan mengendalikan status dari Form widget
  //variabel ini akan kita gunakan sebagai validasi form
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //TextEditingController kelas dalam Flutter yang digunakan untuk mengontrol dan memanipulasi teks yang dimasukkan oleh pengguna
  //class ini akan kita gunakan untuk menyimpan data yang diinput oleh pengguna
  TextEditingController namaController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  //fungsi saat kuantitas diisi
  calculateResult() {
    int number1 = int.tryParse(quantityController.text) ?? 0;
    int number2 = int.parse(widget.harga);
    return number1 * number2;
  }

  //fungsi untuk mengirim data
  sendOrder() async {
    //jika lolos validasi kirim data
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading =
            true; // Set isLoading menjadi true saat proses pengiriman dimulai
      });

      //url api
      var url = Uri.parse('https://rafatoko.airportslab.com/api/post-order');

      //data yang akan dikirim
      var data = {
        'product_id': widget.id.toString(),
        'nama': namaController.text,
        'no_wa': nomorController.text,
        'alamat': addressController.text,
        'jumlah': quantityController.text
      };

      //mengirim data
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        
        //notifikasi jika pengiriman berhasil
        var jsonData = jsonDecode(response.body);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccess(
            kode_order: jsonData['pesanan']['kode_order'], //kirim kode order
            harga: int.parse(quantityController.text) * int.parse(widget.harga), //kirim total harga pesanan
          )),
          ModalRoute.withName('/') //jika back kembali ke halaman depan, bukan kembali ke halaman order
        );
        
      } else {
        
        // Gagal mengirim data
        print('Gagal mengirim data. Error: ${response.reasonPhrase}');
      }

      setState(() {
        isLoading =
            false; // Set isLoading menjadi false setelah proses pengiriman selesai
      });
    }
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
          'Form Pemesanan',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: isLoading  
        ? Center(
          child: CircularProgressIndicator(),
        ) // Tampilkan CircularProgressIndicator jika isLoading adalah true
        :SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
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
                    'Harap melengkapi informasi anda melalui form di bawah ini dan pastikan data yang anda masukan sudah benar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                //membuat form nama produk
                TextFormField(
                  enabled: false, //form tidak dapat diedit
                  maxLines: 2, //menampilkan maksimal 2 baris
                  controller: TextEditingController(text: widget.nama_product),
                  decoration: InputDecoration(
                    labelText: 'Barang',
                  ),
                ),
                TextFormField(
                  enabled: false, //form tidak dapat diedit
                  controller: TextEditingController(
                      text: 'Rp ' + formatNumber(int.parse(widget.harga))),
                  decoration: InputDecoration(
                    labelText: 'Harga',
                  ),
                ),

                //membuat form nama pembeli
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Pembeli',
                  ),
                  //cara membuat validasi sederhana di flutter
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                //membuat form nomor wa
                TextFormField(
                  controller: nomorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nomor Whatsapp',
                  ),
                  //cara membuat validasi sederhana di flutter
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your whatsapp number';
                    }
                    return null;
                  },
                ),

                //membuat form alamat
                TextFormField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                  ),
                  //membuat validasi alamat
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),

                //membuat form kuantitas
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Kuantitas',
                  ),
                  //membuat validasi 
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Quantity';
                    }
                    return null;
                  },
                  //ubah state saat form diisi
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Total: ' + formatNumber(calculateResult()),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                //membuat button
                ElevatedButton(
                  onPressed: () {
                   sendOrder();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Pusatkan teks dan ikon secara horizontal
                    children: [
                      Text(
                          'Pesan Sekarang'), // Ganti dengan teks yang diinginkan
                      SizedBox(width: 6), // Jarak antara ikon dan teks
                      Icon(Icons
                          .shopping_bag_outlined), // Ganti dengan ikon yang diinginkan
                    ],
                  ),
                ),
              ],
            ),
          ),
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
