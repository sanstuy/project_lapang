import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_lapang/riwayat_laporan_screen.dart';

class RiwayatLaporan extends StatelessWidget {
  final String judul_laporan;
  final String laporan;
  final String uid;
  final Timestamp time;
  const RiwayatLaporan(this.judul_laporan, this.laporan, this.uid, this.time,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime tanggal = time.toDate();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue)),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RiwayatLaporanScreen(time, uid)),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(judul_laporan,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
              Text(laporan,
                  style: const TextStyle(
                    fontSize: 15,
                  )),
              Text(
                tanggal.toString(),
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}
