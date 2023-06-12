// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_print, non_constant_identifier_names, unnecessary_this, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rafatech_commerce/detail_produk.dart';

class ListProduk extends StatefulWidget {
  @override
  State<ListProduk> createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  //fungsi untuk mendapatkan data dari internet
  getData() async {
    //get data
    var dataJson = await http
        .get(Uri.parse('https://rafatoko.airportslab.com/api/list-product'));

    // memiliki fungsi untuk menguraikan string JSON
    var map = jsonDecode(dataJson.body);

    //lalu simpan sebagai object
    List<dynamic> data = map["product"];

    //menampilkan data
    print(data);

    //kembalikan nilai data
    return data;
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
              Icon(Icons.shopify, color: Colors.black),
            ],
          ),
        ),
        body: FutureBuilder(
          //metode yang dijalankan
          future: getData(),
          builder: (_, snapshot) {
            //cek apakah proses sudah selesai atau belum
            //jika proses selesai jalankan baris di bawah ini
            if (snapshot.connectionState == ConnectionState.done) {
              var list = snapshot.data as List;

              //widget untuk membuat tampilan grid
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // banyak grid yang ditampilkan dalam satu baris
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),

                  //total data
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    //widget yang akan kita isi sesuai dengan keinginan kita
                    return CustomCard(
                      id: list[index]['id'],
                      nama_product: list[index]['nama_product'],
                      gambar: 'https://rafatoko.airportslab.com/storage/' +
                          list[index]['gambar'],
                      kategori: list[index]['kategori'],
                      deskripsi: list[index]['deskripsi'],
                      harga: list[index]['harga'],
                    );
                  });
            } else {
              //jika proses belum selesai tetap tampilkan indikator
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

//membuat customcard yang bisa kita panggil setiap kali dibutuhkan
class CustomCard extends StatelessWidget {
  //inisiasi variabel
  int id;
  String nama_product;
  String gambar;
  String kategori;
  String deskripsi;
  String harga;

  //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
  //parameter ini akan mengisi data pada setiap card
  CustomCard({
    required this.id,
    required this.nama_product,
    required this.gambar,
    required this.kategori,
    required this.deskripsi,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: () {
        // Navigasi ke halaman baru saat Card diklik
        Navigator.push(
          context,
          MaterialPageRoute(
              //menuju halaman selanjutnya dengan membawa parameter
              //parameter ini akan ditampilkan lagi jadi tidak perlu memanggil api
              builder: (context) => DetailProduk(
                    id: this.id,
                    nama_product: this.nama_product,
                    gambar: this.gambar,
                    deskripsi: this.deskripsi,
                    kategori: this.kategori,
                    harga: this.harga
              )
          ),
        );
      },

      child: Card(
        //column adalah widget yang dapat menampung banyak widget atau componen di dalamnya secara vertikal
        child: Column(
          //semua posisi widget di dalam column di mulai dari kiri atau start
          crossAxisAlignment: CrossAxisAlignment.start,
    
          //komponen atau widget di column
          children: [
            //cara menampilkan dari internet
            Container(
              height: 150, //tinggi gambar
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: NetworkImage(gambar),
                fit: BoxFit
                    .cover, //gambar akan ditampilan penuh, mungkin ada yang terpotong
                
              ),
            ),
            Padding(
              //jarak
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //menampilkan nama produk
                  Text(nama_product,
                      //memberikan style atau gaya
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                      maxLines:
                          2, //panjang maksimal teks adalah 2 baris, selebihnya tidak ditampilkan
                      overflow: TextOverflow
                          .ellipsis), //jika terpotong maka akan menampilkan titik-titik
                  SizedBox(height: 4.0), //widget untuk memberikan jarak
    
                  //menampilkan nama kategori
                  Text(
                    this.kategori,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
    
                  //menampilkan harga
                  //formatNumber membuat nomor memiliki koma atau titik agar mudah dibaca
                  Text(
                    'Rp ' + formatNumber(int.parse(this.harga)),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //fungsi untuk membuat nomor memiliki koma atau titik
  String formatNumber(int price) {
    String formattedNumber = price.toString();
    final RegExp regEx = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    formattedNumber = formattedNumber.replaceAllMapped(
        regEx, (Match match) => '${match[1]},');
    return formattedNumber;
  }
}
