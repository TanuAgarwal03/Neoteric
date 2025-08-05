import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:neoteric_flutter/modules/widgets/base_button.dart';
import 'package:neoteric_flutter/modules/widgets/base_formfiled.dart';
import 'package:neoteric_flutter/screens/login_screen.dart';
import 'package:neoteric_flutter/screens/otp_verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
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
                  height: 50,
                ),
                Image.asset(
                  'assets/home_screen_welcome.png',
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                BaseTextFormFiled(
                  controller: nameController,
                  hintText: 'Your name',
                  preffix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      'assets/account.png',
                      width: 25,
                      height: 25,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                BaseTextFormFiled(
                  controller: phoneController,
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
                  height: 10,
                ),
                BaseTextFormFiled(
                  controller: emailController,
                  hintText: 'Email address',
                  preffix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.email,
                      color: Color(0xffFF3D00),
                      size: 25,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 40,
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
                          if (nameController.text.toString().isEmpty) {
                            setState(() {
                              isLoading = false;
                            });

                            Fluttertoast.showToast(
                                msg: "Enter your full name",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (phoneController.text.toString().isEmpty ||
                              phoneController.text.toString().length != 10 ||
                              !RegExp(r'^[0-9]{10}$')
                                  .hasMatch(phoneController.text.toString())) {
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
                          } else if (emailController.text.toString().isEmpty ||
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(emailController.text.toString())) {
                            setState(() {
                              isLoading = false;
                            });

                            Fluttertoast.showToast(
                                msg: "Enter valid email address",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            verifyTenant(
                              nameController.text.toString(),
                              phoneController.text.toString(),
                              emailController.text.toString(),
                            );
                            // sendOtp(
                            // nameController.text.toString(),
                            // phoneController.text.toString(),
                            // emailController.text.toString());
                          }
                        },
                        title: "Register Now",
                        fontSize: 16,
                      ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        'Login ',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffFF3D00)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ])));
  }

  // void sendOtp(String name, String mobileno, String email) async {
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //   };
  //   final Map<String, dynamic> requestBody = {
  //     "contact_no": mobileno.toString(),
  //   };
  //   final response = await http.post(
  //     Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Sendotp'),
  //     headers: headers,
  //     body: jsonEncode(requestBody),
  //   );
  //   print('response.statusCode: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     print("response_gateway===");
  //     print(jsonResponse);
  //     if (jsonResponse['status'].toString().toLowerCase() == "true") {
  //       print('check_condition====if');
  //       print(jsonResponse['status'].toString());
  //       print(jsonResponse['msg'].toString());
  //       print(jsonResponse['otp'].toString());
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Fluttertoast.showToast(
  //           msg: jsonResponse['msg'].toString(),
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  // Navigator.of(context).push(MaterialPageRoute(
  //   builder: (context) => OtpVerficationScreen(
  //       mobileno: phoneController.text.toString(),
  //       verification_id: jsonResponse['otp'].toString()),
  // ));
  //     } else {
  //       print('check_condition====else');
  //       print(jsonResponse['status'].toString());
  //       print(jsonResponse['msg'].toString());
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Fluttertoast.showToast(
  //           msg:
  //               '${jsonResponse['msg'].toString()} Please check your mobile no',
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  void verifyTenant(String name, String mobileno, String email) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "contact_no": mobileno,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://lytechxagency.website/Laravel_GoogleSheet/tanentVerify'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        // ✅ Save data to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('otp', jsonResponse['otp'].toString());
        await prefs.setString('username', jsonResponse['requestData']['name']);
        await prefs.setString(
            'mobile', jsonResponse['requestData']['contact_no']);
        await prefs.setString('email', jsonResponse['requestData']['email']);

        Fluttertoast.showToast(
          msg: jsonResponse['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpVerficationScreen(
              mobileno: mobileno,
              verification_id: jsonResponse['otp'].toString()),
        ));
      } else if (jsonResponse['status'] == false &&
          jsonResponse['msg'] ==
              "User already registered with this contact number.") {
        showDialogBoxLogout();
        // Fluttertoast.showToast(
        //   msg: jsonResponse['msg'],
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.black,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => OtpVerficationScreen(
        //       mobileno: mobileno,
        //       verification_id: jsonResponse['otp'].toString()),
        // ));
      } else {
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
          msg: jsonResponse['msg'] ?? "Process failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: "Something went wrong.Try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  showDialogBoxLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: const Text("User already registered with this number."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            },
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Login Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
