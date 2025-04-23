import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:neoteric_flutter/models/all_category_model.dart';
import 'package:neoteric_flutter/models/property_tyype/view_all_proprerties_model.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:neoteric_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/club_services_model.dart';
import '../widgets/whatsappicon.dart';


class ServiceRequestScreen extends StatefulWidget {
  bool isHome;

  ServiceRequestScreen({super.key,required this.isHome});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {

  TextEditingController nameController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  //TextEditingController projectNameController= new TextEditingController();
  TextEditingController apartmentNoController= TextEditingController();
  TextEditingController narrationController= TextEditingController();

  bool isLoading=false;


  List<AllCategoryModel> _ServiceInternalData = [];
  String? _selectedServiceInternal;

  List<AllCategoryModel> _ServiceCampusData = [];
  String? _selectedServiceCampus;

  List<ClubServicesModel> _ServiceRequestData = [];
  String? _selectedRequestData;



  ImagePicker picker = ImagePicker();

  File? image;

  String? image_text="Choose file";

  final List<String> _locations = ['Unit Internal', 'Campus Area']; // Option 2
  String? _selectedLocation; // Option 2

  String _selectedRequestType="Unit Internal";
  String _requestType= "";



  void fetchRequestData() async {
    final response = await http.get(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/All_Category'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> projectsData = data['requestData'];

      setState(() {
        //ProjectData
        _ServiceRequestData = projectsData.map((data) => ClubServicesModel.fromJson(data)).where((project) => project.type == 'Request_Category').toList();

        print('get_res_category=====');
        print(_ServiceRequestData.first.name);

      });
    } else {
      throw Exception('Failed to load data');
    }

  }


  void fetchDataInternal() async {
    final response = await http.get(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/All_Category'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> projectsData = data['requestData'];

      setState(() {
        //ProjectData
        _ServiceInternalData = projectsData.map((data) => AllCategoryModel.fromJson(data)).where((project) => project.type == 'Service_Request_Internal').toList();

        print('get_res_category=====');
        print(_ServiceInternalData.first.name);

      });
    } else {
      throw Exception('Failed to load data');
    }

  }

  void fetchDataCampus() async {
    final response = await http.get(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/All_Category'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> projectsData = data['requestData'];

      setState(() {
        //ProjectData
        _ServiceCampusData = projectsData.map((data) => AllCategoryModel.fromJson(data)).where((project) => project.type == 'Service_Request_Campus').toList();

        print('get_res_category=====');
        print(_ServiceCampusData.first.name);

      });
    } else {
      throw Exception('Failed to load data');
    }

  }


  Future<void> _uploadImage() async {
    print('getloading==');
    // print(isLoading);

    SharedPreferences pref= await SharedPreferences.getInstance();
    String finalPath="";

    if(image == null){
      finalPath="";
    }else{
      finalPath=image!.path;
    }
    const url = 'https://lytechxagency.website/Laravel_GoogleSheet/ServiceRequest_store'; // Replace with your server's upload endpoint

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['contact_no'] = phoneController.text.toString();
    request.fields['Narration'] =narrationController.text.toString();
    request.fields['project_id'] =HomeProvider.homeSharedInstanace.getPropertiesDetails?.property_id??"";
    request.fields['projectname'] =HomeProvider.homeSharedInstanace.getPropertiesDetails?.project_name??"";
    request.fields['Request_Type'] =_selectedLocation.toString();
    request.fields['name'] =nameController.text.toString();
    request.fields['Request_Category'] =_selectedRequestData!.toString();
  //  request.fields['apartment_no'] =apartmentNoController.text.toString();
    request.fields['Request_About'] =_requestType;
    request.fields['Unit_No'] = HomeProvider.homeSharedInstanace.getPropertiesDetails?.unit_no??"";
 
    if(image == null){
      print("path_is_empty");
      finalPath="";
      setState(() {
        isLoading= false;
      });
    }else{
      print("path_is_not_empty");
      //final_path=image!.path;
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image!.path,
        ),
      );
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('aabb==Image uploaded data');
      print(await response.stream.bytesToString());

      Fluttertoast.showToast(
          msg: "We will Solve Your Request in 24 Hour.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        isLoading= false;
        image_text= "Choose file";
      //  nameController.text="";
       // phoneController.text="";
        narrationController.text="";
        _selectedLocation=null;
        _selectedRequestData=null;
        _requestType="";
      });
    }
    else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "Data not Uploaded!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading= false;
      });
    }
  }


  void getDataFromSharedPreferance() async{


    SharedPreferences pref= await SharedPreferences.getInstance();
    setState(() {
      nameController.text=pref.getString("name").toString();
      phoneController.text=pref.getString("primary_contact_no").toString();


    });

  }

  @override
  void initState() {
    super.initState();
    _init();
    fetchDataInternal();
    fetchDataCampus();
    fetchRequestData();
    getDataFromSharedPreferance();

  }

  Future<void> _init()async{
    try {
      if(HomeProvider.homeSharedInstanace.getProperties == null)
      {
        var api1 = HomeProvider.homeSharedInstanace.getProjectData();
        var api2 = HomeProvider.homeSharedInstanace.getAllProperty();
        await Future.wait([api1, api2]);
        if (HomeProvider.homeSharedInstanace.getAllProject != null) {
          if (HomeProvider.homeSharedInstanace.getProperties != null) {
            if (HomeProvider.homeSharedInstanace.getProperties!.isNotEmpty &&
                HomeProvider.homeSharedInstanace.getAllProject!.isNotEmpty) {
              var propertyData =
                  HomeProvider.homeSharedInstanace.getProperties ?? [];
              for (int i = 0; i < propertyData.length; i++) {
                var projectIndex = HomeProvider.homeSharedInstanace.getAllProject!
                    .indexWhere((element) =>
                element.project_id.toString().trim() ==
                    propertyData[i].project_id.toString().trim());
                if (projectIndex != -1) {
                  propertyData[i].projectData = HomeProvider
                      .homeSharedInstanace.getAllProject![projectIndex];
                }
              }
            }
          }
        }
      }
      try {
          if (HomeProvider.homeSharedInstanace.getProperties != null) {
            if ((HomeProvider.homeSharedInstanace.getProperties?.length ?? 0) > 0) {
              HomeProvider.homeSharedInstanace.changePropertyDetails(
                  HomeProvider.homeSharedInstanace.getProperties![0]);
            }
          }
        //Navigator.pop(context);
      } catch (e) {
        //Navigator.pop(context);
      }
      setState(() {});
    } catch (e) {
      print(e);
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
                          widget.isHome?InkWell(
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
                          ):const SizedBox(width: 55,height: 50,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.65,
                            child: addAlignedText('Complaint', Colors.black, 14,
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
                                                  width: 110,
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
                                                        // Transform.flip(
                                                        //     flipY: getproperties
                                                        //         .showAllProperties
                                                        //         ? true
                                                        //         : false,
                                                        //     child:
                                                        //     Image.asset(
                                                        //       "assets/dropdown.png",
                                                        //       height: 20,
                                                        //       color: const Color(
                                                        //           0xFFFF3803),
                                                        //       width: 20,
                                                        //     )),
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
                                                                propertyItem.location??"",
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
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      color: const Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffA1A1A1),width: 0.5),
                    ),
                    child: TextField(
                      controller: nameController,
                      enabled: false,
                      keyboardType: TextInputType.name,
                      style:const TextStyle(fontSize:13),
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
                      color: const Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffA1A1A1),width: 0.5),
                    ),
                    child: TextField(
                      controller: phoneController,
                      enabled: false,
                      style:const TextStyle(fontSize:13),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),


                  const Text('Request Type*',style: TextStyle(
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

                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 15),
                      child: DropdownButton(
                        underline: const SizedBox(),
                        isExpanded: true,
                        hint: const Text('Choose Request Type',style: TextStyle(fontSize: 13),), // Not necessary for Option 1
                        value: _selectedLocation,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                            print('get_request=====');
                            print(_selectedLocation);
                            _selectedRequestType=newValue!;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: new Text(location,style: TextStyle(fontSize: 13),),
                          );
                        }).toList(),
                      ),
                    ),
                  ),



                  const SizedBox(height: 15,),


                  const Text('Request About*',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1E25)
                  ),),
                  const SizedBox(height: 5,),
                  _selectedRequestType == "Unit Internal" ?
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
                        hint: const Text("Select Request",style: TextStyle(fontSize: 13),), // Hint added here
                        value: _selectedServiceInternal,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedServiceInternal = newValue;
                            print('getSelection======');
                            print(_selectedServiceInternal);
                            print(newValue);
                            _requestType=newValue!;

                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: [
                        /*  DropdownMenuItem(
                            value: null,
                            child: Text("Select Request"),
                          ),*/
                          ..._ServiceInternalData.map<DropdownMenuItem<String>>((AllCategoryModel project) {
                            return DropdownMenuItem<String>(
                              value: project.name,
                              child: Row(
                                children: [

                                  // SizedBox(width: 15),
                                  Text(project.name!,style: const TextStyle(fontSize: 13),),

                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  )
                  :
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
                        hint: const Text("Select Request",style: TextStyle(fontSize: 13),), // Hint added here
                        value: _selectedServiceCampus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedServiceCampus = newValue;
                            print('getSelection======');
                            print(_selectedServiceCampus);
                            print(newValue);
                            _requestType=newValue!;

                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: [
                        /*  DropdownMenuItem(
                            value: null,
                            child: Text("Select Request"),
                          ),*/
                          ..._ServiceCampusData.map<DropdownMenuItem<String>>((AllCategoryModel project) {
                            return DropdownMenuItem<String>(
                              value: project.name,
                              child: Row(
                                children: [

                                  // SizedBox(width: 15),
                                  Text(project.name!,style: const TextStyle(fontSize: 13),),

                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 15,),

                  const Text('Request Category*',style: TextStyle(
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
                        hint: const Text("Select Request Category",style: TextStyle(fontSize: 13),), // Hint added here
                        value: _selectedRequestData,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRequestData = newValue;
                            print('getSelection======');
                            print(_selectedRequestData);
                            print(newValue);

                          });
                        },
                        items: [
                         /* DropdownMenuItem(
                            value: null,
                            child: Text("Select Request Category"),
                          ),*/
                          ..._ServiceRequestData.map<DropdownMenuItem<String>>((ClubServicesModel project) {
                            return DropdownMenuItem<String>(
                              value: project.name,
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Image.network(
                                    project.image!.toString(),
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                      return SizedBox(width: 30, height: 30,);
                                    },
                                  ),
                                  // SizedBox(width: 15),
                                  const SizedBox(width: 15),
                                  Text(project.name!,style: const TextStyle(fontSize: 13),),




                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                 /* SizedBox(height: 8,),

                  Text('Apartment No*',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1E25)
                  ),),

                  Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffA1A1A1)),
                    ),
                    child: TextField(
                      controller: apartmentNoController,
                      style:TextStyle(fontSize:16),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),*/

                  const SizedBox(height: 15,),
                  const Text('Describe your complaint*',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1E25)
                  ),),
                  const SizedBox(height: 5,),
                  Container(
                    // height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffA1A1A1),width: 0.5),
                    ),
                    child: TextField(
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      maxLines: 12,
                      controller: narrationController,

                      style:const TextStyle(fontSize:16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                InkWell(
                  onTap: ()async{
                    image =
                    await chooseSourceSheet(context, true, image, "profile");
                    if (image == null) return;
                    if(image!.path.toString().isNotEmpty || image!.path.toString() != null){
                      setState(() {
                        image_text= "Selected";
                      });
                    }
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [5],
                    color: const Color(0xFFFEC3B4),
                    strokeWidth: 0.5,
                    strokeCap: StrokeCap.square,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEC3B4).withOpacity(0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          addText(image_text.toString()=="Selected"?"Uploaded":"Upload Image", const Color(0xFF404040), 15, FontWeight.w600),
                          const SizedBox(height: 5,),
                          addText("Supported Format : JPG,PNG,JPEG", const Color(0xFF404040), 10, FontWeight.w400),
                        ],
                      ),
                    ),
                  ),
                ),                  const SizedBox(height: 45,),
                  isLoading ?  const SpinKitChasingDots(
                    color: Colors.red,
                    size: 80.0,
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
                      }else if(narrationController.text.toString().isEmpty){
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
                      }else if(_selectedRequestData.toString().isEmpty || _selectedRequestData.toString() == "null"){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Select Request Category",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }else if(_requestType.toString().isEmpty || _requestType.toString() == "null"  || _requestType.toString() == ""){
                        setState(() {
                          isLoading=false;
                        });
                        Fluttertoast.showToast(
                            msg: "Select Request About",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }else if(phoneController.text.toString().isEmpty || phoneController.text.toString().length != 10){
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
                        _uploadImage();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
