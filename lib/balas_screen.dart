import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BalasScreen extends StatefulWidget {
  final bool isLihatLaporanTelahDiBalas;
  final double? urgensi;
  final String judul;
  final String isiLaporan;
  final String image;
  final String uid;
  final String uidPetugas;
  final String namaPelapor;
  final String domisiliPelapor;
  final String laporanId;
  final Timestamp timeLaporan;
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
      this.isLihatLaporanTelahDiBalas,
      this.urgensi,
      {Key? key})
      : super(key: key);

  @override
  _BalasScreenState createState() => _BalasScreenState();
}

class _BalasScreenState extends State<BalasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _balasanController = TextEditingController();
  double _currentSliderValue = 1;
  late String title;
  late DateTime tanggalLaporan;
  late var dateTime = DateTime.parse(tanggalLaporan.toString());
  late var dmyformat = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

  @override
  void initState() {
    tanggalLaporan = widget.timeLaporan.toDate();
    widget.isLihatLaporanTelahDiBalas
        ? title = 'Laporan'
        : title = 'Balas Laporan';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          returnLaporan(context),
          widget.isLihatLaporanTelahDiBalas
              ? returnDataBalasan(context)
              : returnBalasLaporan(context),
        ],
      ),
    );
  }

  Widget returnLaporan(BuildContext context) {
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
                            fontSize: 20, fontWeight: FontWeight.bold),
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

  Widget returnBalasLaporan(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: const EdgeInsets.all(5),
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
                  setState(() {
                    addBalasan(_balasanController, widget.laporanId,
                        widget.uidPetugas);
                  });
                }
              },
              child: const Text('Balas'))
        ],
      ),
    );
  }

  Widget returnDataBalasan(BuildContext context) {
    String? balasan;
    String? namaPetugas;
    Timestamp? timeBalasan;
    DateTime? dateBalasan;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.06),
      padding: const EdgeInsets.all(5),
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
      child: FutureBuilder(
        future: getDataBalasan(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            balasan = snapshot.data?.docs[0].get('balasan').toString();
            timeBalasan = snapshot.data?.docs[0].get('tanggal_balasan');
            dateBalasan = timeBalasan?.toDate();
            var dateTime = DateTime.parse(dateBalasan.toString());
            var dmyformat =
                "${dateTime.day}/${dateTime.month}/${dateTime.year}";
            return FutureBuilder(
                future: getDataPetugasBalasan(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> petugas) {
                  namaPetugas = petugas.data?['nama'].toString();
                  if (petugas.connectionState == ConnectionState.done) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Balasan',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                  'Petugas : $namaPetugas\nTingkat Urgensi :\n${widget.urgensi!.toInt().toString()}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              SelectableText(
                                'Tanggal Balasan \n $dmyformat',
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
                          child: SelectableText(balasan!),
                        )
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                });
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<QuerySnapshot> getDataBalasan() async {
    return await FirebaseFirestore.instance
        .collection('laporan')
        .doc(widget.laporanId)
        .collection('balasan')
        .where('laporanId', isEqualTo: widget.laporanId)
        .where('uidPetugas', isEqualTo: widget.uidPetugas)
        .get();
  }

  Future<DocumentSnapshot> getDataPetugasBalasan() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uidPetugas)
        .get();
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
      'balasanId': docBalasan.id,
    }).then((value) => docLaporan
        .update({'urgensi': _currentSliderValue, 'sudahDiBalas': true}).then(
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
