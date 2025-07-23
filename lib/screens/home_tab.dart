import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:neoteric_flutter/booking_tab/booking_list.dart';
import 'package:neoteric_flutter/complaint_section/rent_user_complaint_form.dart';
import 'package:neoteric_flutter/models/club_services_model.dart';
import 'package:neoteric_flutter/screens/add_referal.dart';
import 'package:neoteric_flutter/screens/contact_us_screen.dart';
import 'package:neoteric_flutter/screens/feedback_screen.dart';
import 'package:neoteric_flutter/screens/price_list_screen.dart';
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
// import '../user_details/user_screen.dart';
import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  bool _showAllProperties = false;
  String? userRole;
  String? contactNo;
  bool isExpanded = false;
  Map<String, bool> expandedMap = {};
  bool isLoading = false;

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
      "name": "Work Charges",
      "icon": "assets/workCharge.jpg",
      "screen": PriceListScreen()
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
  List<dynamic> complaintList = [];

  @override
  void initState() {
    super.initState();
    // _loadUserData();
    _loadData();
    // _initialize();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    contactNo = prefs.getString('primary_contact_no');
    print("✅ Loaded contactNo: $contactNo");

    if (contactNo != null && contactNo!.isNotEmpty) {
      await fetchComplaintData();
    } else {
      print("❌ contactNo is null or empty");
    }

    await _init(); // load the rest of the home data
  }

  // void _initialize() async {
  //   await _init(); // Load contactNo, etc.
  //   print("✅ Contact number loaded: $contactNo");

  //   if (contactNo != null && contactNo!.isNotEmpty) {
  //     await fetchComplaintData(); // Only call if contactNo is valid
  //   } else {
  //     print("❌ contactNo is still null or empty");
  //   }
  // }

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

  // _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userRole = prefs.getString('user_role');
  //   contactNo = prefs.getString('primary_contact_no');
  //   print(" Contact number in home page : $contactNo");
  // }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('user_role');
    contactNo = prefs.getString('primary_contact_no');
    print(" Contact number in home page : $contactNo");

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

  Future<void> fetchComplaintData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse(
          'https://lytechxagency.website/Laravel_GoogleSheet/tatent_Service_Request_List?Phone=$contactNo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == true && data['ComplaintData'] != null) {
          setState(() {
            isLoading = false;
            complaintList =
                List<Map<String, dynamic>>.from(data['ComplaintData']);
            print("List of complaints: $complaintList");
          });
        } else {
          print("No complaints found.");
          setState(() {
            complaintList = [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch complaints');
      }
    } catch (e) {
      print("Error fetching complaint data: $e");
      setState(() {
        complaintList = [];
        isLoading = false;
      });
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
                              addText(getGreetingMessage(),
                                  const Color(0xFF505050), 10, FontWeight.w400),
                              const SizedBox(
                                height: 5,
                              ),
                              Consumer<HomeProvider>(
                                  builder: (context, userName, child) {
                                return addText(
                                    userName.userName ?? "",
                                    const Color(0xFF303030),
                                    16,
                                    FontWeight.w500);
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              if (userRole == 'premiumUser')
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/coin.png",
                                      scale: 1,
                                      height: 10,
                                      width: 10,
                                    ),
                                    addText(
                                        "SIGNATURE MEMBER",
                                        const Color(0xFF505050),
                                        10,
                                        FontWeight.w500),
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
                            Consumer<HomeProvider>(
                                builder: (context, profileImage, child) {
                              return InkWell(
                                onTap: () {
                                  pushTo(
                                      context,
                                      ProfileScreen(
                                        isHome: true,
                                      ));
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
                    (userRole == "premiumUser")
                        ? Consumer<HomeProvider>(
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
                            return (getproperties.getProperties?.length ?? 0) >
                                    0
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            addText(
                                                "My Properties",
                                                const Color(0xFF303030),
                                                12,
                                                FontWeight.w500),
                                            InkWell(
                                              child: addText(
                                                  "Can't find your property?",
                                                  const Color(0xFFFFFFFF),
                                                  12,
                                                  FontWeight.w500),
                                              onTap: () {
                                                pushTo(context,
                                                    const ContactUsScreen());
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListView.builder(
                                              itemCount: _showAllProperties
                                                  ? getproperties.getProperties
                                                          ?.length ??
                                                      0
                                                  : 1,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                final propertyItem =
                                                    getproperties
                                                        .getProperties![index];
                                                return Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Container(
                                                      height: 75,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: const Color(
                                                              0xFFF4F4F4)),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: Image.network(
                                                                propertyItem
                                                                        .projectData
                                                                        ?.image ??
                                                                    "",
                                                                height: 75,
                                                                width: 110,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
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
                                                                          (loadingProgress.expectedTotalBytes ??
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
                                                                    "${propertyItem.project_name ?? ""} (Unit- ${propertyItem.unit_no ?? ""})",
                                                                    const Color(
                                                                        0xFF303030),
                                                                    13,
                                                                    FontWeight
                                                                        .w500),
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
                                                                        propertyItem.location ??
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
                                                                InkWell(
                                                                  onTap: () {
                                                                    HomeProvider
                                                                        .homeSharedInstanace
                                                                        .changePropertyDetails(
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
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Image
                                                                          .asset(
                                                                        "assets/forword.png",
                                                                        height:
                                                                            8,
                                                                        width:
                                                                            8,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  addText(
                                                      "My Properties(${getproperties.getProperties?.length ?? "0"})",
                                                      const Color(0xFF505050),
                                                      14,
                                                      FontWeight.w500),
                                                  InkWell(
                                                    child: Transform.flip(
                                                      flipY: _showAllProperties
                                                          ? true
                                                          : false,
                                                      child: Image.asset(
                                                        "assets/dropdown.png",
                                                        height: 20,
                                                        width: 20,
                                                        color: const Color(
                                                            0xFFFF3803),
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
                        : const SizedBox(
                            height: 15,
                          )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (userRole == "premiumUser")
                      ? const SizedBox(
                          height: 20,
                        )
                      : const SizedBox(),
                  (userRole == "premiumUser")
                      ? const Text(
                          'Services',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )
                      : const SizedBox(),
                  (userRole == "premiumUser")
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(),
                  (userRole == "premiumUser")
                      ? SizedBox(
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
                                        height: (service['name'] ==
                                                    "Booking List" ||
                                                service['name'] ==
                                                    "Rent Request")
                                            ? 35
                                            : 50,
                                        width: (service['name'] ==
                                                    "Booking List" ||
                                                service['name'] ==
                                                    "Rent Request")
                                            ? 35
                                            : 50,
                                      ),
                                      if ((service['name'] == "Booking List" ||
                                          service['name'] == "Rent Request"))
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      addAlignedText(
                                          service['name'],
                                          const Color(0xFF404040),
                                          12,
                                          FontWeight.w500)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                  if (userRole != 'premiumUser')
                    isLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 20),
                            child: Shimmer(
                              color: Colors.grey.shade300,
                              // highlightColor: Colors.grey.shade100,
                              child: SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3, // number of shimmer cards
                                  itemBuilder: (context, index) => Container(
                                    width: 250,
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          4,
                                          (i) => Container(
                                            height: 15,
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 5, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'Complaints',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                complaintList.isEmpty
                                    ? const Center(
                                        child: SizedBox(
                                            height: 25,
                                            child: Text('No Complaints Found')))
                                    : SizedBox(
                                        height: isExpanded ? 240 : 190,
                                        child: ListView.builder(
                                          itemCount: complaintList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final item = complaintList[index];
                                            return Container(
                                              width: 250,
                                              margin: const EdgeInsets.only(
                                                  right: 12,
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 5),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xffFF3D00),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildComplaintRow('Project ',
                                                      item['Project Name']),
                                                  // _buildComplaintRow(
                                                  //     'Unit No. ', item['Unit No.']),
                                                  _buildComplaintRow(
                                                      'Request Area ',
                                                      item['Request About']),
                                                  _buildComplaintRow(
                                                      'Category ',
                                                      item['Request Category']),
                                                  _buildComplaintRow('Issue ',
                                                      "${item['Narration']}"),
                                                  // _buildComplaintRow(
                                                  //     'Status ', "${item['Status']}"),
                                                  const Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        item['Status'],
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xffFF3D00),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        item['Timestamp'],
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      pushTo(
                                          context,
                                          RentUserComplaintForm(
                                            isHome: true,
                                          ));
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        gradient: LinearGradient(colors: [
                                          Color(0xffFF3D00),
                                          Color(0xffFF2E00)
                                        ]),
                                      ),
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          'Raise Complaint',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  const SizedBox(height: 20),
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

  Widget _buildComplaintRow(String label, String? value) {
    value ??= "-";
    final isLong = value.trim().split(RegExp(r'\s+')).length > 3;
    isExpanded = expandedMap[label] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                if (isLong) {
                  setState(() {
                    expandedMap[label] = !isExpanded;
                  });
                }
              },
              child: Text(
                value.isNotEmpty
                    ? isExpanded
                        ? value
                        : limitWords(value, 3)
                    : "-",
                style: const TextStyle(fontSize: 13),
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String limitWords(String text, int maxWords) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= maxWords) return text;
    return '${words.sublist(0, maxWords).join(' ')}...';
  }
}
