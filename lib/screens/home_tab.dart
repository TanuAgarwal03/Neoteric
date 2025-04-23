import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:neoteric_flutter/booking_tab/booking_list.dart';
import 'package:neoteric_flutter/models/club_services_model.dart';
import 'package:neoteric_flutter/screens/add_referal.dart';
import 'package:neoteric_flutter/screens/contact_us_screen.dart';
import 'package:neoteric_flutter/screens/feedback_screen.dart';
import 'package:neoteric_flutter/widgets/navigation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../all_properties/properties_details.dart';
import '../booking_tab/add_booking.dart';
import '../complaint_section/complaint_list.dart';
import '../providers/home_provider.dart';
import '../rent_request/rent_request_screen.dart';
import '../complaint_section/service_request_screen.dart';
import '../user_details/profile_screen.dart';
import '../user_details/user_screen.dart';
import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  bool _showAllProperties = false;
  List<dynamic> serviesList = [
    {
      "name": "Add Service Request",
      "icon": "assets/add_service_request.png",
      "screen": ServiceRequestScreen(
        isHome: true,
      )
    },
    {
      "name": "Service List",
      "icon": "assets/servicelist.png",
      "screen": const ComplaintList()
    },
    {
      "name": "Add Booking",
      "icon": "assets/add_booking.png",
      "screen": AddBooking(
        isHome: true,
      )
    },
    {
      "name": "Booking List",
      "icon": "assets/bookinglist.png",
      "screen": const BookingListScreen()
    },
    {
      "name": "Rent Request",
      "icon": "assets/rent.png",
      "screen": const RentRequestScreen()
    },
    {
      "name": "Add referral",
      "icon": "assets/addreferal.png",
      "screen": const AddReferalScreen()
    },
    {
      "name": "Contact Us",
      "icon": "assets/contactus.png",
      "screen": const ContactUsScreen()
    },
    {
      "name": "Feedback",
      "icon": "assets/feedback.png",
      "screen": const FeedBackScreen()
    }
  ];

  int _currentIndex = 0;

  final List<ClubServicesModel> _ServiceRequestData = [];
  String? _selectedRequestData;

  @override
  void initState() {
    //fetchRequestData();
    _init();
    super.initState();
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  _init() async {
    try {
      await HomeProvider.homeSharedInstanace.getSliderData();
    } catch (e) {
      print(e);
      throw Exception('Failed to load data');
    }
    try {
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
      setState(() {});
    } catch (e) {
      print(e);
      throw Exception('Failed to load data');
    }
  }

  String cleanName(String name) {
    return name.replaceAll(RegExp(r'\b(Mr\.?|Mrs\.?)\b\s*'), '').trim();
  }

  String getInitials() {
    if (HomeProvider.homeSharedInstanace.userName != null) {
      String cleanFullName =
          cleanName(HomeProvider.homeSharedInstanace.userName ?? "");
      List<String> nameParts = cleanFullName.split(' ');
      String initials = '';
      if (nameParts.isNotEmpty) {
        initials += nameParts[0][0].toUpperCase();
        if (nameParts.length > 1) {
          initials += nameParts[1][0].toUpperCase();
        }
      }
      return initials;
    }

    return "";
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              addText(getGreetingMessage(), const Color(0xFF505050),
                                  10, FontWeight.w400),
                              const SizedBox(
                                height: 5,
                              ),
                              Consumer<HomeProvider>(
                                  builder: (context, userName, child) {
                                return addText(userName.userName ?? "",
                                    const Color(0xFF303030), 16, FontWeight.w500);
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/coin.png",
                                    scale: 1,
                                    height: 10,
                                    width: 10,
                                  ),
                                  addText("SIGNATURE MEMBER", const Color(0xFF505050),
                                      10, FontWeight.w500),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const WhatsappIcon(),
                            const SizedBox(
                              width: 10,
                            ),
                            // Image.asset(
                            //   "assets/badge.png",
                            //   height: 20,
                            //   width: 20,
                            //   scale: 1,
                            // ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            Consumer<HomeProvider>(
                                builder: (context, profileImage, child) {
                              return InkWell(
                                onTap: () {
                                  pushTo(context, const ProfileScreen());
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xffFF3D00),
                                        radius: 40,
                                        child: HomeProvider.homeSharedInstanace
                                                    .profileImage !=
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  profileImage.profileImage
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                ))
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: addText(
                                                    getInitials(),
                                                    Colors.white,
                                                    12,
                                                    FontWeight.bold),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      child: Image.asset(
                                        "assets/coin.png",
                                        height: 10,
                                        width: 10,
                                        scale: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        )
                      ],
                    ),
                    Consumer<HomeProvider>(
                        builder: (context, getproperties, child) {
                      if (getproperties.getProperties == null) {
                        return const Column(
                          children: [
                            SizedBox(
                              height: 35,
                            ),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      }
                      return (getproperties.getProperties?.length ?? 0) > 0
                          ? Column(
                            children: [
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    addText("My Properties", const Color(0xFF303030), 12, FontWeight.w500),
                                    InkWell(child: addText("Can't find your property?", const Color(0xFFFFFFFF), 12, FontWeight.w500),onTap: (){
                                      pushTo(context, const ContactUsScreen());
                                    },),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        itemCount: _showAllProperties
                                            ? getproperties.getProperties?.length ??
                                                0
                                            : 1,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final propertyItem =
                                              getproperties.getProperties![index];
                                          return Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                height: 75,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    color: const Color(0xFFF4F4F4)),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(15),
                                                      child: Image.network(
                                                          propertyItem.projectData
                                                                  ?.image ??
                                                              "",
                                                          height: 75,
                                                          width: 110,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    (loadingProgress
                                                                            .expectedTotalBytes ??
                                                                        1)
                                                                : null,
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
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
                                                                  const Color(0xFF797979),
                                                                  10,
                                                                  FontWeight.w500),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              HomeProvider.homeSharedInstanace.changePropertyDetails(
                                                                  propertyItem);
                                                              pushTo(
                                                                  context,
                                                                  PropertiesDetails(
                                                                    viewAllPropertiesModel:
                                                                        propertyItem,
                                                                  ));
                                                            },
                                                            child: Row(
                                                              children: [
                                                                addText(
                                                                    "View Details",
                                                                    const Color(
                                                                        0xFFFF3803),
                                                                    11,
                                                                    FontWeight
                                                                        .bold),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Image.asset(
                                                                  "assets/forword.png",
                                                                  height: 8,
                                                                  width: 8,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            addText(
                                                "My Properties(${getproperties.getProperties?.length ?? "0"})",
                                                const Color(0xFF505050),
                                                14,
                                                FontWeight.w500),
                                            InkWell(
                                              child: Transform.flip(

                                                flipY: _showAllProperties?true:false,
                                                child: Image.asset(
                                                  "assets/dropdown.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: const Color(0xFFFF3803),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _showAllProperties =
                                                      !_showAllProperties;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                          : const SizedBox.shrink();
                    })
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Services',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      itemCount: serviesList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final service = serviesList[index];
                        return InkWell(
                          onTap: () {
                            pushTo(context, serviesList[index]['screen']);
                          },
                          child: SizedBox(
                            height: 100,
                            width: 80,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  service['icon'],
                                  fit: BoxFit.cover,
                                  height: (service['name']=="Booking List" || service['name']=="Rent Request")?35:50,
                                  width: (service['name']=="Booking List" || service['name']=="Rent Request")?35:50,
                                ),
                                if((service['name']=="Booking List" || service['name']=="Rent Request"))
                                  const SizedBox(height: 15,),
                                addAlignedText(service['name'],
                                    const Color(0xFF404040), 12, FontWeight.w500)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       color: Color(0xffE0E0E0)),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //         top: 25, left: 27, bottom: 25, right: 27),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment:
                  //               MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             GestureDetector(
                  //               onTap: () {
                  //                 //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ContactUsScreen()), (Route<dynamic> route) => false);
                  //                 Navigator.of(context)
                  //                     .push(MaterialPageRoute(
                  //                   builder: (context) => ContactUsScreen(),
                  //                 ));
                  //               },
                  //               child: Container(
                  //                   width: 128,
                  //                   height: 49,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(10)),
                  //                       color: Colors.white),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         //  Icon(Icons.support_agent),
                  //                         Image.asset(
                  //                           'assets/contacts.png',
                  //                           width: 22,
                  //                           height: 22,
                  //                         ),
                  //                         SizedBox(
                  //                           width: 7,
                  //                         ),
                  //                         Text(
                  //                           'Contact Us',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 12,
                  //                               color: Color(0xff000000)),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),
                  //             GestureDetector(
                  //               onTap: () {
                  //                 Navigator.of(context)
                  //                     .push(MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       AddReferalScreen(),
                  //                 ));
                  //               },
                  //               child: Container(
                  //                   width: 128,
                  //                   height: 49,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(10)),
                  //                       color: Colors.white),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         // Icon(Icons.group),
                  //                         Image.asset(
                  //                           'assets/consultancy.png',
                  //                           width: 22,
                  //                           height: 22,
                  //                         ),
                  //                         SizedBox(
                  //                           width: 7,
                  //                         ),
                  //                         Text(
                  //                           'Property\nReferral',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 12,
                  //                               color: Color(0xff000000)),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),
                  //
                  //             /*      GestureDetector(
                  //               onTap: (){
                  //                 //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  //                 // RentingScreen()), (Route<dynamic> route) => false);
                  //                // RepairPropertyRequestScreen()), (Route<dynamic> route) => false);
                  //
                  //                   Navigator.of(context).push(MaterialPageRoute(
                  //                   builder: (context) => RentingScreen(),
                  //                 ));
                  //
                  //               },
                  //               child: Container(
                  //                   height: 49,
                  //                   width: 128,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //                       color: Colors.white
                  //                   ),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children:  [
                  //                         // Icon(Icons.house),
                  //                         Image.asset('assets/renting.png',width: 22,height: 22,),
                  //                         SizedBox(width: 7,),
                  //                         Text('Renting',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 12,
                  //                               color: Color(0xff000000)
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),*/
                  //           ],
                  //         ),
                  //         //   SizedBox(height: 15,),
                  //         /*   Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             GestureDetector(
                  //               onTap: (){
                  //                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  //                  //   RequestDocumentScreen()), (Route<dynamic> route) => false);
                  //
                  //                  Navigator.of(context).push(MaterialPageRoute(
                  //                   builder: (context) => RequestDocumentScreen(),
                  //                 ));
                  //
                  //               },
                  //               child: Container(
                  //                   width: 128,
                  //                   height: 49,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //                       color: Colors.white
                  //                   ),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         // Icon(Icons.document_scanner),
                  //                         Image.asset('assets/request.png',width: 22,height: 22,),
                  //                         SizedBox(width: 7,),
                  //                         Text('Request \nDocuments',
                  //                           textAlign: TextAlign.start,
                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.w600,
                  //                                 fontSize: 12,
                  //                                 color: Color(0xff000000)
                  //                             ),),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),
                  //
                  //             GestureDetector(
                  //               onTap: (){
                  //                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  //                  //   ComplaintScreen()), (Route<dynamic> route) => false);
                  //
                  //
                  //                  Navigator.of(context).push(MaterialPageRoute(
                  //                   builder: (context) => ServiceRequestScreenTab(),
                  //                 ));
                  //
                  //
                  //               },
                  //               child: Container(
                  //                   width: 128,
                  //                   height: 49,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //                       color: Colors.white
                  //                   ),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         Image.asset('assets/complaint.png',width: 22,height: 22,),
                  //                         // Icon(Icons.message_sharp),
                  //                         SizedBox(width: 7,),
                  //                         Text('Service\nRequest',
                  //                            style: TextStyle(
                  //                             fontWeight: FontWeight.w600,
                  //                             fontSize: 12,
                  //                             color: Color(0xff000000)
                  //                         ),),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),
                  //
                  //           ],
                  //         ),*/
                  //
                  //         SizedBox(
                  //           height: 15,
                  //         ),
                  //         Row(
                  //           mainAxisAlignment:
                  //               MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             /*   GestureDetector(
                  //               onTap: (){
                  //
                  //
                  //               //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  //                 //    RepairPropertyRequestScreen()), (Route<dynamic> route) => false);
                  //
                  //
                  //                  Navigator.of(context).push(MaterialPageRoute(
                  //                   builder: (context) =>RepairScreen(),));
                  //
                  //
                  //                 // Navigator.of(context).push(MaterialPageRoute(
                  //                  //  builder: (context) => RepairPropertyRequestScreen(),
                  //                //  ));
                  //
                  //
                  //
                  //               },
                  //               child: Container(
                  //                   width: 128,
                  //                   height: 49,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //                       color: Colors.white
                  //                   ),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         // Icon(Icons.home_repair_service),
                  //                         Image.asset('assets/service.png',width: 22,height: 22,),
                  //                         SizedBox(width: 7,),
                  //                         Text('Service & Rep.',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 12,
                  //                               color: Color(0xff000000)
                  //                           ),),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),*/
                  //           ],
                  //         ),
                  //
                  //         SizedBox(
                  //           height: 15,
                  //         ),
                  //         Row(
                  //           mainAxisAlignment:
                  //               MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             GestureDetector(
                  //               onTap: () {
                  //                 Navigator.of(context)
                  //                     .push(MaterialPageRoute(
                  //                   builder: (context) => FeedBackScreen(),
                  //                 ));
                  //               },
                  //               child: Container(
                  //                   width: 128,
                  //                   height: 49,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(10)),
                  //                       color: Colors.white),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Row(
                  //                       children: [
                  //                         Icon(Icons.group),
                  //                         SizedBox(
                  //                           width: 7,
                  //                         ),
                  //                         Text(
                  //                           'Feedback',
                  //                           style: TextStyle(
                  //                               fontWeight:
                  //                                   FontWeight.w700),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   )),
                  //             ),
                  //
                  //             /* Container(
                  //                 width: 150,
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //                     color: Colors.white
                  //                 ),
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //                     children: [
                  //                       Icon(Icons.monetization_on_rounded),
                  //                       SizedBox(width: 7,),
                  //                       Text('Loans',
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.w700
                  //                         ),),
                  //                     ],
                  //                   ),
                  //                 )),*/
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  //
                  // SizedBox(
                  //   height: 40,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => ViewAllPropertiesList(),
                  //     ));
                  //   },
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //           colors: [Color(0xffFF3D00), Color(0xffFF2E00)]),
                  //       borderRadius: BorderRadius.all(Radius.circular(20)),
                  //       //  color: Colors.red
                  //     ),
                  //     child: Center(
                  //         child: Padding(
                  //       padding: const EdgeInsets.only(top: 10, bottom: 10),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Image.asset('assets/vector.png'),
                  //           SizedBox(
                  //             width: 15,
                  //           ),
                  //           Text(
                  //             'View My Properties',
                  //             style: TextStyle(
                  //                 color: Colors.white, fontSize: 17),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  //   ),
                  // ),
                  const Text(
                    "What's new",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<HomeProvider>(
                          builder: (context, getImageSlider, child) {
                            if (getImageSlider.sliderImages == null) {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              );
                            }
                            return MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: CarouselSlider.builder(
                                  itemCount:
                                  getImageSlider.sliderImages?.length ?? 0,
                                  itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(
                                                getImageSlider
                                                    .sliderImages![itemIndex].image!,
                                                fit: BoxFit.cover,
                                                width:
                                                MediaQuery.of(context).size.width,
                                                loadingBuilder:
                                                    (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress
                                                          .expectedTotalBytes !=
                                                          null
                                                          ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                              .expectedTotalBytes ??
                                                              1)
                                                          : null,
                                                    ),
                                                  );
                                                })),
                                      ),
                                  options: CarouselOptions(
                                    // viewportFraction: 1,
                                    viewportFraction: 0.9,
                                    enlargeCenterPage: false,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    //enlargeCenterPage: true,

                                    onPageChanged: (index, reason) {
                                      _currentIndex = index;
                                      setState(() {});
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ));
                          })),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
