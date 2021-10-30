import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AkunScreen extends StatefulWidget {
  final String domisili;
  final String nama;
  final String nik;
  final String nomorHp;
  final String uid;
  const AkunScreen(this.domisili, this.nama, this.nik, this.nomorHp,this.uid, { Key? key }) : super(key: key);

  @override
  _AkunScreenState createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        Text(widget.uid),
        Text(widget.nik),
        Text(widget.nama),
        Text(widget.domisili),
        Text(widget.nomorHp),
        ],
      ),
    );
  }

}