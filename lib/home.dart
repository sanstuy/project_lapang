import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_lapang/akun_screen.dart';
import 'package:project_lapang/lihat_laporan_screen.dart';
import 'package:project_lapang/lapor_screen.dart';
import 'package:project_lapang/riwayat_laporan_screen.dart';
import 'package:project_lapang/tambah_petugas_screen.dart';

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
                return ListView(children: [
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
                            .orderBy('tanggal_laporan', descending: true)
                            .where('uid', isEqualTo: uid)
                            .snapshots(),
                        //Build context dan snapshot yang telah dibuat dari stream
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.data == null ||
                                snapshot.data!.docs.isEmpty) {
                              return Column(children: [
                                const Text(
                                  'Aduan kamu masih kosong',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Image.asset('images/empty.png')
                              ]);
                            } else {
                              return Column(
                                  children: snapshot.data!.docs
                                      .map((e) => riwayatLaporan(
                                            judul: e['judul_laporan'],
                                            isiLaporan: e['laporan'],
                                            timeLaporan: e['tanggal_laporan'],
                                            laporanId: e['laporanId'],
                                          ))
                                      .toList());
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
      return SizedBox(
        width: 300,
        height: 100,
        child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  iconAtas(Icons.description_outlined, Colors.white, 40,
                      'Lihat Laporan', LihatLaporanScreen(uid, false)),
                  iconAtas(Icons.fact_check_outlined, Colors.white, 40,
                      'Laporan Telah Dibalas', LihatLaporanScreen(uid, true)),
                  iconAtas(Icons.add_comment_outlined, Colors.white, 40,
                      'Tambah Aduan Baru', LaporScreen(uid)),
                  iconAtas(Icons.add_reaction_outlined, Colors.white, 40,
                      'Tambah Petugas', const TambahPetugasScreen()),
                  iconAtas(Icons.account_circle_outlined, Colors.white, 40,
                      'Akun', AkunScreen(domisili, nama, nik, nomorHp, uid)),
                ],
              ),
            ]),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        iconAtas(Icons.add_comment_outlined, Colors.white, 40,
            'Tambah Aduan Baru', LaporScreen(uid)),
        iconAtas(Icons.account_circle_outlined, Colors.white, 50, 'Akun',
            AkunScreen(domisili, nama, nik, nomorHp, uid)),
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

  Widget riwayatLaporan(
      {String? judul,
      String? isiLaporan,
      Timestamp? timeLaporan,
      String? laporanId}) {
    DateTime dateLaporan = timeLaporan!.toDate();
    return Builder(builder: (context) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RiwayatLaporanScreen(laporanId!)),
            );
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                Text(isiLaporan!,
                    style: const TextStyle(
                      fontSize: 15,
                    )),
                Text(
                  dateLaporan.toString(),
                  style: const TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
