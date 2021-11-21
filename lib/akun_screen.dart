import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AkunScreen extends StatefulWidget {
  final String domisili;
  final String nama;
  final String nik;
  final String nomorHp;
  final String uid;
  const AkunScreen(this.domisili, this.nama, this.nik, this.nomorHp, this.uid,
      {Key? key})
      : super(key: key);

  @override
  _AkunScreenState createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  TextEditingController nomorTelp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Anda'),
        centerTitle: true,
      ),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'NIK',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: widget.nik,
                  ),
                  enabled: false,
                ),
              ),
              const Text(
                'Nama',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: widget.nama,
                  ),
                  enabled: false,
                ),
              ),
              const Text(
                'Domisili',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: widget.domisili,
                  ),
                  enabled: false,
                ),
              ),
              const Text(
                'Nomor Telepon',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    // labelText: 'Nomor Telepon',
                    hintText: widget.nomorHp,
                  ),
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  updateNomorTelp() {}
}
