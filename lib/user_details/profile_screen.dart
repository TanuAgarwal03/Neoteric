import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:neoteric_flutter/screens/add_referal.dart';
import 'package:neoteric_flutter/screens/contact_us_screen.dart';
import 'package:neoteric_flutter/screens/login_screen.dart';
// import 'package:neoteric_flutter/screens/price_list_screen.dart';
import 'package:neoteric_flutter/user_details/user_screen.dart';
import 'package:neoteric_flutter/utils/api_loader.dart';
import 'package:neoteric_flutter/widgets/navigation_widget.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../all_properties/payment_screen.dart';
import '../utils/constants.dart';
// import '../widgets/whatsappicon.dart';

class ProfileScreen extends StatefulWidget {
  bool isHome;
  ProfileScreen({super.key, required this.isHome});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? customer_id;
  String? name;
  String? contact_no;
  String? email;
  String? pan_card;
  String? aadhar_card;
  String? adderss;
  String? birthday;
  String? anniversary;
  String? userRole;

  bool? isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  ImagePicker picker = ImagePicker();

  XFile? image;
  @override
  void initState() {
    super.initState();
    getDataFromSharedPerference();
  }

  void addDataToServer() async {
    String name = nameController.text.toString();
    String mobile = mobileController.text.toString();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "emergency_name": nameController.text.toString(),
      "emergency_no": mobileController.text.toString(),
      "customer_contact_no": contact_no,

      // Add any other required fields in the request body
    };

    final response = await http.post(
      Uri.parse(
          'https://lytechxagency.website/Laravel_GoogleSheet/Customer_Extra_fields'),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
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

      setState(() async {
        isLoading = false;
        nameController.text = name;
        mobileController.text = mobile;

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('emergency_name', name);
        pref.setString('emergency_no', mobile);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  String cleanName(String name) {
    return name.replaceAll(RegExp(r'\b(Mr\.?|Mrs\.?)\b\s*'), '').trim();
  }

  String getInitials() {
    if (name != null) {
      String cleanFullName = cleanName(name ?? "");
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
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 120,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Row(
                                children: [
                                  widget.isHome
                                      ? InkWell(
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
                                              addText('Back', Colors.black, 12,
                                                  FontWeight.w400),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 55,
                                          height: 50,
                                        ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                            backgroundColor: const Color(0xffFF3D00),
                            radius: 100,
                            child: image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ))
                                : HomeProvider
                                            .homeSharedInstanace.profileImage !=
                                        null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          HomeProvider
                                              .homeSharedInstanace.profileImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: addText(getInitials(),
                                            Colors.white, 30, FontWeight.bold),
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 10,
                          child: InkWell(
                            onTap: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                showLoader(context);
                                try {
                                  await HomeProvider.homeSharedInstanace
                                      .uploadImage(File(image!.path));
                                  Navigator.pop(context);
                                } catch (e) {
                                  Navigator.pop(context);
                                }
                              }
                              setState(() {});
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        color: Colors.black, width: 0.5)),
                                child: Image.asset(
                                  "assets/edit.png",
                                  height: 10,
                                  width: 10,
                                  scale: 1,
                                  fit: BoxFit.scaleDown,
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    addAlignedText(name ?? "", const Color(0xFF303030), 18,
                        FontWeight.w600),
                    const SizedBox(
                      height: 15,
                    ),
                    if (userRole == 'premiumUser')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      pushTo(context, const UserDetails());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(15)),
                      height: 60,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(250),
                                color: const Color(0xFFFBFBFB),
                                border: Border.all(
                                    color: const Color(0xFFE7E7E7), width: 1)),
                            child: Image.asset(
                              "assets/account.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          addText("Account Details", const Color(0xFF303030),
                              16, FontWeight.w500)
                        ],
                      ),
                    ),
                  ),
                  if (userRole == 'premiumUser')
                    const SizedBox(
                      height: 15,
                    ),
                  if (userRole == 'premiumUser')
                    InkWell(
                      onTap: () {
                        pushTo(
                            context,
                            PaymentScreen(
                              isPaymentDetail: false,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2),
                            borderRadius: BorderRadius.circular(15)),
                        height: 60,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(250),
                                  color: const Color(0xFFFBFBFB),
                                  border: Border.all(
                                      color: const Color(0xFFE7E7E7),
                                      width: 1)),
                              child: Image.asset(
                                "assets/wallet.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            addText("Payments Details", const Color(0xFF303030),
                                16, FontWeight.w500)
                          ],
                        ),
                      ),
                    ),
                  if (userRole == 'premiumUser')
                    const SizedBox(
                      height: 15,
                    ),
                  if (userRole == 'premiumUser')
                    InkWell(
                      onTap: () {
                        pushTo(context, const AddReferalScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2),
                            borderRadius: BorderRadius.circular(15)),
                        height: 60,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(250),
                                  color: const Color(0xFFFBFBFB),
                                  border: Border.all(
                                      color: const Color(0xFFE7E7E7),
                                      width: 1)),
                              child: Image.asset(
                                "assets/refer.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            addText("Referral and Loyalty Program",
                                const Color(0xFF303030), 16, FontWeight.w500)
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      pushTo(context, const ContactUsScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(15)),
                      height: 60,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(250),
                                color: const Color(0xFFFBFBFB),
                                border: Border.all(
                                    color: const Color(0xFFE7E7E7), width: 1)),
                            child: Image.asset(
                              "assets/help.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          addText("Help", const Color(0xFF303030), 16,
                              FontWeight.w500)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (userRole != 'premiumUser')
                    const SizedBox(
                      height: 15,
                    ),
                  InkWell(
                    child: addText("Log out", const Color(0xFFFF3500), 16,
                        FontWeight.w600),
                    onTap: () async {
                      SharedPreferences pre =
                          await SharedPreferences.getInstance();
                      pre.clear();
                      replaceRoute(context, const LoginScreen());
                    },
                  ),

// TextButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PDFWebViewScreen(
//           driveUrl: 'https://docs.google.com/spreadsheets/d/1tnRYPEbeT5BsvKzBYoIdcr6nUmacEz7P_Zy23tBmBsE/edit?usp=sharing',
//         ),
//       ),
//     );
//   },
//   child: Text('See price list'),
// )

// TextButton(
//   onPressed: () {
//     final priceList = context.read<HomeProvider>().getAllPriceList;

//     if (priceList != null && priceList.isNotEmpty) {
//       final url = priceList.first.image; // URL from the first item

//       if (url!.isNotEmpty) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PDFWebViewScreen(driveUrl: url ?? ''),
//           ),
//         );
//       } else {
//         // handle empty URL case, e.g. show a snackbar or alert
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Price list URL is empty')),
//         );
//       }
//     } else {
//       // handle null or empty list case
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Price list data not loaded yet')),
//       );
//     }
//   },
//   child: Text('See price list'),
// )

                  // TextButton(
                  //   onPressed: () {
                  //     final url = context.read<HomeProvider>().getAllPriceList;

                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) =>
                  //             PDFWebViewScreen(driveUrl: url.toString()),
                  //       ),
                  //     );
                  //   },
                  //   child: Text('See price list'),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getDataFromSharedPerference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getString("primary_customer_name"));
    print(pref.getString("primary_contact_no"));

    setState(() {
      name = pref.getString("name").toString();
      nameController.text = pref.getString("emergency_name").toString();
      contact_no = pref.getString("primary_contact_no").toString();
      mobileController.text = pref.getString("emergency_no").toString();
      email = pref.getString("email_id").toString();
      pan_card = pref.getString("primary_person_pan_no").toString();
      aadhar_card = pref.getString("primary_person_aadhar_no").toString();
      adderss = pref.getString("address").toString();
      birthday = pref.getString("birthday").toString();
      anniversary = pref.getString("anniversary").toString();
      userRole = pref.getString("user_role").toString();
    });
  }
}



//  {"user_info":{"name":"Tanu","contact":"8562805228","email":"tanu@gmail.com","address":"asfgh, mansarovar","country":"India","city":"jaipur","zipCode":"302020"},"paymentMethod":"Cash","status":"Pending","cart":[{"prices":{"originalPrice":159,"price":159,"discount":0},"_id":"677386aecd7081489d3174db","sku":"EDA007525903B","barcode":"6922437918451","title":{"en":"For Samsung Galaxy S24+ 5G Shockproof Clear Gradient PC + TPU Phone 
// Case(Red)"},"description":{"en":"1. Creative appearance design, fashionable and personalized.\n2. Precisely designed to fit your phone.\n3. It fully protects the device from general scratches, dirt, tears and abrasions.\n4. All buttons and ports are accessible.\n5. With good performance and quality, it can work for a long time.\n6. Made of PC+TPU material, sturdy and durable.\n\nNote: The real object is subject to the title model, and the model machine in the picture is only for effect reference."},"slug":"for-samsung-galaxy-s24-5g-shockproof-clear-gradient-pc-tp