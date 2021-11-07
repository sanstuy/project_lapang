import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BalasScreen extends StatefulWidget {
  final String judul;
  final String isiLaporan;
  final String image;
  final Timestamp timeLaporan;
  final String uid;
  final String uidPetugas;
  final String namaPelapor;
  final String domisiliPelapor;
  final String laporanId;
  const BalasScreen(
      this.judul,
      this.isiLaporan,
      this.image,
      this.timeLaporan,
      this.uid,
      this.uidPetugas,
      this.namaPelapor,
      this.domisiliPelapor,
      this.laporanId,
      {Key? key})
      : super(key: key);

  @override
  _BalasScreenState createState() => _BalasScreenState();
}

class _BalasScreenState extends State<BalasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _balasanController = TextEditingController();
  double _currentSliderValue = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balas Laporan'),
        centerTitle: true,
      ),
      body: ListView(
        children: [laporan(context), balasLaporan(context)],
      ),
    );
  }

  Widget laporan(BuildContext context) {
    DateTime tanggal = widget.timeLaporan.toDate();
    var dateTime = DateTime.parse(tanggal.toString());
    var dmyformat = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 3,
                    blurRadius: 1.5,
                    offset: const Offset(0, 7),
                  )
                ]),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SelectableText(
                        widget.judul,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            'Pelapor : ${widget.namaPelapor.toString()}\nDomisili :\n${widget.domisiliPelapor.toString()}',
                            // snapshot.data!['nama'].toString(),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SelectableText(
                          'Tanggal Laporan \n $dmyformat',
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SelectableText(
                      widget.isiLaporan,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FutureBuilder(
                        future: getPic(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> image) {
                          if (image.hasData) {
                            return Image.network(image.data.toString());
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget balasLaporan(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: const EdgeInsets.all(5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 3,
                blurRadius: 1.5,
                offset: const Offset(0, 7),
              )
            ]),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Tingkat Urgensi'),
            ),
            Slider(
              value: _currentSliderValue,
              min: 1,
              max: 10,
              divisions: 9,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Balas Aduan',
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                    controller: _balasanController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Balasan tidak boleh kosong!';
                      }
                    }),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                    debugPrint(_currentSliderValue.toString());
                  }
                },
                child: const Text('test')),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                    setState(() {
                      addBalasan(_balasanController, widget.laporanId,
                          widget.uidPetugas);
                    });
                  }
                },
                child: const Text('Balas'))
          ],
        ),
      ),
    );
  }

  addBalasan(TextEditingController _balasanController, String _docId,
      String uidPetugas) {
    DocumentReference docLaporan =
        FirebaseFirestore.instance.collection('laporan').doc(widget.laporanId);
    CollectionReference balas = FirebaseFirestore.instance
        .collection('laporan')
        .doc(widget.laporanId)
        .collection('balasan');
    DocumentReference docBalasan = balas.doc();
    DateTime dateBalasan = DateTime.now();
    docBalasan.set({
      'balasan': _balasanController.text.trim(),
      'laporanId': _docId,
      'uidPetugas': uidPetugas,
      'tanggal_balasan': dateBalasan,
    }).then((value) => docLaporan.update({'urgensi': _currentSliderValue}).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Aduan telah dibalas")))));
    _balasanController.text = '';
    Navigator.pop(context);
  }

  Future<String> getPic() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("uploads/").child(widget.image);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    return url;
  }
}
