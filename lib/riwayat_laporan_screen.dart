import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RiwayatLaporanScreen extends StatefulWidget {
  final String laporanId;
  const RiwayatLaporanScreen(this.laporanId, {Key? key}) : super(key: key);

  @override
  _RiwayatLaporanScreenState createState() => _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState extends State<RiwayatLaporanScreen> {
  final CollectionReference laporan =
      FirebaseFirestore.instance.collection('laporan');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  late CollectionReference balasan;
  late String judul;
  late String isiLaporan;
  late String uid;
  late String nama;
  late String domisili;
  late String image;
  late String uidPetugas;
  late String namaPetugas;
  late String isiBalasan;
  late double? urgensi;
  late DateTime dateTime;
  late String dmyFormat;
  late Timestamp timeStamp;

  bool isDibalas = false;

  @override
  void initState() {
    balasan = FirebaseFirestore.instance
        .collection('laporan')
        .doc(widget.laporanId)
        .collection('balasan');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        getLaporanData(),
      ]),
    );
  }

  Container box(BuildContext context, dynamic child) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.06),
        padding: const EdgeInsets.all(5),
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
        child: child);
  }

  FutureBuilder<DocumentSnapshot<Object?>> getLaporanData() {
    return FutureBuilder(
        future: laporan.doc(widget.laporanId).get(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> doc =
                  snapshot.data!.data() as Map<String, dynamic>;
              judul = snapshot.data!['judul_laporan'].toString();
              isiLaporan = snapshot.data!['laporan'].toString();
              image = snapshot.data!['image'].toString();
              uid = snapshot.data!['uid'].toString();
              timeStamp = snapshot.data!['tanggal_laporan'];
              if (doc.containsKey('urgensi')) {
                urgensi = snapshot.data!['urgensi'];
                isDibalas = true;
              } else {
                urgensi = null;
              }
              return getUser();
            }
          } catch (e) {
            debugPrint(e.toString());
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  FutureBuilder<DocumentSnapshot<Object?>> getUser() {
    return FutureBuilder(
        future: getUserData(uid),
        builder: (context, AsyncSnapshot<DocumentSnapshot> user) {
          try {
            dmyFormat = convertDate(timeStamp);
            nama = user.data?['nama'];
            domisili = user.data?['domisili'];
            return isiData(context);
          } catch (e) {
            debugPrint(e.toString());
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Column isiData(BuildContext context) {
    return Column(
      children: [
        box(context, isiDataAduan()),
        isDibalas
            ? box(context, getDataBalasan())
            : const Text('Tidak ada balasan')
      ],
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> getDataBalasan() {
    return FutureBuilder(
        future: balasan.where('laporanId', isEqualTo: widget.laporanId).get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> balasan) {
          try {
            if (balasan.connectionState == ConnectionState.done) {
              isiBalasan = balasan.data?.docs[0].get('balasan');
              uidPetugas = balasan.data?.docs[0].get('uidPetugas');
              timeStamp = balasan.data?.docs[0].get('tanggal_balasan');
              dmyFormat = convertDate(timeStamp);
              return getDataPetugas(uidPetugas, isiBalasan);
            }
          } catch (e) {
            debugPrint(e.toString());
          }
          return const Center(child: LinearProgressIndicator());
        });
  }

  FutureBuilder<DocumentSnapshot<Object?>> getDataPetugas(
      uidPetugas, isiBalasan) {
    return FutureBuilder(
        future: getUserData(uidPetugas),
        builder: (context, AsyncSnapshot<DocumentSnapshot> petugas) {
          try {
            if (petugas.connectionState == ConnectionState.done) {
              namaPetugas = petugas.data?['nama'];
              return isiDataBalasan();
            }
          } catch (e) {
            debugPrint(e.toString());
          }
          return const Center(child: LinearProgressIndicator());
        });
  }

  Column isiDataBalasan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Balasan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Divider(
          color: Colors.blue,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  'Petugas : $namaPetugas \nTingkat Urgensi :\n$urgensi',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              SelectableText(
                'Tanggal Balasan\n$dmyFormat',
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SelectableText(isiBalasan),
        ),
      ],
    );
  }

  Column isiDataAduan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              judul,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Divider(
          color: Colors.blue,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  'Pelapor : $nama \nDomisili :\n$domisili',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              SelectableText(
                'Tanggal Laporan\n$dmyFormat',
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SelectableText(isiLaporan),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: getPic(),
              builder: (BuildContext context, AsyncSnapshot<String> image) {
                if (image.hasData) {
                  return Image.network(image.data.toString());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
  }

  Future<DocumentSnapshot> getUserData(uid) async {
    return users.doc(uid).get();
  }

  Future<String> getPic() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("uploads/").child(image);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    return url;
  }

  dynamic convertDate(Timestamp timeStamp) {
    var timeDate = timeStamp.toDate();
    dateTime = DateTime.parse(timeDate.toString());
    dmyFormat = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return dmyFormat;
  }
}
