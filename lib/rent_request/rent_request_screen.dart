import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neoteric_flutter/models/property_tyype/view_all_proprerties_model.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

import '../providers/home_provider.dart';
import '../widgets/whatsappicon.dart';

class RentRequestScreen extends StatefulWidget {
  const RentRequestScreen({super.key});

  @override
  State<RentRequestScreen> createState() => _RentRequestScreenState();
}

class _RentRequestScreenState extends State<RentRequestScreen> {

  TextEditingController nameController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
 // TextEditingController propertyNameController= new TextEditingController();
  TextEditingController tenantTenureController= TextEditingController();
  TextEditingController expectedRentController= TextEditingController();
  TextEditingController lastRentController= TextEditingController();
  TextEditingController securityAmountDepositController= TextEditingController();
  TextEditingController bankController= TextEditingController();
  TextEditingController accountNoController= TextEditingController();
  TextEditingController ifscController= TextEditingController();
  TextEditingController beneficiaryNameController= TextEditingController();
  final List<String> _rentappartmenttype = ['1 BHK', '2 BHK',"3 BHK"]; // Option 2
  String isFurnished="yes";
  String isAirConditioner="yes";
  String isKitchen="yes";
  String isBed="yes";
  String isWardrobe="yes";
  String isRo="yes";
  String isMaintanance="yes";
  String isParking="Open";
  String isTenantType="Family";
  String isTenantService="PSU";
  String _appratmentType="1 BHK";




  bool isSwitched = false;
  bool isLoading=false;


  String? _selectedPropertyData;
  String? _selectedPropertyName;
  String? _selectedPropertyId;


  @override
  void initState() {
    if (HomeProvider.homeSharedInstanace.getProperties != null) {
      if ((HomeProvider.homeSharedInstanace.getProperties?.length ?? 0) > 0) {
        HomeProvider.homeSharedInstanace.changePropertyDetails(
            HomeProvider.homeSharedInstanace.getProperties![0]);
      }
    }
    getDataFromSharedPreferance();
    super.initState();
  }




  void getDataFromSharedPreferance() async{


    SharedPreferences pref= await SharedPreferences.getInstance();


    setState(() {
      nameController.text=pref.getString("name").toString();
      phoneController.text=pref.getString("primary_contact_no").toString();


    });

  }

  void addDataToServer() async {

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "project_id":HomeProvider.homeSharedInstanace.getPropertiesDetails?.property_id??"",
      "property_name": HomeProvider.homeSharedInstanace.getPropertiesDetails?.project_name??"",
      "owner_name": nameController.text.toString(),
      "owner_contact": phoneController.text.toString(),
    //  "property_name": propertyNameController.text.toString(),
      "furnished": isFurnished,
      "air_conditioner": isAirConditioner,
      "kitchen": isKitchen,
      "apartment_type": _appratmentType,
      "bed": isBed,
      "wardrobe": isWardrobe,
      "ro": isRo,
      "parking": isParking,
      "tenant_type": isTenantType,
      "tenant_service": isTenantService,
      "tenant_tenure": tenantTenureController.text.toString(),
      "expected_rent": expectedRentController.text.toString(),
      "last_rent": lastRentController.text.toString(),
      "maintenance_included_in_rent": isMaintanance.toString(),
      "security_deposit_amount": securityAmountDepositController.text.toString(),
      "bank": bankController.text.toString(),
      "account_no": accountNoController.text.toString(),
      "ifse": ifscController.text.toString(),
      "beneficiary_name": beneficiaryNameController.text.toString(),
      "Unit_No": HomeProvider.homeSharedInstanace.getPropertiesDetails?.unit_no??"",



      // Add any other required fields in the request body
    };


