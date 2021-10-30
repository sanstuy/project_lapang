import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class LaporScreen extends StatefulWidget {
  final String uid;

  const LaporScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<LaporScreen> createState() => _LaporScreenState();
}

class _LaporScreenState extends State<LaporScreen> {
  final CollectionReference laporan =
      FirebaseFirestore.instance.collection('laporan');
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _laporanController = TextEditingController();
  final TextEditingController _judulLaporanController = TextEditingController();

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Aduan Baru'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.03),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: TextField(
                  controller: _judulLaporanController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Judul Aduan',
                    // contentPadding: EdgeInsets.symmetric(vertical: 15.0)
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: TextField(
                  controller: _laporanController,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Isi Aduan',
                    labelStyle: TextStyle(fontSize: 30.0),
                    // contentPadding: EdgeInsets.symmetric(vertical: 30.0)
                  ),
                ),
              ),
              imagePicker(context),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: ElevatedButton(
                    onPressed: () {
                      // uploadImageToFirebase(context);
                      addLaporan(context);
                    },
                    child:
                        const Text('Adukan', style: TextStyle(fontSize: 20))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imagePicker(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: GestureDetector(
        onTap: () => pickImage(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: image != null
                ? Image.file(
                    image!,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_sharp,
                          size: MediaQuery.of(context).size.height * 0.1),
                      const Text(
                        'Tambah Foto Aduan',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(image!.path);
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(image!);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
      debugPrint(fileName);
    });
  }

  Future addLaporan(BuildContext context) async {
    DateTime _tanggalLaporan = DateTime.now();
    String fileName = basename(image!.path);
    laporan.add({
      'judul_laporan': _judulLaporanController.text.trim(),
      'laporan': _laporanController.text.trim(),
      'tanggal_laporan': _tanggalLaporan,
      'uid': widget.uid,
      'image': fileName,
    }).then((value) => uploadImageToFirebase(context).then((value) {
          return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Laporan Berhasil diadukan.'),
          ));
        }));
    _laporanController.text = '';
    Navigator.pop(context);
  }
}
