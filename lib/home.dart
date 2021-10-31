import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_lapang/akun_screen.dart';
import 'package:project_lapang/lapor_screen.dart';
import 'package:project_lapang/riwayat_laporan.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference laporan =
      FirebaseFirestore.instance.collection('laporan');
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  late String domisili;
  late String kelas;
  late String nama;
  late String nik;
  late String nomorHp;
  late String uid;

  var isPetugas = false;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: FutureBuilder(
            future: getUser(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //Mengambil data-data akun user
                domisili = snapshot.data!['domisili'].toString();
                nama = snapshot.data!['nama'].toString();
                nik = snapshot.data!['nik'].toString();
                nomorHp = snapshot.data!['nomor_hp'].toString();
                kelas = snapshot.data!['kelas'].toString();

                //Set variable petugas menjadi true jika kelasnya adalah petugas pada database.
                if (kelas == 'petugas') {
                  isPetugas = true;
                }

                //Kembalikan widget ListView untuk di build
                return ListView(shrinkWrap: true, children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(
                        minWidth: 300,
                        maxWidth: double.infinity,
                        minHeight: 80),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: atas(),
                  ),

                  //Menampilkan widget riwayat laporan
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: StreamBuilder<QuerySnapshot>(
                        //Buat snapshot untuk stream.
                        stream: laporan
                            .orderBy('tanggal_laporan', descending: true).where('uid', isEqualTo: uid)
                            .snapshots(),
                        //Build context dan snapshot yang telah dibuat dari stream
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              return Column(
                                  children: snapshot.data!.docs
                                      .map((e) => RiwayatLaporan(
                                            e['judul_laporan'],
                                            e['laporan'],
                                            e['uid'],
                                            e['tanggal_laporan'],
                                          ))
                                      .toList());
                            } else {
                              return const Text('NO DATA');
                            }
                          } else {
                            return const Text('Loading');
                          }
                        }),
                  ),
                ]);
              }

              //Kembalikan CircularProgressIndicator untuk dibuild jika koneksi belum selesai.
              return const Center(child: (CircularProgressIndicator()));
            }));
  }

  //Widget yang digunakan untuk membuild widget kotak atas dicek berdasarkan petugas atau bukan.
  Widget atas() {
    if (isPetugas) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          iconAtas(Icons.description_outlined, Colors.white, 50,
              'Lihat Laporan', AkunScreen(domisili, nama, nik, nomorHp, uid)),
          iconAtas(Icons.add_comment_outlined, Colors.white, 50,
              'Tambah Aduan Baru', LaporScreen(uid)),
          iconAtas(Icons.add_reaction_outlined, Colors.white, 50,
              'Tambah Petugas', LaporScreen(uid)),
          iconAtas(Icons.account_circle_outlined, Colors.white, 50, 'Akun',
              LaporScreen(uid)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        iconAtas(Icons.add_comment_outlined, Colors.white, 50,
            'Tambah Aduan Baru', LaporScreen(uid)),
        iconAtas(Icons.add_comment_outlined, Colors.white, 50, 'Akun',
            LaporScreen(uid)),
      ],
    );
  }

  //Widget yang digunakan untuk membuat widget di dalam kotak atas.
  Widget iconAtas(
      IconData? icon, var warna, double iconSize, String tooltip, var route) {
    return IconButton(
      icon: Icon(
        icon,
        color: warna,
      ),
      iconSize: iconSize,
      tooltip: tooltip,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => route,
            ));
      },
    );
  }

  Future<DocumentSnapshot> getUser() async {
    return await user.doc(uid).get();
  }
}
