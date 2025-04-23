import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/screens/home_screen.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../modules/widgets/base_button.dart';
import '../modules/widgets/base_formfiled.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class OtpVerficationScreen extends StatefulWidget {
  String mobileno;
  String verification_id;
   OtpVerficationScreen({super.key, required this.mobileno, required this.verification_id});

  @override
  State<OtpVerficationScreen> createState() => _OtpVerficationScreenState();
}

class _OtpVerficationScreenState extends State<OtpVerficationScreen> {
  String? name="monika";
  // final FirebaseAuth _auth = FirebaseAuth.instance;


  bool? _isVisible;



  Future<void> verifyPhoneNumber(String phoneNumber) async {

    final FirebaseAuth auth = FirebaseAuth.instance;

    print('phoneauth======ppp===111111');

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId:widget.verification_id,
        smsCode: usernameController.text.toString(),
      );
      final User user = (await auth.signInWithCredential(credential)).user!;
      print(user.emailVerified);
      print(user.phoneNumber);
      print(user.displayName);
      print(credential.smsCode);
      print('phoneauth======ppp===222222');
    //  Widgets.showToast('Successfully signed in UID: ${user.uid}');

      getProfileData(phoneNumber);

    //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      //    HomeScreen()), (Route<dynamic> route) => false);

    } catch (e) {
      print('phoneauth======ppp===3333333');
    /*  Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);*/

      print(e);

      getProfileData(phoneNumber);
     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
       //   HomeScreen()), (Route<dynamic> route) => false);

   //   Widgets.showToast('Failed to sign in');
    }

    print('phoneauth======0000000');

   /* FirebaseAuth auth = FirebaseAuth.instance;

    print('phoneauth======1111111100');

    await auth.verifyPhoneNumber(
      phoneNumber: '+918005909280',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        print('phoneauth======22222200');
     *//*   print(credential.verificationId);
        print(credential.toString());


        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);*//*
      },
      verificationFailed: (FirebaseAuthException e) {

      print('phoneauth======33333300');
      print(e.code);
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

    },
      codeSent: (String verificationId, int? forceResendingToken) async{
        print('phoneauth======444444400');


        // Update the UI - wait for the user to enter the SMS code
        String smsCode = usernameController.text.toString();

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        print(credential.accessToken);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('phoneauth======5555555500');
      },

    );*/


    /* await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) {

      },
      verificationFailed: (FirebaseAuthException e) {

      },
      codeSent: (String verificationId, int? resendToken) {

      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );*/


  }


  Future<void> getProfileData(String mobile) async{
    print('tttttyyy====1111111');
    SharedPreferences pref= await SharedPreferences.getInstance();
    print("get_preference_data===");
    print(pref.getString("is_login"));
    print(pref.getString("fcmToken"));
    print('my_token_start===');


    /*final Map<String, String> headers = {
      'accept': 'application/json',
      'sid': pref.getString("user_token").toString(),
      'Content-Type': 'application/json'
    };
*/
      final response = await http.get(Uri.parse("https://lytechxagency.website/Laravel_GoogleSheet/customer_detail?Phone=$mobile"),
      //final response = await http.get(Uri.parse("https://lytechxagency.website/Laravel_GoogleSheet/customer_detail?Phone=9826905515"),
  //final response = await http.get(Uri.parse("https://lytechxagency.website/Laravel_GoogleSheet/customer_detail?Phone=9826905515"),
      //  headers: headers,
    );


    print("getProftl====data");
    print(response.body.toString());

    if (response.statusCode == 200) {
      print('getProfile====1111');



      final Map<String, dynamic> responseData = json.decode(response.body);


      print("getProftl====");
      print(responseData.toString());


      if(  responseData['status'].toString() == "false"){

        print('user_data====false');

        setState(() {
          isLoading=false;
        });

        showDialogBoxLogout();

        Fluttertoast.showToast(
            msg: responseData['userData'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);


      }else{
        print('user_data====true');
        print('res000=======');
        print(responseData['userData']['Name']);
        print(responseData['userData']['Primary Customer Name']);

        print(responseData['userData']['Address']);
        print(responseData['userData']['Contact No']);
        print(responseData['userData']['Aadhar Card']);
        print(responseData['userData']['Pan Card']);
        print(responseData['userData']['Email']);
       // print(responseData['userData']['Property No.']);


        SharedPreferences pref= await SharedPreferences.getInstance();
        pref.setString('is_login', "true");
        pref.setString('name', responseData['userData']['Name'].toString());
      //  pref.setString('primary_customer_name', responseData['userData'][0]['Primary Customer Name']);
        pref.setString('address', responseData['userData']['Address'].toString());
        pref.setString('primary_contact_no', responseData['userData']['Contact No'].toString());
        pref.setString('primary_person_aadhar_no', responseData['userData']['Aadhar Card'].toString());
        pref.setString('primary_person_pan_no', responseData['userData']['Pan Card'].toString());
        pref.setString('email_id', responseData['userData']['Email'].toString());
        pref.setString('customer_id', responseData['userData']['Customer Id'].toString());
        pref.setString('birthday', responseData['userData']['Birthday'].toString());
        pref.setString('anniversary', responseData['userData']['Anniversary'].toString());
        pref.setString('emergency_name', responseData['userData']['Emergency name'].toString());
        pref.setString('emergency_no', responseData['userData']['Emergency No'].toString());




        updateToken( mobile, pref.getString("fcmToken").toString());







        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
/*

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            HomeScreen()), (Route<dynamic> route) => false);
*/


      }




    } else {
      setState(() {
        isLoading=false;
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
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds){
          timer.cancel();
          setState(() {
            _isVisible=true;
          });
        }
      });
    });
  }


  @override
  void initState() {
    super.initState();
//    getProfileData();

   // verifyPhoneNumber("+911234567890");


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


    _isVisible=false;

  }


  void _resendCode() {
    //other code here
    setState((){
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  dispose(){
    timer!.cancel();
    super.dispose();

    _timer.cancel();

  }

  TextEditingController usernameController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  //bool isLoading=false;

  int secondsRemaining = 30;
  bool enableResend = true;
  Timer? timer;


  void verifyOtp(){

    print('get_opt_widget====${widget.verification_id.toString()}');
    print('get_opt_widget====${usernameController.text.toString()}');

    if(widget.verification_id.toString() == usernameController.text.toString()){
      // OTP is Valid
      print('get_check====valid');


      getProfileData(widget.mobileno.toString());

    } else{
      setState(() {
        isLoading=false;
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
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/mainlogo.png',width: 123,height: 73,),
                  Image.asset('assets/home_screen_welcome.png'),

                  const SizedBox(height: 10,),

                  BaseTextFormFiled(controller: usernameController, hintText: 'Enter the OTP',
                    preffix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset('assets/call.png',width: 25, height:25,),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 25,),
                  isLoading ? const SpinKitChasingDots(
                    //  isLoading? SpinKitRotatingCircle(
                    color: Colors.red,
                    size: 80.0,
                    //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                  )  :
                  BaseButton(onPress: (){
                    setState(() {
                      isLoading=true;
                    });
                    if(usernameController.text.toString().isEmpty){

                      setState(() {
                        isLoading=false;
                      });

                      Fluttertoast.showToast(
                          msg: "Request OTP",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);



                    }else{
                      verifyOtp();
                    }
                  },title: "Log In",fontSize: 16,),

                  const SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: FractionalOffset.bottomRight,
                    child: _isVisible! ? GestureDetector(
                      onTap: (){
                        setState(() {
                          _isVisible=false;
                          startTimeout();
                        });
                        sendOtp(widget.mobileno);

                      },
                      child: const Text('Resend Otp',style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w600
                      ),),
                    ):  Text(timerText,),
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


    final response = await http.post(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Sendotp'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {


      final jsonResponse = json.decode(response.body);
      print("response_gateway===");
      print(jsonResponse);
      //  dynamic status = jsonResponse['responseCode'].toString();
      //  dynamic bank_name = jsonResponse['data']['bankname'].toString();

      if(jsonResponse['status'].toString().toLowerCase() == "true"){

        print('check_condition====ifotp');
        print(jsonResponse['status'].toString());
        print(jsonResponse['msg'].toString());
        print(jsonResponse['otp'].toString());

        setState(() {
          isLoading=false;
        });
        getProfileData(mobileno);

      }else{


        print('check_condition====else');
        print(jsonResponse['status'].toString());
        print(jsonResponse['msg'].toString());

        setState(() {
          isLoading=false;
        });

        Fluttertoast.showToast(
            msg: '${jsonResponse['msg'].toString()} Please check your mobile no',
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

  showDialogBoxLogout(){
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
              child: const Text("OK",style: TextStyle(
                  color: Colors.white
              ),),
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


    final response = await http.post(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/UpdateFiraBaseKey'),
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
      isLoading=false;
    });


    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        const HomeScreen()), (Route<dynamic> route) => false);






  }





}
