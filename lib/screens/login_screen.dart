import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:neoteric_flutter/screens/home_screen.dart';
import 'package:neoteric_flutter/screens/otp_verification_screen.dart';
import 'package:neoteric_flutter/screens/register_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../modules/widgets/base_button.dart';
import '../modules/widgets/base_formfiled.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? name = "monika";
  String? _verificationId = "";
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    // print('phoneauth======0000000');

    FirebaseAuth auth = FirebaseAuth.instance;

    // print('phoneauth======11111111');

    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('phoneauth======222222');
        print(credential.verificationId);
        print(credential.toString());

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('phoneauth======333333');
        print(e.code);
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        print('phoneauth======4444444');
        print(verificationId);
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('phoneauth======55555555');
      },
    );
  }

  @override
  void initState() {
    super.initState();
//    getProfileData();
  }

  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/mainlogo.png',
                    width: 123,
                    height: 73,
                  ),
                  Image.asset('assets/home_screen_welcome.png'),
                  BaseTextFormFiled(
                    controller: usernameController,
                    hintText: 'Mobile no.',
                    preffix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        'assets/call.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? const SpinKitChasingDots(
                          color: Color(0xffFF3D00),
                          size: 80.0,
                        )
                      : BaseButton(
                          onPress: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (usernameController.text.toString().isEmpty ||
                                usernameController.text.toString().length !=
                                    10) {
                              setState(() {
                                isLoading = false;
                              });

                              Fluttertoast.showToast(
                                  msg: "Enter 10 digit mobile no",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              sendOtp(usernameController.text.toString());
                            }
                          },
                          title: "Request OTP",
                          fontSize: 16,
                        ),

                  const SizedBox(
                    height: 20,
                  ),

                  // const Text(
                  //   'This app is only for existing Neoteric customers',
                  //   style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffFF3D00)),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendOtp(String mobileno) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "contact_no": mobileno.toString(),
    };

    final response = await http.post(
      Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Sendotp'),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print('response.statusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("response_gateway===");
      print(jsonResponse);
      //  dynamic status = jsonResponse['responseCode'].toString();
      //  dynamic bank_name = jsonResponse['data']['bankname'].toString();
      if (jsonResponse['status'].toString().toLowerCase() == "true") {
        print('check_condition====if');
        print(jsonResponse['status'].toString());
        print(jsonResponse['msg'].toString());
        print(jsonResponse['otp'].toString());

        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
            msg: jsonResponse['msg'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpVerficationScreen(
              mobileno: usernameController.text.toString(),
              verification_id: jsonResponse['otp'].toString()),
        ));
      } else {
        print('check_condition====else');
        print(jsonResponse['status'].toString());
        print(jsonResponse['msg'].toString());

        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
            msg:
                '${jsonResponse['msg'].toString()} Please check your mobile no',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
