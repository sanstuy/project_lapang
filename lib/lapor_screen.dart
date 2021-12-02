import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

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
  final _formKey = GlobalKey<FormState>();
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
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.03),
                  child: TextFormField(
                    controller: _judulLaporanController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Judul Aduan',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Judul Aduan Tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.03),
                  child: TextFormField(
                    controller: _laporanController,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Isi Aduan',
                      labelStyle: TextStyle(fontSize: 30.0),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Aduan tidak boleh kosong!';
                      }
                      return null;
                    },
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
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            addLaporan(context);
                          });
                        }
                      },
                      child:
                          const Text('Adukan', style: TextStyle(fontSize: 20))),
                )
              ],
            ),
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
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar $e')));
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
    DocumentReference docRefence = laporan.doc();
    DateTime _tanggalLaporan = DateTime.now();

    if (image != null) {
      var fileName = basename(image!.path);
      docRefence.set({
        'judul_laporan': _judulLaporanController.text.trim(),
        'laporan': _laporanController.text.trim(),
        'tanggal_laporan': _tanggalLaporan,
        'uid': widget.uid,
        'image': fileName,
        'laporanId': docRefence.id,
        'sudahDiBalas': false,
      }).then((value) => uploadImageToFirebase(context).then((value) {
            return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Laporan Berhasil diadukan.'),
            ));
          }));
      _laporanController.text = '';
      Navigator.pop(context);
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gambar Harus Diisi Sebagai Lampiran Bukti')));
    }
  }
}
