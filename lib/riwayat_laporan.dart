import 'package:flutter/material.dart';

class RiwayatLaporan extends StatelessWidget {
  final String laporan;
  final String uid;

  const RiwayatLaporan(this.laporan, this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(laporan,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              Text(uid)
            ],
          ),
        ],
      ),
    );
  }
}
