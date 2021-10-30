import 'package:flutter/material.dart';

class RiwayatLaporanScreen extends StatefulWidget {
  final String uid;
  final String laporan;
  const RiwayatLaporanScreen(this.laporan, this.uid, { Key? key }) : super(key: key);

  @override
  _RiwayatLaporanScreenState createState() => _RiwayatLaporanScreenState();
}

class _RiwayatLaporanScreenState extends State<RiwayatLaporanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        Text(widget.laporan),
        Text(widget.uid)
        ],
      ),
    );
  }
}