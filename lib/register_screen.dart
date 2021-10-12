// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _domisiliController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  var isLoading = false;
  var isResend = false;
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
                        if (!isLoading) {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')));
                            setState(() {
                              signUp();
                            });
                          }
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('OTP Screen'),
        ),
        body: ListView(children: [
          Form(
            key: _formKeyOTP,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                            !isLoading
                                ? "Enter OTP from SMS"
                                : "Sending OTP code SMS",
                            textAlign: TextAlign.center))),
                !isLoading
                    ? Container(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: null,
                          autofocus: true,
                          decoration: const InputDecoration(
                              labelText: 'OTP',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter OTP';
                            }
                          },
                        ),
                      ))
                    : Container(),
                !isLoading
                    ? Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKeyOTP.currentState!.validate()) {
                                  // If the form is valid, we want to show a loading Snackbar
                                  // If the form is valid, we want to do firebase signup...
                                  setState(() {
                                    isResend = false;
                                    isLoading = true;
                                  });
                                  try {
                                    await _auth
                                        .signInWithCredential(
                                            PhoneAuthProvider.credential(
                                                verificationId:
                                                    verificationCode,
                                                smsCode: otpController.text
                                                    .toString()))
                                        .then((dynamic user) async => {
                                              //sign in was success
                                              if (user != null)
                                                {
                                                  //store registration details in firestore database
                                                  await _firestore
                                                      .collection('users')
                                                      .doc(_auth
                                                          .currentUser!.uid)
                                                      .set(
                                                          {
                                                        'nik': _nikController
                                                            .text
                                                            .trim(),
                                                        'nama': _namaController
                                                            .text
                                                            .trim(),
                                                        'domisili':
                                                            _domisiliController
                                                                .text
                                                                .trim(),
                                                        'nomor_hp':
                                                            _nomorController
                                                                .text
                                                                .trim(),
                                                        'kelas': 'umum',
                                                      },
                                                          SetOptions(
                                                              merge:
                                                                  true)).then(
                                                          (value) => {
                                                                //then move to authorised area
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  isResend =
                                                                      false;
                                                                })
                                                              }),

                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  }),
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const Home(),
                                                    ),
                                                    (route) => false,
                                                  )
                                                }
                                            })
                                        // ignore: invalid_return_type_for_catch_error
                                        .catchError((error) => {
                                              setState(() {
                                                isLoading = false;
                                                isResend = true;
                                              }),
                                            });
                                    setState(() {
                                      isLoading = true;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Submit",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              ].where((dynamic c) => c != null).toList(),
                            )
                          ]),
                isResend
                    ? Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });
                                await signUp();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Resend Code",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column()
              ],
            ),
          )
        ]));
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });

    var isValidNik = false;
    var isValidNomor = false;
    var nomor = _nomorController.text.trim();
    var nik = _nikController.text.trim();

    await _firestore
        .collection('users')
        .where('nik', isEqualTo: nik)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValidNik = true;
        isLoading = false;
      }
    });

    await _firestore
        .collection('users')
        .where('nomor_hp', isEqualTo: nomor)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValidNomor = true;
        isLoading = false;
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
      var phoneNumber = '+62 ${_nomorController.text.toString()}';
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
                              'nomor_hp': '+62 ${_nomorController.text.trim()}',
                              'kelas': 'umum',
                            }, SetOptions(merge: true))
                            .then((value) => {
                                  //then move to authorised area
                                  setState(() {
                                    isLoading = false;
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
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          debugPrint('Test 6');
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Test 7');
          setState(() {
            isLoading = false;
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
