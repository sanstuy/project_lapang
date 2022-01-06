import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_lapang/download_pdf.dart';
import 'balas_screen.dart';

class LihatLaporanScreen extends StatefulWidget {
  final String uidPetugas;
  final bool isLihatLaporanTelahDiBalas;
  const LihatLaporanScreen(this.uidPetugas, this.isLihatLaporanTelahDiBalas,
      {Key? key})
      : super(key: key);

  @override
  _LihatLaporanScreenState createState() => _LihatLaporanScreenState();
}

class _LihatLaporanScreenState extends State<LihatLaporanScreen> {
  final CollectionReference laporan =
      FirebaseFirestore.instance.collection('laporan');
  late String title;
  DateTime? firstSelectedDate;
  DateTime? secondSelectedDate;

  @override
  void initState() {
    if (widget.isLihatLaporanTelahDiBalas) {
      title = 'Telah Dibalas';
    } else {
      title = 'Laporan Warga';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return returnLihatLaporanScreen(context);
  }

  returnLihatLaporanScreen(context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: [
          Expanded(child: Text(title)),
          if (widget.isLihatLaporanTelahDiBalas)
            IconButton(
                onPressed: () {
                  selectDate();
                },
                icon: const Icon(Icons.download_for_offline_outlined))
        ])),
        body: ListView(children: [
          StreamBuilder<QuerySnapshot>(
            stream: laporan
                .where('sudahDiBalas',
                    isEqualTo: widget.isLihatLaporanTelahDiBalas)
                .orderBy('tanggal_laporan', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum ada laporan dari masyarakat',
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.asset('images/empty.png'),
                        ],
                      ),
                    );
                  }
                  return widget.isLihatLaporanTelahDiBalas
                      ? Column(
                          children: snapshot.data!.docs
                              .map<Widget>(
                                (e) => listLaporan(
                                  judul: e['judul_laporan'],
                                  isiLaporan: e['laporan'],
                                  image: e['image'],
                                  timeLaporan: e['tanggal_laporan'],
                                  uid: e['uid'],
                                  laporanId: e['laporanId'],
                                  urgensi: e['urgensi'],
                                ),
                              )
                              .toList())
                      : Column(
                          children: snapshot.data!.docs
                              .map<Widget>(
                                (e) => listLaporan(
                                  judul: e['judul_laporan'],
                                  isiLaporan: e['laporan'],
                                  image: e['image'],
                                  timeLaporan: e['tanggal_laporan'],
                                  uid: e['uid'],
                                  laporanId: e['laporanId'],
                                ),
                              )
                              .toList());
                }
                return const Center(child: Text('Koneksi Terputus'));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ]));
  }

  Widget listLaporan({
    double? urgensi,
    String? judul,
    String? isiLaporan,
    String? image,
    String? uid,
    String? laporanId,
    Timestamp? timeLaporan,
  }) {
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
                  if (widget.isLihatLaporanTelahDiBalas) {
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
                                laporanId!,
                                widget.isLihatLaporanTelahDiBalas,
                                urgensi!)));
                  } else {
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
                                laporanId!,
                                widget.isLihatLaporanTelahDiBalas,
                                null)));
                  }
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

  selectDate() async {
    showDatePicker(
      context: context,
      initialDate: firstSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2040, 12),
    ).then((firstSelectedDate) {
      //do whatever you want
      if (firstSelectedDate != null) {
        debugPrint('tanggal awal: ${firstSelectedDate.toString()}');
        showDatePicker(
          context: context,
          initialDate: secondSelectedDate ?? DateTime.now(),
          firstDate: DateTime(2000, 1),
          lastDate: DateTime(2040, 12),
        ).then((secondSelectedDate) {
          //do whatever you want
          if (secondSelectedDate != null) {
            debugPrint('tanggal akhir: ${secondSelectedDate.toString()}');
            laporan
                .where('tanggal_laporan',
                    isGreaterThanOrEqualTo: firstSelectedDate)
                .where('tanggal_laporan',
                    isLessThanOrEqualTo: secondSelectedDate)
                .where('sudahDiBalas', isEqualTo: true)
                .get()
                .then((value) =>
                    GetPdf(value.docs, firstSelectedDate, secondSelectedDate)
                        .getPdf());
          }
        });
      }
    });
  }
}
