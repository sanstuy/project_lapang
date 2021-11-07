import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_lapang/balas_screen.dart';
import 'package:project_lapang/riwayat_laporan_screen.dart';

Widget listLaporan(
    {String? judul,
    String? isiLaporan,
    String? image,
    Timestamp? timeLaporan,
    String? uid,
    String? laporanId}) {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  DateTime tanggal = timeLaporan!.toDate();
  var dateTime = DateTime.parse(tanggal.toString());
  var dmyformat = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  String uidPetugas = FirebaseAuth.instance.currentUser!.uid;
  late String? namaPelapor;
  late String? domisiliPelapor;

  return StreamBuilder<QuerySnapshot>(
      stream: users.where('uid', isEqualTo: uid).snapshots(),
      builder: (context, snapshot) {
        namaPelapor = snapshot.data?.docs[0].get('nama').toString();
        domisiliPelapor = snapshot.data?.docs[0].get('domisili').toString();
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: MediaQuery.of(context).size.width * 0.1),
          // padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 3,
                  blurRadius: 1.5,
                  offset: const Offset(0, 7),
                )
              ]),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BalasScreen(
                            judul!,
                            isiLaporan!,
                            image!,
                            timeLaporan,
                            uid!,
                            uidPetugas,
                            namaPelapor.toString(),
                            domisiliPelapor.toString(),
                            laporanId!)));
              },
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          judul!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    const Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pelapor : ${namaPelapor.toString()}\nDomisili :\n${domisiliPelapor.toString()}',
                              // snapshot.data!['nama'].toString(),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            'Tanggal Laporan \n $dmyformat',
                            style: const TextStyle(fontSize: 13),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                  ],
                ),
              )),
        );
      });
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
