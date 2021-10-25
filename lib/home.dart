import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_lapang/lapor_screen.dart';
import 'package:project_lapang/riwayat_laporan.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference laporan =
      FirebaseFirestore.instance.collection('Laporan');
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  late String uid;
  var isPetugas = false;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(shrinkWrap: true, children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              constraints: const BoxConstraints(
                  minWidth: 300, maxWidth: double.infinity, minHeight: 80),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15.0)),
              child: atas(),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  debugPrint(uid);
                },
                child: const Text('isLoading true')),
            //Synced
            StreamBuilder<QuerySnapshot>(
                stream: laporan.where('uid', isEqualTo: uid).snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.data!.docs
                            .map((e) => RiwayatLaporan(e['laporan'], e['uid']))
                            .toList());
                  } else {
                    return const Text('Loading');
                  }
                }),
            // Sekali Baca
            // FutureBuilder<QuerySnapshot>(
            //     future: laporan.where('uid', isEqualTo: uid).get(),
            //     builder: (_, snapshot) {
            //       if (snapshot.hasData) {
            //         return Column(
            //             children: snapshot.data!.docs
            //                 .map((e) => RiwayatLaporan(
            //                     e['laporan'], e['uid']))
            //                 .toList());
            //       } else {
            //         return Text('Loading');
            //       }
            //     })
            // isLoading ? CircularProgressIndicator() : Text("False")
          ]),
        )
        );
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  Widget atas() {
    if (isPetugas) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          Text('Lihat Laporan'),
          Text('Buat Laporan'),
          Text('Tambah Petugas'),
          Text('Akun')
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
            child: const Text(
          'Buat Laporan',
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => LaporScreen(uid)));
        },),
        const Text('Akun'),
      ],
    );
  }
}
