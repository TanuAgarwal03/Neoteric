import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/screens/home_screen.dart';
import 'package:neoteric_flutter/screens/otp_verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../modules/widgets/base_button.dart';
import '../modules/widgets/base_formfiled.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? name="monika";
  String? _verificationId="";
 // final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> verifyPhoneNumber(String phoneNumber) async {

    print('phoneauth======0000000');

    FirebaseAuth auth = FirebaseAuth.instance;

    print('phoneauth======11111111');

    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        print('phoneauth======222222');
        print(credential.verificationId);
        print(credential.toString());


        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      }, verificationFailed: (FirebaseAuthException e) {

      print('phoneauth======333333');
      print(e.code);
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

    },
      codeSent: (String verificationId, int? forceResendingToken) {
        print('phoneauth======4444444');
        print(verificationId);
        _verificationId=verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('phoneauth======55555555');



      },

    );

    codeSent(String verificationId, [int? forceResendingToken]) async {

      Fluttertoast.showToast(
          msg: "Please check your phone for the verification code.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      _verificationId = verificationId;
    }





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
    print('my_token_start===');
    print(pref.getString("user_token"));
    print('my_token_end===');

    /*final Map<String, String> headers = {
      'accept': 'application/json',
      'sid': pref.getString("user_token").toString(),
      'Content-Type': 'application/json'
    };
*/
    final response = await http.get(Uri.parse("https://lytechxagency.website/Laravel_GoogleSheet/customer_detail?Phone=$mobile"),
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

      print('res000=======');
      print(responseData['userData']['Name']);

      print(responseData['userData']['Address']);
      print(responseData['userData']['Contact No']);
      print(responseData['userData']['Aadhar Card']);
      print(responseData['userData']['Pan Card']);
      print(responseData['userData']['Email']);
      print(responseData['userData']['Property No.']);

      print(responseData['userData']['Birthday']);
      print(responseData['userData']['Anniversary']);
      print(responseData['userData']['Emergency name']);
      print(responseData['userData']['Emergency No']);
      print(responseData['userData']['Property No.']);

      SharedPreferences pref= await SharedPreferences.getInstance();
      pref.setString('is_login', "true");
      pref.setString('name', responseData['userData']['Name']);
      pref.setString('address', responseData['userData']['Address']);
      pref.setString('primary_contact_no', responseData['userData']['Contact No']);
      pref.setString('primary_person_aadhar_no', responseData['userData']['Aadhar Card']);
      pref.setString('primary_person_pan_no', responseData['userData']['Pan Card']);
      pref.setString('email_id', responseData['userData']['Email']);
      pref.setString('customer_id', responseData['userData']['Customer Id'].toString());

      pref.setString('birthday', responseData['userData']['Birthday'].toString());
      pref.setString('anniversary', responseData['userData']['Anniversary'].toString());
      pref.setString('emergency_name', responseData['userData']['Emergency name'].toString());
      pref.setString('emergency_name', responseData['userData']['Emergency No'].toString());
      pref.setString('is_delete_customer', responseData['userData']['Is Delete Customer'].toString());


      setState(() {
        isLoading=false;
      });

      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          const HomeScreen()), (Route<dynamic> route) => false);


    } else {
      setState(() {
        isLoading=false;
      });
      throw Exception('Failed to load data');
    }

  }

  @override
  void initState() {
    super.initState();
//    getProfileData();




  }

  TextEditingController usernameController= TextEditingController();
 // TextEditingController passwordController= new TextEditingController();
  bool isLoading=false;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/mainlogo.png',width: 123,height: 73,),
                  Image.asset('assets/home_screen_welcome.png'),
                 BaseTextFormFiled(controller: usernameController, hintText: 'Mobile no.',
                 preffix: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10),
                   child: Image.asset('assets/call.png',width: 25, height:25,),
                 ),
                   keyboardType: TextInputType.phone,
                 ),

                 // SizedBox(height: 10,),


                  // Container(
                  //   height: 45,
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffEFEFEF),
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: Color(0xffA1A1A1)),
                  //   ),
                  //   child: TextField(
                  //     controller: usernameController,
                  //     style:TextStyle(fontSize:16),
                  //     keyboardType: TextInputType.phone,
                  //     decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //       filled: true,
                  //       hintStyle: TextStyle(color: Colors.grey[800], fontSize: 16),
                  //       hintText: "Mobile no.",
                  //
                  //       fillColor: Colors.white70,
                  //       //  prefixIcon: Icon(Icons.call, size: 24,color: Colors.grey,),
                  //         prefixIcon: Image.asset('assets/call.png',width: 25, height:25,),
                  //     ),
                  //   ),
                  // ),

                 /* SizedBox(height: 30,),
                  Text('Password',style: TextStyle(
                    fontSize: 18,
                  ),),*/
                /*  SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Insert your password here",
                      fillColor: Colors.white70,
                        prefixIcon: Icon(Icons.key, size: 24,color: Colors.grey,),
                    ),
                  ),
        */
                  const SizedBox(height: 20,),
                  isLoading ? const SpinKitChasingDots(
                    //  isLoading? SpinKitRotatingCircle(
                    color: Color(0xffFF3D00),
                    size: 80.0,
                    //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                  )  :
                  BaseButton(onPress: (){
                    setState(() {
                      isLoading=true;
                    });
                    if(usernameController.text.toString().isEmpty || usernameController.text.toString().length != 10){

                      setState(() {
                        isLoading=false;
                      });

                      Fluttertoast.showToast(
                          msg: "Enter 10 digit mobile no",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);



                    }else{


                      sendOtp(usernameController.text.toString());
                      //  verifyPhoneNumber(usernameController.text.toString());

                      // Navigator.of(context).push(MaterialPageRoute(
                      //  builder: (context) => OtpVerficationScreen(mobileno: usernameController.text.toString(),verification_id:_verificationId.toString()),
                      //  ));
                      //   getProfileData(usernameController.text.toString());

                    }
                  },title: "Request OTP",fontSize: 16,),



               //   SizedBox(height: 35,),

                  const SizedBox(height: 10,),

                  const Text('This app is only for existing Neoteric customers',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700
                    ),),

                /*  SizedBox(height: 15,),

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          RegisterScreen()), (Route<dynamic> route) => false);

                    },
                    child: Center(
                      child: Text('Dont have account register?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      ),),
                    ),
                  ),*/




                  const SizedBox(height: 35,),








                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width:130,
                          child: Divider(thickness: 1,color: Colors.grey,)),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffF3EEFF)
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color(0xffF3EEFF)
                        ),
                        child: Center(child: Padding(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('OR',style: TextStyle(
                                  color: Color(0xffB7ABE8),
                                  fontSize: 18
                              ),),
                            ],
                          ),
                        )),
                      ),
                      SizedBox(
                          width:130,
                          child: Divider(thickness: 1,color: Colors.grey,)),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black
                    ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apple, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text('Sign in with Apple',style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),),
                        ],
                      ),
                    )),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white
                    ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google_icon.png', width: 20, height: 20,),

                          SizedBox(width: 10,),
                          Text('Sign in with Google',style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),),
                        ],
                      ),
                    )),
                  ),
        */




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

        print('check_condition====if');
        print(jsonResponse['status'].toString());
        print(jsonResponse['msg'].toString());
        print(jsonResponse['otp'].toString());

        setState(() {
          isLoading=false;
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
          builder: (context) => OtpVerficationScreen(mobileno: usernameController.text.toString(),verification_id:jsonResponse['otp'].toString()),
          ));



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




}
