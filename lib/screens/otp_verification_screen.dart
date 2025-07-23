import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../modules/widgets/base_button.dart';
import '../modules/widgets/base_formfiled.dart';

// ignore: must_be_immutable
class OtpVerficationScreen extends StatefulWidget {
  String mobileno;
  String verification_id;
  OtpVerficationScreen(
      {super.key, required this.mobileno, required this.verification_id});

  @override
  State<OtpVerficationScreen> createState() => _OtpVerficationScreenState();
}

class _OtpVerficationScreenState extends State<OtpVerficationScreen> {
  String? name;
  String? mobileNo;
  String? email;

  bool? _isVisible;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    print("Method verifyPhoneNumber");
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verification_id,
        smsCode: usernameController.text.toString(),
      );
      final User user = (await auth.signInWithCredential(credential)).user!;
      print(user.emailVerified);
      print(user.phoneNumber);
      print(user.displayName);
      print(credential.smsCode);
      getProfileData(phoneNumber);
    } catch (e) {
      print("Exception verifyPhoneNumber : $e");
      getProfileData(phoneNumber);
    }
  }

  Future<void> getProfileData(String mobile) async {
    final response = await http.get(
      Uri.parse(
          "https://lytechxagency.website/Laravel_GoogleSheet/customer_detail?Phone=$mobile"),
    );
    print('getProfile method');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      if (responseData['status'] == false) {
        print('user_data====false');
        setState(() {
          isLoading = false;
        });

        showDialogBoxLogout();

        Fluttertoast.showToast(
          msg: responseData['userData'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return; // Exit early to avoid further execution
      }

      // Only reached when response.statusCode == 200 and responseData['status'] == true
      print('user_data====true');
      print(responseData['userData']['Name']);
      print(responseData['userData']['Contact No']);
      print(responseData['role']);

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('is_login', "true");
      pref.setString('name', responseData['userData']['Name'].toString());
      pref.setString('user_role', responseData['role'].toString());
      pref.setString(
          'address', responseData['userData']['Address']?.toString() ?? "");
      pref.setString('primary_contact_no',
          responseData['userData']['Contact No']?.toString() ?? "");
      pref.setString('primary_person_aadhar_no',
          responseData['userData']['Aadhar Card']?.toString() ?? "");
      pref.setString('primary_person_pan_no',
          responseData['userData']['Pan Card']?.toString() ?? "");
      pref.setString(
          'email_id', responseData['userData']['Email']?.toString() ?? "");
      pref.setString('customer_id',
          responseData['userData']['Customer Id']?.toString() ?? "");
      pref.setString(
          'birthday', responseData['userData']['Birthday']?.toString() ?? "");
      pref.setString('anniversary',
          responseData['userData']['Anniversary']?.toString() ?? "");
      pref.setString('emergency_name',
          responseData['userData']['Emergency name']?.toString() ?? "");
      pref.setString('emergency_no',
          responseData['userData']['Emergency No']?.toString() ?? "");

      updateToken(mobile, pref.getString("fcmToken").toString());
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  late Timer _timer;
  int _start = 5;
  bool isLoading = false;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 60;
  int currentSeconds = 0;
  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() {
            _isVisible = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });

    startTimer();
    startTimeout();
    _isVisible = false;
  }

  // void _resendCode() {
  //   //other code here
  //   setState((){
  //     secondsRemaining = 30;
  //     enableResend = false;
  //   });
  // }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
    _timer.cancel();
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int secondsRemaining = 30;
  bool enableResend = true;
  Timer? timer;

  void verifyOtp() {
    print('get_opt_widget====${widget.verification_id.toString()}');
    print('get_opt_widget====${usernameController.text.toString()}');

    if (widget.verification_id.toString() ==
        usernameController.text.toString()) {
      // OTP is Valid
      print('get_check====valid');

      registerTenant();

      getProfileData(widget.mobileno.toString());
    } else {
      setState(() {
        isLoading = false;
      });
      print('get_check==== not valid');
      // OTP is invalid
      Fluttertoast.showToast(
          msg: 'Invalid OTP',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

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
              padding: const EdgeInsets.only(left: 15, right: 15, top: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/mainlogo.png',
                    width: 123,
                    height: 73,
                  ),
                  Image.asset('assets/home_screen_welcome.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  BaseTextFormFiled(
                    controller: usernameController,
                    hintText: 'Enter the OTP',
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
                    height: 25,
                  ),
                  isLoading
                      ? const SpinKitChasingDots(
                          //  isLoading? SpinKitRotatingCircle(
                          color: Colors.red,
                          size: 80.0,
                          //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                        )
                      : BaseButton(
                          onPress: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (usernameController.text.toString().isEmpty) {
                              setState(() {
                                isLoading = false;
                              });

                              Fluttertoast.showToast(
                                  msg: "Request OTP",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              verifyOtp();
                            }
                          },
                          title: "Log In",
                          fontSize: 16,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: FractionalOffset.bottomRight,
                    child: _isVisible!
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _isVisible = false;
                                startTimeout();
                              });
                              sendOtp(widget.mobileno);
                            },
                            child: const Text(
                              'Resend Otp',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : Text(
                            timerText,
                          ),
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

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("response_gateway===");
      print(jsonResponse);
      //  dynamic status = jsonResponse['responseCode'].toString();
      //  dynamic bank_name = jsonResponse['data']['bankname'].toString();

      if (jsonResponse['status'].toString().toLowerCase() == "true") {
        print('check_condition====ifotp');
        print(jsonResponse['status'].toString());
        print(jsonResponse['msg'].toString());
        print(jsonResponse['otp'].toString());

        setState(() {
          isLoading = false;
        });
        getProfileData(mobileno);
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

  showDialogBoxLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: const Text("User Data Not Found"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // logOut();
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(14),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateToken(String mobile, String token) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "key": token,
      "customer_contact_no": mobile,
    };

    final response = await http.post(
      Uri.parse(
          'https://lytechxagency.website/Laravel_GoogleSheet/UpdateFiraBaseKey'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    final jsonResponse = json.decode(response.body);
    print("response_gateway===");
    print(jsonResponse);

    /*Fluttertoast.showToast(
        msg: jsonResponse['msg'].toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);*/

    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false);
  }

  void registerTenant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = await prefs.getString('username');
    email = await prefs.getString('email');
    mobileNo = await prefs.getString('mobile');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "contact_no": mobileNo,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://lytechxagency.website/Laravel_GoogleSheet/tanentRegister'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (jsonResponse['msg'] ==
          "User already registered with this contact number.") {
        setState(() {
          isLoading = false;
        });

        // Fluttertoast.showToast(
        //   msg: "Login sucess",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.black,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
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
}
