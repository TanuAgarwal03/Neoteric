import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';

class AddReferalScreen extends StatefulWidget {
  const AddReferalScreen({super.key});

  @override
  State<AddReferalScreen> createState() => _AddReferalScreenState();
}

class _AddReferalScreenState extends State<AddReferalScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController appartmentController = TextEditingController();
  TextEditingController referalNameController = TextEditingController();
  TextEditingController referalPhoneController = TextEditingController();
  TextEditingController referalEmailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSharedPerferenceData();
  }

  String? calling_no;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFEC3B4),
                  Color(0xFFFF8F72),
                ],
                begin: AlignmentDirectional.bottomCenter,
                end: AlignmentDirectional.topCenter,
              )),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                addText(
                                    'Back', Colors.black, 12, FontWeight.w400),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: addAlignedText('Add Referal', Colors.black,
                                14, FontWeight.w600),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                          const WhatsappIcon(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 30,),
                    const Text(
                      'User Name*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: nameController,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Phone No*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: phoneController,
                        enabled: false,
                        style: const TextStyle(fontSize: 16),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Apartment no*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: appartmentController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Referral Name*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: referalNameController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Referral Phone no*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: referalPhoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Referral Email*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: referalEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Description*',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // height: 65,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        minLines: 7,
                        keyboardType: TextInputType.multiline,
                        maxLines: 12,
                        controller: descriptionController,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 45,
                    ),
                    isLoading
                        ? const SpinKitChasingDots(
                            //  isLoading? SpinKitRotatingCircle(
                            color: Colors.red,
                            size: 80.0,
                            //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                isLoading = true;
                              });

                              if (appartmentController.text
                                  .toString()
                                  .isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter Appartment no",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (referalNameController.text
                                  .toString()
                                  .isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter Referal Name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (referalPhoneController.text
                                  .toString()
                                  .isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter Referal Phone",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (descriptionController.text
                                  .toString()
                                  .isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter Description",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                addDataToServer(
                                    nameController.text.toString(),
                                    appartmentController.text.toString(),
                                    phoneController.text.toString(),
                                    descriptionController.text.toString());
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                gradient: LinearGradient(colors: [
                                  Color(0xffFF3D00),
                                  Color(0xffFF2E00)
                                ]),
                              ),
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              )),
                            ),
                          ),
                    const SizedBox(
                      height: 28,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addDataToServer(
      String name, String email, String phoneNo, String description) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      /* "user_name":"Arjun",
    "user_contact":"9874456254",
    "user_apartment_no":"115",
    "referral_name":"Yuvraj",
    "referral_contact_no":"9787421452",
    "referral_email":"ak@gmail.com",
    "property_description":"2 BHK",*/

      "user_name": name,
      "user_contact": phoneNo,
      "user_apartment_no": email,
      "referral_name": referalNameController.text.toString(),
      "referral_contact_no": referalPhoneController.text.toString(),
      "referral_email": referalEmailController.text.toString(),
      "property_description": description,

      // Add any other required fields in the request body
    };

    final response = await http.post(
      Uri.parse(
          'https://lytechxagency.website/Laravel_GoogleSheet/Property_referral'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('ghet_referal===');
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        // nameController.text="";
        appartmentController.text = "";
        referalNameController.text = "";
        referalPhoneController.text = "";
        referalEmailController.text = "";

        descriptionController.text = "";
      });

      print("contact_us======");
      print(response.body.toString());

      final jsonResponse = json.decode(response.body);

      print(jsonResponse['msg'].toString());

      Fluttertoast.showToast(
          msg: jsonResponse['msg'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

// DD:0F:66:97:21:59:29:00:B7:95:CF:4C:C5:23:3B:14:04:B3:78:B0:70:C5:CC:D2:8D:BE:B4:1C:0D:8F:3A:F7
  void getSharedPerferenceData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString("primary_customer_name"));
    print(pref.getString("primary_contact_no"));

    setState(() {
      nameController.text = pref.getString("name").toString();
      phoneController.text = pref.getString("primary_contact_no").toString();
      calling_no = pref.getString("call_no").toString();
    });
  }
}
