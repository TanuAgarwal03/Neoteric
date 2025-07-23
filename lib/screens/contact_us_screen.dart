import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  String? calling_no;

  @override
  void initState() {
    getSharedPerferenceData();
    super.initState();
  }

  void getSharedPerferenceData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      nameController.text = pref.getString("name").toString();
      phoneController.text = pref.getString("primary_contact_no").toString();
      calling_no = pref.getString("call_no").toString();
    });
  }

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
                            child: addAlignedText('Contact Us', Colors.black,
                                14, FontWeight.w600),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                          const WhatsappIcon(),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Align(
                    //       alignment: Alignment.centerLeft,
                    //       child: SizedBox(
                    //         width: 140,
                    //         child: IconButton(
                    //           padding: EdgeInsets.zero,
                    //           icon: Row(
                    //             children: [
                    //               const Icon(
                    //                 Icons.keyboard_arrow_left,
                    //                 color: Colors.black,
                    //                 size: 28,
                    //               ),
                    //               addText('Back', Colors.black, 12,
                    //                   FontWeight.w400),
                    //             ],
                    //           ),
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     addAlignedText('Contact Us', Colors.black, 14,
                    //         FontWeight.w600),
                    //     Expanded(
                    //         child: Align(
                    //           alignment: Alignment.centerRight,
                    //           child: const WhatsappIcon(),
                    //         )),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 30,),
                    const Text(
                      'Full Name*',
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
                        color: const Color(0xffF3F3F3),
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
                        color: const Color(0xffF3F3F3),
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
                      'Email*',
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
                        color: const Color(0xffF3F3F3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1)),
                      ),
                      child: TextField(
                        controller: emailController,
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
                        color: const Color(0xffF3F3F3),
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

                              if (nameController.text.toString().isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (emailController.text
                                  .toString()
                                  .isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter Email",
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
                              } else if (phoneController.text
                                      .toString()
                                      .isEmpty ||
                                  phoneController.text.toString().length !=
                                      10) {
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Enter 10 digit phone no",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                addDataToServer(
                                    nameController.text.toString(),
                                    emailController.text.toString(),
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

                    //SizedBox(height: 30,),
                    //
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //         width:130,
                    //         child: Divider(thickness: 1,color: Colors.grey,)),
                    //     Container(
                    //       width: 45,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color: Color(0xffF3F0FF)
                    //           ),
                    //           borderRadius: BorderRadius.all(Radius.circular(24)),
                    //           color: Color(0xffF3F0FF)
                    //       ),
                    //       child: Center(child: Padding(
                    //         padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text('OR',style: TextStyle(
                    //                 color: Color(0xff9E91DA),
                    //                 fontSize: 12,
                    //               fontWeight: FontWeight.w600
                    //             ),),
                    //           ],
                    //         ),
                    //       )),
                    //     ),
                    //     SizedBox(
                    //         width:130,
                    //         child: Divider(thickness: 1,color: Colors.grey,)),
                    //   ],
                    // ),
                    // SizedBox(height: 30,),
                    //
                    //
                    // Center(
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     child: Text('Call now',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w600,
                    //         color: Color(0xff1A1E25)
                    //     ),),
                    //   ),
                    // ),
                    // SizedBox(height: 17,),
                    // GestureDetector(
                    //   onTap: () async{
                    //     final Uri launchUri = Uri(
                    //       scheme: 'tel',
                    //       path: "+91 ${calling_no!.toString()}",
                    //     );
                    //     await launchUrl(launchUri);
                    //
                    //
                    //   },
                    //   child:  Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //
                    //       borderRadius: BorderRadius.all(Radius.circular(30)),
                    //       gradient: LinearGradient(colors: [Color(0xffFF3D00), Color(0xffFF2E00)]),
                    //     ),
                    //     child: Center(child: Padding(
                    //       padding: const EdgeInsets.only(top: 10,bottom: 10),
                    //       child: Text(calling_no!,style: TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 16
                    //       ),),
                    //     )),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 28,
                    ),

                    /*    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Text('Services',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),),

                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color(0xffE0E0E0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25,left: 27,bottom: 25,right: 27),
                            child: Column(

                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(

                                      onTap: (){

                                        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ContactUsScreen()), (Route<dynamic> route) => false);
                                      //  Navigator.of(context).push(MaterialPageRoute(
                                        //  builder: (context) => ContactUsScreen(),
                                       // ));

                                      },
                                      child: Container(
                                          width: 128,
                                          height: 49,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                //  Icon(Icons.support_agent),
                                                Image.asset('assets/contacts.png',width: 22,height: 22,),
                                                SizedBox(width: 7,),
                                                Text('Contact US',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xff000000)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        // RentingScreen()), (Route<dynamic> route) => false);
                                        // RepairPropertyRequestScreen()), (Route<dynamic> route) => false);

                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => RentingScreen(),
                                        ));

                                      },
                                      child: Container(
                                          width: 128,
                                          height: 49,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children:  [
                                                // Icon(Icons.house),
                                                Image.asset('assets/renting.png',width: 22,height: 22,),
                                                SizedBox(width: 7,),
                                                Text('Renting',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xff000000)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        //   RequestDocumentScreen()), (Route<dynamic> route) => false);

                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => RequestDocumentScreen(),
                                        ));

                                      },
                                      child: Container(
                                          width: 128,
                                          height: 49,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.document_scanner),
                                                Image.asset('assets/request.png',width: 22,height: 22,),
                                                SizedBox(width: 7,),
                                                Text('Request \nDocuments',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xff000000)
                                                  ),),
                                              ],
                                            ),
                                          )),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          // ComplaintScreen()), (Route<dynamic> route) => false);
// 

                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ComplaintScreen(),
                                        ));


                                      },
                                      child: Container(
                                          width: 128,
                                          height: 49,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Image.asset('assets/complaint.png',width: 22,height: 22,),
                                                // Icon(Icons.message_sharp),
                                                SizedBox(width: 7,),
                                                Text('Service\nRequest',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xff000000)
                                                  ),),
                                              ],
                                            ),
                                          )),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    GestureDetector(
                                      onTap: (){


                                        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        //    RepairPropertyRequestScreen()), (Route<dynamic> route) => false);


                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => RepairScreen(),
                                        ));



                                      },
                                      child: Container(
                                          width: 128,
                                          height: 49,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                // Icon(Icons.home_repair_service),
                                                Image.asset('assets/service.png',width: 22,height: 22,),
                                                SizedBox(width: 7,),
                                                Text('Service & Rep.',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xff000000)
                                                  ),),
                                              ],
                                            ),
                                          )),
                                    ),


                                    Container(
                                        width: 128,
                                        height: 49,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: Colors.white
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Icon(Icons.group),
                                              Image.asset('assets/consultancy.png',width: 22,height: 22,),
                                              SizedBox(width: 7,),
                                              Text('Free\nConsultancy',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: Color(0xff000000)
                                                ),),
                                            ],
                                          ),
                                        )),


                                  ],
                                ),
                                */ /*  SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.group),
                                          SizedBox(width: 7,),
                                          Text('Free\nConsultancy',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),),
                                        ],
                                      ),
                                    )),

                                Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.monetization_on_rounded),
                                          SizedBox(width: 7,),
                                          Text('Loans',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),),
                                        ],
                                      ),
                                    )),

                              ],
                            ),*/ /*
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height: 35,),*/
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
      "name": name,
      "contact_no": phoneNo,
      "email": email,
      "description": description,

      // Add any other required fields in the request body
    };

    final response = await http.post(
      Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/ContactUs'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        // nameController.text="";
        emailController.text = "";
        phoneController.text = "";
        descriptionController.text = "";
      });

      // final List result = jsonDecode(response.body);
      //  final Map<String, dynamic> data = json.decode(response.body);
      // final List<dynamic> dataList = data['data'];
      // return dataList.map((itemJson) => GameListModel.fromJson(itemJson)).toList();
      // return result.map((e) => GameListModel.fromJson(e)).toList();

      // final Map<String, dynamic> responseData = json.decode(response.body);

      print("contact_us======");
      //print(responseData.toString());

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
}
