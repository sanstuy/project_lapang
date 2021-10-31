import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RiwayatLaporanScreen extends StatefulWidget {
  final String uid;
  final Timestamp tanggal;
  const RiwayatLaporanScreen(this.tanggal, this.uid, {Key? key})
      : super(key: key);

  @override
  _RiwayatLaporanScreenState createState() => _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState extends State<RiwayatLaporanScreen> {
  final CollectionReference laporan =
      FirebaseFirestore.instance.collection('laporan');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: getDocumentId(),
        builder: (_, snapshot) {
          return ElevatedButton(
              onPressed: () {
                getDocumentId();
              },
              child: Text(snapshot.data.toString()));
        }
      ),
    ));
  }

  //Mengambil ID dari document yang akan diakses.
  getDocumentId() async {
    QuerySnapshot querySnap = await laporan
        .where('tanggal_laporan', isEqualTo: widget.tanggal)
        .where('uid', isEqualTo: widget.uid)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    DocumentReference docRef = doc.reference;
    var docId = docRef.id;
    debugPrint(docId);
    return docId;
  }
}