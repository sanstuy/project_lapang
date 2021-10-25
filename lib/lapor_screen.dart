import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LaporScreen extends StatelessWidget {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference laporan =
      FirebaseFirestore.instance.collection('Laporan');
  final TextEditingController _laporanController = TextEditingController();
  final String uid;

  LaporScreen(this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _laporanController,
              decoration: const InputDecoration(hintText: 'Laporan'),
            ),
            ElevatedButton(
                onPressed: () {
                  laporan.add({
                    'laporan': _laporanController.text.trim(),
                    'uid': uid
                  }).then((value) {
                    return ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text('Laporan Berhasil diadukan.'),
                    ));
                  });
                  _laporanController.text = '';
                  Navigator.pop(context);
                },
                child: const Text('Laporkan'))
          ],
        ),
      ),
    );
  }
}