    final response = await http.post(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/property_rent_store'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading=false;
        //propertyNameController.text="";
        tenantTenureController.text="";
        expectedRentController.text="";
        lastRentController.text="";
        isMaintanance="yes";
        securityAmountDepositController.text="";
        bankController.text="";
        accountNoController.text="";
        ifscController.text="";
        beneficiaryNameController.text="";
        _appratmentType="1 BHK";
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
                            child: addAlignedText('Rent Request', Colors.black, 14,
                                FontWeight.w600),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                          const WhatsappIcon(),
                        ],
                      ),
                    ),
                    Consumer<HomeProvider>(
                        builder: (context, getproperties, child) {
                          return (getproperties.getProperties?.length ?? 0) > 0
                              ? Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    if (getproperties.getPropertiesDetails !=
                                        null)
                                      Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    addText(
                                                        getproperties
                                                            .getPropertiesDetails
                                                            ?.project_name ??
                                                            "",
                                                        const Color(0xFF303030),
                                                        13,
                                                        FontWeight.w500),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/location.png",
                                                          height: 8,
                                                          width: 8,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        addText(
                                                            getproperties
                                                                .getPropertiesDetails
                                                                ?.location??"",
                                                            const Color(0xFF797979),
                                                            10,
                                                            FontWeight.w500),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: SizedBox(
                                                  width: 100,
                                                  child: InkWell(
                                                    onTap: () {
                                                      getproperties
                                                          .changeAllProperty(
                                                          !getproperties
                                                              .showAllProperties);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        addText(
                                                            "Change Property",
                                                            const Color(0xFFFF3803),
                                                            11,
                                                            FontWeight.bold),
                                                        // const SizedBox(
                                                        //   width: 5,
                                                        // ),
                                                        // Image.asset(
                                                        //   "assets/forword.png",
                                                        //   height: 8,
                                                        //   width: 8,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (getproperties.showAllProperties) ...[
                                const SizedBox(
                                  height: 10,
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    color: Colors.white,
                                    child: ListView.builder(
                                      itemCount: getproperties
                                          .getProperties?.length ??
                                          0,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final propertyItem = getproperties
                                            .getProperties![index];
                                        return InkWell(
                                          onTap: () {
                                            getproperties
                                                .changePropertyDetails(
                                                propertyItem);
                                            getproperties.changeAllProperty(
                                                !getproperties
                                                    .showAllProperties);
                                          },
                                          child: Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(15),
                                                side: BorderSide(
                                                    color: propertyItem
                                                        .property_id
                                                        .toString() ==
                                                        getproperties
                                                            .getPropertiesDetails!
                                                            .property_id
                                                            .toString()
                                                        ? const Color(
                                                        0xFFFF3803)
                                                        : Colors.white)),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        addText(
                                                            "${propertyItem.project_name ??
                                                                  ""} (Unit- ${propertyItem.unit_no ?? ""})",
                                                            const Color(0xFF303030),
                                                            13,
                                                            FontWeight.w500),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/location.png",
                                                              height: 8,
                                                              width: 8,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            addText(
                                                                propertyItem
                                                                    .location ??
                                                                    "",
                                                                const Color(
                                                                    0xFF797979),
                                                                10,
                                                                FontWeight
                                                                    .w500),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                              ]
                            ],
                          )
                              : const SizedBox.shrink();
                        }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  // Text('Name*',style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xff1A1E25)
                  // ),),
                  // const SizedBox(height: 5,),
                  // Container(
                  //   height: 50,
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffEFEFEF),
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: Color(0xffA1A1A1)),
                  //   ),
                  //   child: TextField(
                  //     controller: nameController,
                  //    enabled: false,
                  //     keyboardType: TextInputType.name,
                  //     style:TextStyle(fontSize:16),
                  //     decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //     ),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 15,),
                  // Text('Contact No*',style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xff1A1E25)
                  // ),),
                  // SizedBox(height: 5,),
                  // Container(
                  //   height: 50,
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffEFEFEF),
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: Color(0xffA1A1A1)),
                  //   ),
                  //   child: TextField(
                  //     controller: phoneController,
                  //    enabled: false,
                  //     style:TextStyle(fontSize:16),
                  //     keyboardType: TextInputType.phone,
                  //     decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //     ),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 15,),



                  // Text('Property Name*',style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xff1A1E25)
                  // ),),
                  //
                  // SizedBox(height: 5,),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(
                  //           color: Color(0xffA1A1A1),
                  //           width: 1
                  //       ),
                  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //
                  //       color: Color(0xffEFEFEF)
                  //   ),
                  //
                  //   //  color: Colors.blue,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 10,right: 15),
                  //     child: DropdownButton<String>(
                  //       underline: SizedBox(),
                  //       isExpanded: true,
                  //       hint: Text("Select Request Category"), // Hint added here
                  //       value: _selectedPropertyData,
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           _selectedPropertyData = newValue;
                  //           print('getSelection======');
                  //           print(_selectedPropertyData);
                  //           print(newValue);
                  //
                  //           int idx = newValue!.indexOf("+");
                  //           List parts = [newValue.substring(0,idx).trim(), newValue.substring(idx+1).trim()];
                  //           print(newValue.substring(0,idx).trim());
                  //           print(newValue.substring(idx+1).trim());
                  //           _selectedPropertyName=newValue.substring(0,idx).trim();
                  //           _selectedPropertyId=newValue.substring(idx+1).trim();
                  //
                  //
                  //
                  //
                  //         });
                  //       },
                  //       items: [
                  //        /* DropdownMenuItem(
                  //           value: null,
                  //           child: Text("Select Request Category"),
                  //         ),*/
                  //         ..._PropertyListData.map<DropdownMenuItem<String>>((ViewAllPropertiesModel project) {
                  //           return DropdownMenuItem<String>(
                  //             value: '${project.project_name}+${project.property_id}',
                  //             child: Row(
                  //               children: [
                  //                 // SizedBox(width: 15),
                  //                 Text(project.project_name!),
                  //                 //SizedBox(width: 15),
                  //                 //Text('Property no ${project.property_id!}'),
                  //
                  //
                  //
                  //               ],
                  //             ),
                  //           );
                  //         }).toList(),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                /*  Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffA1A1A1)),
                    ),
                    child: TextField(
                      controller: propertyNameController,

                      style:TextStyle(fontSize:16),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),*/

                  //SizedBox(height: 20,),


                  const Text('Property Details',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1A1E25)
                  ),),
                  const Divider(thickness: 0.5,color: Colors.grey,),


                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Furnished*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');

                            if(index == 0){
                              isFurnished="yes";
                            }else{
                              isFurnished="no";
                            }

                          print('isFurnished====$isFurnished');
                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Air Conditioner*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isAirConditioner="yes";
                          }else{
                            isAirConditioner="no";
                          }

                          print('isAirConditioner====$isAirConditioner');


                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kitchen*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isKitchen="yes";
                          }else{
                            isKitchen="no";
                          }

                          print('isKitchen====$isKitchen');


                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bed*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');


                          if(index == 0){
                            isBed="yes";
                          }else{
                            isBed="no";
                          }

                          print('isBed====$isBed');


                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Wardrobe*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isWardrobe="yes";
                          }else{
                            isWardrobe="no";
                          }

                          print('isWardrobe====$isWardrobe');

                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Aquas Water Purifier RO*',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1A1E25)
                        ),),
                      ),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isRo="yes";
                          }else{
                            isRo="no";
                          }

                          print('isRo====$isRo');

                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Parking*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 90.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Open', 'Covered'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isParking="Open";
                          }else{
                            isParking="Covered";
                          }

                          print('isParking====$isParking');

                        },
                      ),


                    ],
                  ),


                  const SizedBox(height: 18,),

                  const Text('Apartment Type*',style: TextStyle(
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
                            color: const Color(0xffA1A1A1),
                            width: 0.5
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),

                        color: const Color(0xffEFEFEF)
                    ),

                    //  color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 15),
                      child: DropdownButton<String>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: const Text("Select Apartment Type",style: TextStyle(fontSize: 13),), // Hint added here
                        value: _appratmentType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _appratmentType = newValue.toString();
                            print('getSelection======');
                            print(_appratmentType);
                            print(newValue);
                          });
                        },
                        items: [
                          /* DropdownMenuItem(
                            value: null,
                            child: Text("Select Request Category"),
                          ),*/
                          ..._rentappartmenttype.map<DropdownMenuItem<String>>((String appratment) {
                            return DropdownMenuItem<String>(
                              value: appratment,
                              child: Text(appratment,style: const TextStyle(fontSize: 13),),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18,),

                  const Text('Lessee Details',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1A1E25)
                  ),),
                  const Divider(thickness: 0.5,color: Colors.grey,),

                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tenant Type*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 90.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Family', 'Student'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isTenantType="Family";
                          }else{
                            isTenantType="Student";
                          }

                          print('isTenantType====$isTenantType');

                        },
                      ),





                    ],
                  ),


                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tenant Service*',style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A1E25)
                      ),),

                      const SizedBox(width: 10,),


                      Expanded(
                        child: ToggleSwitch(
                          minWidth: 75.0,
                          minHeight: 30.0,
                          fontSize: 16.0,
                          initialLabelIndex: 0,
                          totalSwitches: 3,
                          activeBgColor: const [Color(0xffFF3D00)],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey.withOpacity(0.2),
                          inactiveFgColor: Colors.grey[900],
                          labels: const ['PSU', 'Govern','Private'],
                          onToggle: (index) {
                            print('switched to: $index');
                        
                        
                            if(index == 0){
                              isTenantService="PSU";
                            }else if(index == 1){
                              isTenantService="Govern";
                            }else if(index == 2){
                              isTenantService="Private";
                            }
                        
                            print('isTenantService====$isTenantService');
                        
                          },
                        ),
                      ),

                      const SizedBox(height: 8,),






                    ],
                  ),

                  const SizedBox(height: 10,),
                  const Text('Tenant Tenure*',style: TextStyle(
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
                      controller: tenantTenureController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  const Text('Expected Rent*',style: TextStyle(
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
                      controller: expectedRentController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  const Text('Last Rent*',style: TextStyle(
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
                      controller: lastRentController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text('Maintenance Included In Rent*',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1A1E25)
                        ),),
                      ),

                      const SizedBox(width: 10,),


                      ToggleSwitch(
                        minWidth: 70.0,
                        minHeight: 30.0,
                        fontSize: 16.0,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        activeBgColor: const [Color(0xffFF3D00)],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey.withOpacity(0.2),
                        inactiveFgColor: Colors.grey[900],
                        labels: const ['Yes', 'No'],
                        onToggle: (index) {
                          print('switched to: $index');

                          if(index == 0){
                            isMaintanance="yes";
                          }else{
                            isMaintanance="no";
                          }

                          print('isRo====$isRo');

                        },
                      ),


                    ],
                  ),
                  // Text('Maintenance Included In Rent*',style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xff1A1E25)
                  // ),),
                  // SizedBox(height: 5,),
                  // Container(
                  //   height: 50,
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffEFEFEF),
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: Color(0xffA1A1A1)),
                  //   ),
                  //   child: TextField(
                  //     controller: maintenceIncludedController,
                  //
                  //     style:TextStyle(fontSize:16),
                  //     keyboardType: TextInputType.phone,
                  //     decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //     ),
                  //   ),
                  // ),



                  const SizedBox(height: 18,),
                  const Text('Payment',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1A1E25)
                  ),),
                  const Divider(thickness: 0.5,color: Colors.grey,),




                  const SizedBox(height: 15,),

                  const Text('Security Deposit Amount*',style: TextStyle(
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
                      controller: securityAmountDepositController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  const Text('Bank*',style: TextStyle(
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
                      controller: bankController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  const Text('Account No*',style: TextStyle(
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
                      controller: accountNoController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  const Text('IFSC*',style: TextStyle(
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
                      controller: ifscController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  const Text('Beneficiary Name*',style: TextStyle(
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
                      controller: beneficiaryNameController,

                      style:const TextStyle(fontSize:16),
                      keyboardType: TextInputType.text,
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

                     /* if(propertyNameController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Property name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else*/

                      if(tenantTenureController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Tenant Tenure",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(expectedRentController.toString().isEmpty ){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Select Expected Rent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }else if(lastRentController.toString().isEmpty ){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Last Rent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }else if(isMaintanance.isEmpty ){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Maintence Rent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }else if(securityAmountDepositController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter security amount",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(bankController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Bank Details",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(accountNoController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Bank Account Details",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(ifscController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter IFSC Details",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else if(beneficiaryNameController.text.toString().isEmpty){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Enter Beneficiary Name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }else{

                       // _uploadImage();

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

                  const SizedBox(height: 30,),


                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}
