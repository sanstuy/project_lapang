import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GetPdf {
  final List<QueryDocumentSnapshot<Object?>> isiLaporan;
  final DateTime firstSelectedDate, secondSelectedDate;
  GetPdf(this.isiLaporan, this.firstSelectedDate, this.secondSelectedDate);

  Future getPdf() async {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    int banyakData = isiLaporan.length;
    String firstDmyFormat =
        "${firstSelectedDate.day}-${firstSelectedDate.month}-${firstSelectedDate.year}";
    String secondDmyFormat =
        "${secondSelectedDate.day}-${secondSelectedDate.month}-${secondSelectedDate.year}";
    // debugPrint(tempPath);
    pw.Document pdf = pw.Document();

    for (var i = 0; i < banyakData; i++) {
      CollectionReference balasan = FirebaseFirestore.instance
          .collection('laporan')
          .doc(isiLaporan[i].get('laporanId'))
          .collection('balasan');
      // Reference ref = FirebaseStorage.instance
      //     .ref()
      //     .child("uploads/")
      //     .child(isiLaporan[i].get('image'));

      late String domisili;
      late String namaPelapor;
      late String namaPetugas;
      late String uidPetugas;
      late String isiBalasan;
      late Timestamp timeBalasan;
      // late String url;
      late DateTime dateBalasan = timeBalasan.toDate();
      late var tanggalBalasan = DateTime.parse(dateBalasan.toString());
      late String dmyFormatBalasan =
          "${tanggalBalasan.day}/${tanggalBalasan.month}/${tanggalBalasan.year}";

      Timestamp timeLaporan = isiLaporan[i].get('tanggal_laporan');
      DateTime dateLaporan = timeLaporan.toDate();

      var tanggalLaporan = DateTime.parse(dateLaporan.toString());
      var dmyFormatLaporan =
          "${tanggalLaporan.day}/${tanggalLaporan.month}/${tanggalLaporan.year}";

      await user.doc(isiLaporan[i].get('uid')).get().then((value) {
        namaPelapor = value.get('nama');
        domisili = value.get('domisili');
      });

      await balasan
          .where('laporanId', isEqualTo: isiLaporan[i].get('laporanId'))
          .get()
          .then((value) {
        isiBalasan = value.docs[0].get('balasan');
        uidPetugas = value.docs[0].get('uidPetugas');
        timeBalasan = value.docs[0].get('tanggal_balasan');
      });

      await user.doc(uidPetugas).get().then((value) {
        namaPetugas = value.get('nama');
      });

      // await ref.getDownloadURL().then((value) {
      //   url = value.toString();
      // });

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(child: pw.Text(isiLaporan[i].get('judul_laporan'))),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Pelapor')),
                    pw.Text('Tanggal Laporan')
                  ]),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text(namaPelapor)),
                    pw.Text(dmyFormatLaporan)
                  ]),
                  pw.Text('Domisili'),
                  pw.Text(domisili),
                  pw.Text(isiLaporan[i].get('laporan')),
                  // pw.Center(child: pw.Image(image.)),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Petugas')),
                    pw.Text('Tanggal Balasan')
                  ]),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text(namaPetugas)),
                    pw.Text(dmyFormatBalasan)
                  ]),
                  pw.Text('Urgensi : ${isiLaporan[i].get('urgensi')}'),
                  pw.Text(isiBalasan)
                ]);
          },
        ),
      );
    }

    File pdfFile = File(
        '/storage/emulated/0/Download/Laporan $firstDmyFormat s.d. $secondDmyFormat.pdf');
    return pdfFile.writeAsBytesSync(await pdf.save());
  }
}
