import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {


  String? customer_id="";
  String? name="";
  String? contact_no="";
  String? email="";
  String? pan_card="";
  String?  aadhar_card="";
  String?  adderss="";
  String?  birthday="";
  String?  anniversary="";

  bool? isLoading= false;

  TextEditingController nameController= TextEditingController();
  TextEditingController mobileController= TextEditingController();


  @override
  void initState() {
    super.initState();

    getDataFromSharedPerference();


  }


  void addDataToServer() async {

    String name=nameController.text.toString();
    String mobile=mobileController.text.toString();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "emergency_name": nameController.text.toString(),
      "emergency_no": mobileController.text.toString(),
      "customer_contact_no": contact_no,


      // Add any other required fields in the request body
    };


    final response = await http.post(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Customer_Extra_fields'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading=false;
       // nameController.text="";

      });





      final jsonResponse = json.decode(response.body);

      print('user_response=====');
      print(jsonResponse['message'].toString());

      Fluttertoast.showToast(
          msg: jsonResponse['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() async{
        isLoading=false;
        nameController.text=name;
        mobileController.text=mobile;

        SharedPreferences pref= await SharedPreferences.getInstance();
        pref.setString('emergency_name', name);
        pref.setString('emergency_no', mobile);



      });

    } else {
      setState(() {
        isLoading=false;
      });
      throw Exception('Failed to load data');
    }




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
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.black,
                                  size: 28,
                                ),
                                addText('Back', Colors.black, 12,
                                    FontWeight.w400),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.65,
                            child: addAlignedText('User Profile', Colors.black, 14,
                                FontWeight.w600),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                          const WhatsappIcon(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),
                      const SizedBox(width: 50,),
                      Flexible(
                        child: Text(name!,style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            //color: Color(0xff1A1E25)
                            color: Colors.black
                        ),),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Contact No',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      Text(contact_no!,style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          //color: Color(0xff1A1E25)
                          color: Colors.black
                      ),),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Email',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),
                      Text(email!,style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          //color: Color(0xff1A1E25)
                          color: Colors.black
                      ),),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pan Card',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),
                      Text(pan_card!,style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          //color: Color(0xff1A1E25)
                          color: Colors.black
                      ),),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Aadhar Card',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),
                      Text(aadhar_card!,style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          //color: Color(0xff1A1E25)
                          color: Colors.black
                      ),),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Address',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),
                      const SizedBox(width: 50,),
                      Text(adderss!,style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          //color: Color(0xff1A1E25)
                          color: Colors.black
                      ),),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Birthday + Anniversary',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),
                      Text('${birthday!} $anniversary',style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          //color: Color(0xff1A1E25)
                          color: Colors.black
                      ),),
                    ],
                  ),

                  const SizedBox(height: 22,),
                  const Text('Enter Details',style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1A1E25)
                  ),),

                  const SizedBox(height: 15,),
                  const Text('Emergency name*',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1E25)
                  ),),
                  const SizedBox(height: 5,),
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
                      keyboardType: TextInputType.name,
                      style:const TextStyle(fontSize:16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  const Text('Emergency no*',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1E25)
                  ),),
                  const SizedBox(height: 5,),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffA1A1A1)),
                    ),
                    child: TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      style:const TextStyle(fontSize:16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 45,),
                  isLoading! ?  const SpinKitChasingDots(
                    //  isLoading? SpinKitRotatingCircle(
                    color: Colors.red,
                    size: 80.0,
                    //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                  ) :
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isLoading=true;
                      });

                      if(nameController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(mobileController.text.toString().isEmpty || mobileController.text.toString().length != 10){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter 10 digit phone no",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else{
                        addDataToServer();

                      }




                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: LinearGradient(colors: [Color(0xffFF3D00), Color(0xffFF2E00)]),
                      ),
                      child: const Center(child: Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Text('Submit',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),),
                      )),
                    ),
                  ),


                  const SizedBox(height: 40,),

                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  void getDataFromSharedPerference() async{


    SharedPreferences pref= await SharedPreferences.getInstance();
    print(pref.getString("primary_customer_name"));
    print(pref.getString("primary_contact_no"));

    setState(() {
      name=pref.getString("name").toString();
      nameController.text=pref.getString("emergency_name").toString();
      contact_no=pref.getString("primary_contact_no").toString();
      mobileController.text=pref.getString("emergency_no").toString();
      email=pref.getString("email_id").toString();
      pan_card=pref.getString("primary_person_pan_no").toString();
      aadhar_card=pref.getString("primary_person_aadhar_no").toString();
      adderss=pref.getString("address").toString();
      birthday=pref.getString("birthday").toString();
      anniversary=pref.getString("anniversary").toString();

    });




  }



}
