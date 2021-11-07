import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_lapang/list_laporan.dart';

class LihatLaporanScreen extends StatefulWidget {
  final String uidPetugas;
  const LihatLaporanScreen(this.uidPetugas, {Key? key}) : super(key: key);

  @override
  _LihatLaporanScreenState createState() => _LihatLaporanScreenState();
}

class _LihatLaporanScreenState extends State<LihatLaporanScreen> {
  final CollectionReference laporan =
      FirebaseFirestore.instance.collection('laporan');
  @override
  Widget build(BuildContext context) {
    return returnLihatLaporanScreen(context);
  }

  returnLihatLaporanScreen(context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Laporan Warga')),
        body: ListView(children: [
          StreamBuilder<QuerySnapshot>(
            stream: laporan
                .orderBy('tanggal_laporan', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data!.docs
                          .map<Widget>(
                            (e) => listLaporan(
                                judul: e['judul_laporan'],
                                isiLaporan: e['laporan'],
                                image: e['image'],
                                timeLaporan: e['tanggal_laporan'],
                                uid: e['uid'],
                                laporanId: e['laporanId']),
                          )
                          .toList());
                }
                return const Center(child: Text('No Data'));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ]));
  }
}
