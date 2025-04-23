import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/models/all_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';


class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {

  TextEditingController nameController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();

  bool isLoading= false;

  List<AllCategoryModel> _projectsData = [];
  String? _selectedProject;
  String? calling_no;
@override
  void initState() {
    super.initState();
    getDataFromSharedPreferance();
    fetchData();

  }


  void fetchData() async {
    final response = await http.get(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/All_Category'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> projectsData = data['requestData'];

      setState(() {
        //ProjectData
        _projectsData = projectsData.map((data) => AllCategoryModel.fromJson(data)).where((project) => project.type == 'Department').toList();

        print('get_res_category=====');
        print(_projectsData.first.name);

      });
    } else {
      throw Exception('Failed to load data');
    }

 }



  void addDataToServer() async {

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "name": nameController.text.toString(),
      "contact_no": phoneController.text.toString(),
      "department": _selectedProject.toString(),
      "narration": descriptionController.text.toString(),

      // Add any other required fields in the request body
    };


    final response = await http.post(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Feedback'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading=false;
      //  nameController.text="";
       // phoneController.text="";
        descriptionController.text="";
      });





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

      setState(() {
        isLoading=false;
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
    return  Scaffold(
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
                            child: addAlignedText('Feedback', Colors.black, 14,
                                FontWeight.w600),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                          const WhatsappIcon(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 30,),
                    const Text('Name*',style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1A1E25)
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F3F3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1) ,width: 0.5),
                      ),
                      child: TextField(
                        controller: nameController,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        style:const TextStyle(fontSize:16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    const Text('Contact No*',style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1A1E25)
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F3F3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1) ,width: 0.5),
                      ),
                      child: TextField(
                        controller: phoneController,
                        enabled: false,
                        style:const TextStyle(fontSize:16),
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),




                    const SizedBox(height: 15,),


                    const Text('Department*',style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1A1E25)
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffA1A1A1)
                              ,width: 0.5
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),

                          color: const Color(0xffF3F3F3)
                      ),

                      //  color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 15),
                        child: DropdownButton<String>(
                          underline: const SizedBox(),
                          isExpanded: true,
                          hint: const Text("Select Project"), // Hint added here
                          value: _selectedProject,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedProject = newValue;
                              print('getSelection======');
                              print(_selectedProject);
                              print(newValue);

                            });
                          },
                          items: [
                           /* DropdownMenuItem(
                              value: null,
                              child: Text("Select Department"),
                            ),*/
                            ..._projectsData.map<DropdownMenuItem<String>>((AllCategoryModel project) {
                              return DropdownMenuItem<String>(
                                value: project.name,
                                child: Row(
                                  children: [

                                   // SizedBox(width: 15),
                                    Text(project.name!),

                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(height: 15,),
                    const Text('Description*',style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1A1E25)
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      // height: 65,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F3F3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffA1A1A1),width: 0.5),
                      ),
                      child: TextField(
                        minLines: 7,
                        keyboardType: TextInputType.multiline,
                        maxLines: 12,
                        controller: descriptionController,

                        style:const TextStyle(fontSize:16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),




                    const SizedBox(height: 45,),
                    isLoading ?  const SpinKitChasingDots(
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

                         if(descriptionController.text.toString().isEmpty){
                          setState(() {
                            isLoading=false;
                          });
                          Fluttertoast.showToast(
                              msg: "Enter Description",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);

                        }
                        else if(_selectedProject.toString().isEmpty || _selectedProject.toString() == "null"){

                          setState(() {
                            isLoading= false;
                          });

                          Fluttertoast.showToast(
                              msg: "Select Department",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        else{

                          addDataToServer();

                         // addDataToServer(nameController.text.toString(),
                           //   emailController.text.toString(), phoneController.text.toString(), descriptionController.text.toString());


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


                    // SizedBox(height: 30,),
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
                    //                 fontWeight: FontWeight.w600
                    //             ),),
                    //           ],
                    //         ),
                    //       )),
                    //     ),
                    //     // SizedBox(
                    //     //     width:130,
                    //     //     child: Divider(thickness: 1,color: Colors.grey,)),
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
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(0xff1A1E25)
                    //       ),),
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
                    const SizedBox(height: 28,),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDataFromSharedPreferance() async{


    SharedPreferences pref= await SharedPreferences.getInstance();


    setState(() {
      nameController.text=pref.getString("name").toString();
      phoneController.text=pref.getString("primary_contact_no").toString();
      calling_no=pref.getString("call_no").toString();

    });

  }
}
