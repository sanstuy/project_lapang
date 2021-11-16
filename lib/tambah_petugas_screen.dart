import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TambahPetugasScreen extends StatefulWidget {
  const TambahPetugasScreen({Key? key}) : super(key: key);

  @override
  _TambahPetugasScreenState createState() => _TambahPetugasScreenState();
}

class _TambahPetugasScreenState extends State<TambahPetugasScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final TextEditingController _searchNama = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Petugas'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: TextField(
              controller: _searchNama,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.search_outlined),
                ),
                hintText: 'Nama User',
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: users
                  .orderBy('kelas', descending: false).orderBy('nama', descending: false)
                  .startAt([_searchNama.text.toUpperCase()]).endAt(
                      [_searchNama.text.toLowerCase() + '\uf8ff']).snapshots(),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs
                            .map((e) => user(
                                  nama: e['nama'],
                                  domisili: e['domisili'],
                                  nomorTelp: e['nomor_hp'],
                                  kelas: e['kelas'],
                                  uid: e['uid'],
                                ))
                            .toList(),
                      );
                    }
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
        ],
      ),
    );
  }

  Widget user(
      {String? nama,
      String? domisili,
      String? nomorTelp,
      String? kelas,
      String? uid}) {
    bool isPetugas = false;
    if (kelas == 'petugas') {
      isPetugas = true;
    }
    return Builder(builder: (context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.1),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                    Text('Domisili: \n$domisili',
                        style: const TextStyle(
                          fontSize: 15,
                        )),
                    Text(
                      'Nomor Telepon: \n$nomorTelp',
                      style: const TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              isPetugas
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buatIcon(
                          icon: Icons.highlight_remove,
                          warna: Colors.blue,
                          iconSize: 30,
                          tooltip: 'Hapus petugas',
                          isPetugas: isPetugas,
                          uid: uid,
                        ),
                        const Text(
                          'Hapus Petugas',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buatIcon(
                          icon: Icons.add_circle_outline,
                          warna: Colors.blue,
                          iconSize: 30,
                          tooltip: 'Tambah Petugas',
                          uid: uid,
                        ),
                        const Text(
                          'Tambah Petugas',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
            ],
          ),
        ),
      );
    });
  }

  buatIcon(
      {IconData? icon,
      var warna,
      double? iconSize,
      String? tooltip,
      bool? isPetugas,
      String? uid}) {
    var judulAlert = 'Berhasil Menambah Petugas';
    if (isPetugas == true) {
      judulAlert = 'Berhasil Menghapus Petugas';
    }
    return IconButton(
      icon: Icon(
        icon,
        color: warna,
      ),
      color: Colors.white,
      iconSize: iconSize!,
      tooltip: tooltip,
      onPressed: () {
        setState(() {
          updateKelasUser(uid, isPetugas);
          alertDialog(judulAlert);
        });
      },
    );
  }

  Future<dynamic> alertDialog(String judulAlert) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Center(child: Text(judulAlert)),
              // content: Text('data'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, "Oke"),
                    child: const Text('Oke'))
              ],
            ));
  }

  updateKelasUser(uid, isPetugas) {
    DocumentReference docUser = users.doc(uid);
    var kelas = 'petugas';
    if (isPetugas == true) {
      kelas = 'umum';
    }
    var update = docUser.update({'kelas': kelas});
  }
}
