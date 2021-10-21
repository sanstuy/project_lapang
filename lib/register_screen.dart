// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:project_lapang/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _domisiliController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _domisiliController.dispose();
    _nomorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : registerScreen();
  }

  Widget registerScreen() {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Align(
              alignment: Alignment.center,
              child: Text(
                'Daftar Akun Baru',
              ))),
      body: ListView(
        children: [
          Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: 'NIK',
                        hintText: 'Sesuai KTP',
                      ),
                      maxLength: 16,
                      keyboardType: TextInputType.number,
                      controller: _nikController,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'NIK Tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Nama',
                          hintText: 'Sesuai KTP',
                        ),
                        keyboardType: TextInputType.name,
                        controller: _namaController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[,/ .0-9a-zA-Z]"))
                        ],
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Nama Tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Domisili Tinggal',
                          hintText: 'Kampung RT/RW',
                        ),
                        keyboardType: TextInputType.name,
                        controller: _domisiliController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[,/ .0-9a-zA-Z]"))
                        ],
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Domisili Tinggal Tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          labelText: 'Nomor Handphone',
                          hintText: '8xxx',
                          prefix: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('+62'),
                          ),
                        ),
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        controller: _nomorController,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Nomor Handphone Tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')));
                          setState(() {
                            signUp();
                          });
                        }
                      },
                      child: const Text("Daftar"),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50.0)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget returnOTPScreen() {
    final _pinPutFocusNode = FocusNode();
    final _pinPutController = TextEditingController();
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(43, 46, 66, 1),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(126, 203, 224, 1),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +62${_nomorController.text.trim()}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              withCursor: true,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              onSubmit: (String pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      await _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .set({
                        'nik': _nikController.text.trim(),
                        'nama': _namaController.text.trim(),
                        'domisili': _domisiliController.text.trim(),
                        'nomor_hp': '+62${_nomorController.text.trim()}',
                        'kelas': 'umum',
                      }, SetOptions(merge: true)).then((value) => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                    (route) => false)
                              });
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kode OTP salah')));
                }
              },
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
            ),
          )
        ],
      ),
    );
  }

  Future signUp() async {
    var isValidNik = false;
    var isValidNomor = false;
    var nomor = '+62${_nomorController.text.trim()}';
    var nik = _nikController.text.trim();

    await _firestore
        .collection('users')
        .where('nik', isEqualTo: nik)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValidNik = true;
      }
    });

    await _firestore
        .collection('users')
        .where('nomor_hp', isEqualTo: nomor)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValidNomor = true;
      }
    });

    if (isValidNik) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('NIK telah terdaftar')));
    }

    if (isValidNomor) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomor HP telah terdaftar')));
    }

    if (isValidNik == false && isValidNomor == false) {
      setState(() {
        isRegister = false;
        isOTPScreen = true;
      });
      debugPrint('Test 1');
      var phoneNumber = '+62${_nomorController.text.toString()}';
      debugPrint('Test 2');
      var verifikasiNomorTelepon = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          debugPrint('Test 3');
          //Auto Code Complete
          _auth
              .signInWithCredential(phoneAuthCredential)
              .then((dynamic user) async => {
                    if (user != null)
                      {
                        await _firestore
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .set({
                              'nik': _nikController.text.trim(),
                              'nama': _namaController.text.trim(),
                              'domisili': _domisiliController.text.trim(),
                              'nomor_hp': '+62${_nomorController.text.trim()}',
                              'kelas': 'umum',
                            }, SetOptions(merge: true))
                            .then((value) => {
                                  //then move to authorised area
                                  setState(() {
                                    isRegister = false;
                                    isOTPScreen = false;

                                    //navigate to is
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const Home(),
                                      ),
                                      (route) => false,
                                    );
                                  })
                                })
                            .catchError((onError) => {
                                  debugPrint(
                                      'Error saving user to db. ${onError.toString()}')
                                })
                      }
                  });
          debugPrint('Test 4');
        },
        verificationFailed: (FirebaseAuthException error) {
          debugPrint('Test 5 ${error.message}');
        },
        codeSent: (verificationId, [forceResendingToken]) {
          debugPrint('Test 6');
          setState(() {
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Test 7');
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
      debugPrint('Test 7');
      await verifikasiNomorTelepon;
      debugPrint('Test 8');
    }
  }
}
