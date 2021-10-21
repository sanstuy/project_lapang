import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:project_lapang/home.dart';
import 'package:project_lapang/register_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  var isLoading = false;
  var isResend = false;
  var isLogin = true;
  var isOTPScreen = false;
  var verificationCode = '';

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: Center(
                  child: Text(
                'Sigas Desa Leuwiliang',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: 'Nomor Telepon',
                        hintText: '8xxx',
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('+62'),
                        ),
                      ),
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      controller: _nomorController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        login();
                      });
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => OTPScreen(_nomorController.text)));
                    },
                    child: const Text("Login"),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        maximumSize: const Size(double.infinity, 30.0),
                        minimumSize: const Size(330, 30.0)),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: Text('Belum Punya Akun?'),
                  ),
                  InkWell(
                    child: const Text(
                      'Yuk Daftar!',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()))
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnOTPScreen() {
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                          (route) => false);
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

  Future login() async {
    var isValid = false;
    var phoneNumber = '+62${_nomorController.text.trim()}';
    await _firestore
        .collection('users')
        .where('nomor_hp', isEqualTo: phoneNumber)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValid = true;
      }
    });
    if (isValid) {
      setState(() {
        isLogin = false;
        isOTPScreen = true;
      });
      debugPrint("Test 1");
      var verifikasiNomorTelepon = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          debugPrint("Test 2");
          _auth
              .signInWithCredential(phoneAuthCredential)
              .then((dynamic user) async => {
                    if (user != null)
                      {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                            (route) => false)
                      }
                  });
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nomor tidak terdaftar')));
    }
  }
}
