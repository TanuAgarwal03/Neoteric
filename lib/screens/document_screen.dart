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
import 'package:url_launcher/url_launcher.dart';

import '../providers/home_provider.dart';
import '../widgets/whatsappicon.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0),()async{
      _init();
    });
    super.initState();
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
      if (HomeProvider.homeSharedInstanace.getProperties != null) {
        if ((HomeProvider.homeSharedInstanace.getProperties?.length ?? 0) > 0) {
          HomeProvider.homeSharedInstanace.changePropertyDetails(
              HomeProvider.homeSharedInstanace.getProperties![0]);
        }
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
                          const SizedBox(width: 55,height: 50,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.65,
                            child: addAlignedText('Documents', Colors.black, 14,
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
                                                                ?.location ??
                                                                "",
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
                    const SizedBox(height: 50,),
                  ],
                ),
              ),
            ),
            Consumer<HomeProvider>(
                builder: (context, getproperties, child) {
                  return getproperties.getPropertiesDetails != null
                      ? Column(
                        children: [
                          if(getproperties.getPropertiesDetails?.agreement != null &&
                              getproperties.getPropertiesDetails!.agreement!.isNotEmpty)
                          Card(
                                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                              shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                                              ),
                                              elevation: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFF6F6F6),
                                            borderRadius: BorderRadius.circular(50),
                                            ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/document.png",
                                              fit: BoxFit.cover,
                                              height: 15,
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      addText("Agreement", Colors.black, 15, FontWeight.w600)
                                    ],
                                  ),
                                  InkWell(child: Image.asset("assets/download.png",height: 30,width: 30,),onTap: (){
                                    try{
                                      launch(getproperties.getPropertiesDetails?.agreement??"");
                                    }catch(e){
                                      Fluttertoast.showToast(
                                          msg: "Invalid Agreement Data",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },)
                                ],
                              ),
                            ),
                          ),
                          if(getproperties.getPropertiesDetails?.registry != null && getproperties.getPropertiesDetails!.registry!.isNotEmpty)
                            Card(
                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF6F6F6),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/document.png",
                                                fit: BoxFit.cover,
                                                height: 15,
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        addText("Registry", Colors.black, 15, FontWeight.w600)
                                      ],
                                    ),
                                    InkWell(child: Image.asset("assets/download.png",height: 30,width: 30,),onTap: (){
                                      try{
                                        launch(getproperties.getPropertiesDetails?.registry??"");
                                      }catch(e){
                                        Fluttertoast.showToast(
                                            msg: "Invalid Agreement Data",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },)
                                  ],
                                ),
                              ),
                            ),
                          if(getproperties.getPropertiesDetails?.maintenance_agreement != null && getproperties.getPropertiesDetails!.maintenance_agreement!.isNotEmpty)
                            Card(
                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF6F6F6),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/document.png",
                                                fit: BoxFit.cover,
                                                height: 15,
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        addText("Maintenance Agreement", Colors.black, 15, FontWeight.w600)
                                      ],
                                    ),
                                    InkWell(child: Image.asset("assets/download.png",height: 30,width: 30,),onTap: (){
                                      try{
                                        launch(getproperties.getPropertiesDetails?.maintenance_agreement??"");
                                      }catch(e){
                                        Fluttertoast.showToast(
                                            msg: "Invalid Agreement Data",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },)
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                      : const SizedBox.shrink();
                }),
          ],
        ),
      ),


    );
  }
}
