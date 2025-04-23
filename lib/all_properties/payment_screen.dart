import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neoteric_flutter/models/property_tyype/paymnet_plan_model.dart';
import 'package:neoteric_flutter/utils/api_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../providers/home_provider.dart';
import '../utils/constants.dart';
import '../widgets/whatsappicon.dart';

class PaymentScreen extends StatefulWidget {
  bool isPaymentDetail;
  PaymentScreen({super.key, required this.isPaymentDetail});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<List<PaymentPlanModel>>? postsFuture;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () async {
      _init();
    });
    super.initState();
  }

  Future<void> _init() async {
    try {
      if (HomeProvider.homeSharedInstanace.getProperties == null) {
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
                var projectIndex = HomeProvider
                    .homeSharedInstanace.getAllProject!
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
        if (!widget.isPaymentDetail) {
          if (HomeProvider.homeSharedInstanace.getProperties != null) {
            if ((HomeProvider.homeSharedInstanace.getProperties?.length ?? 0) >
                0) {
              HomeProvider.homeSharedInstanace.changePropertyDetails(
                  HomeProvider.homeSharedInstanace.getProperties![0]);
            }
          }
        }
        await HomeProvider.homeSharedInstanace.getPaymentData();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // FutureBuilder
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
                            child: addAlignedText(
                                'Payments', Colors.black, 14, FontWeight.w600),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          ),
                          const WhatsappIcon(),
                        ],
                      ),
                    ),
                    Consumer<HomeProvider>(
                        builder: (context, getproperties, child) {
                      return (getproperties.getProperties?.length ?? 0) > 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.network(
                                                          getproperties
                                                                  .getPropertiesDetails
                                                                  ?.projectData
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
                                                              getproperties
                                                                      .getPropertiesDetails
                                                                      ?.project_name ??
                                                                  "",
                                                              const Color(
                                                                  0xFF303030),
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
                                                if (!widget.isPaymentDetail)
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
                                                                const Color(
                                                                    0xFFFF3803),
                                                                11,
                                                                FontWeight
                                                                    .bold),
                                                            // const SizedBox(
                                                            //   width: 5,
                                                            // ),
                                                            // Transform.flip(
                                                            //     flipY: getproperties
                                                            //             .showAllProperties
                                                            //         ? true
                                                            //         : false,
                                                            //     child:
                                                            //         Image.asset(
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
                                            onTap: () async {
                                              getproperties
                                                  .changePropertyDetails(
                                                      propertyItem);
                                              getproperties.changeAllProperty(
                                                  !getproperties
                                                      .showAllProperties);
                                              try {
                                                await HomeProvider
                                                    .homeSharedInstanace
                                                    .getPaymentData();
                                              } catch (e) {}
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
                                                              "${propertyItem.project_name ?? ""} (Unit- ${propertyItem.unit_no ?? ""})",
                                                              const Color(
                                                                  0xFF303030),
                                                              13,
                                                              FontWeight.w500),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          // addText(propertyItem.unit_no ?? "20",const Color(0xFF303030),
                                                          //     13,
                                                          //     FontWeight.w500 ),
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
                                ],
                                const SizedBox(
                                  height: 20,
                                ),
                                if (getproperties.total_amount != null) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          addText(
                                              "Total Amount",
                                              const Color(0xFF676767),
                                              12,
                                              FontWeight.w500),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          addText(
                                              "₹${getproperties.total_amount ?? ""}",
                                              const Color(0xFF404040),
                                              14,
                                              FontWeight.w600),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          addText(
                                              "Due Amount",
                                              const Color(0xFF676767),
                                              12,
                                              FontWeight.w500),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          addText(
                                              "₹${getproperties.pending_amount ?? "0"}",
                                              const Color(0xFF404040),
                                              14,
                                              FontWeight.w600),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                                const SizedBox(
                                  height: 20,
                                ),
                                if (getproperties.getPaymentList != null &&
                                    getproperties
                                        .getPaymentList!.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: addText(
                                        "History",
                                        const Color(0xFF404040),
                                        14,
                                        FontWeight.w500),
                                  ),
                                ],
                              ],
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            Consumer<HomeProvider>(builder: (context, getproperties, child) {
              if (getproperties.getPaymentList == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: getproperties.getPaymentList!.isEmpty
                    ? const Center(
                        child: Text("No record found"),
                      )
                    : ListView.builder(
                        itemCount: getproperties.getPaymentList?.length ?? 0,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final item = getproperties.getPaymentList![index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xffFCFCFC),
                                      spreadRadius: 3),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/card.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      addText(
                                                          "Installment ${item.Installments ?? ""}",
                                                          const Color(
                                                              0xFF404040),
                                                          14,
                                                          FontWeight.w500),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          addText(
                                                              "${item.date ?? ""} • ",
                                                              const Color(
                                                                  0xFF6D6D6D),
                                                              10,
                                                              FontWeight.w500),
                                                          addText(
                                                              item.payment_status
                                                                          .toString() ==
                                                                      "Done"
                                                                  ? "Paid"
                                                                  : "Pending",
                                                              item.payment_status
                                                                          .toString() ==
                                                                      "Done"
                                                                  ? const Color(
                                                                      0xFF006817)
                                                                  : const Color(
                                                                      0xFFFF3500),
                                                              10,
                                                              FontWeight.w500),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              item.payment_status.toString() ==
                                                      "Done"
                                                  ? Row(
                                                      children: [
                                                        addText(
                                                            '₹${item.payment_inr}',
                                                            const Color(
                                                                0xFF006817),
                                                            14,
                                                            FontWeight.w600),
                                                        const SizedBox(width: 4),
                                                        Tooltip(
                                                          message:
                                                              "Download receipt",
                                                          triggerMode:
                                                              TooltipTriggerMode
                                                                  .longPress,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              if (!await launchUrl(
                                                                  Uri.parse(item
                                                                      .payment_receipt!))) {
                                                                throw Exception(
                                                                    'Failed to open receipt');
                                                              }
                                                            },
                                                            child: const Icon(
                                                                Icons.download,
                                                                size: 20),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        if (!await launchUrl(
                                                            Uri.https(
                                                                item.payment_link!
                                                                    .toString(),
                                                                ''))) {
                                                          throw Exception(
                                                              'Could not launch');
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 130,
                                                        height: 40,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFFF6339),
                                                          //  gradient: LinearGradient(colors: [Color(0xff372CD2), Color(0xff6058D3)]),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          //  color: Colors.red
                                                        ),
                                                        child: Center(
                                                            child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Pay ₹${item.payment_inr}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ),
                                                    ),
                                            ],
                                          )
                                          // Column(
                                          //   children: [
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Customer Id:', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         Text(item.customer_id.toString()!, style: TextStyle(
                                          //             fontWeight: FontWeight.w700
                                          //         ),),
                                          //       ],
                                          //     ),
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Property Id: ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         Text(item.property_id!,
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Payment Id: ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         Text(item.payment_id!,
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Date: ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         Text(item.date!,
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Payment(INR): ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         Text(item.payment_inr!,
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Payment(%): ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         Text(item.payment_percent!,
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Payment Satus: ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //         GestureDetector(
                                          //           onTap: () {
                                          //
                                          //           },
                                          //           child: Text(item.payment_status!.toString(),
                                          //             style: TextStyle(
                                          //                 fontWeight: FontWeight.w700
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Payment Recieve: ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //
                                          //
                                          //         Text(item.payment_recieve!.toString(),
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //
                                          //
                                          //       ],
                                          //     ),
                                          //
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //
                                          //     Row(
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Text('Comments From Admin: ', style: TextStyle(
                                          //             fontWeight: FontWeight.w500
                                          //         ),),
                                          //
                                          //         Text(item.comments_from_admin!.toString(),
                                          //           style: TextStyle(
                                          //               fontWeight: FontWeight.w700
                                          //           ),
                                          //         ),
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //       ],
                                          //     ),
                                          //
                                          //     // Divider(thickness: 0.5,color: Colors.grey,),
                                          //
                                          //
                                          //     Divider(thickness: 0.5,color: Color(0xffE6E6E6),),
                                          //
                                          //     /*
                                          //         Row(
                                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //           children: [
                                          //             Text('Payment Link: ', style: TextStyle(
                                          //                 fontWeight: FontWeight.w500
                                          //             ),),
                                          //
                                          //             Text(item.payment_link!.toString(),
                                          //               style: TextStyle(
                                          //                   fontWeight: FontWeight.w700
                                          //               ),
                                          //             ),
                                          //
                                          //
                                          //           ],
                                          //         ),*/
                                          //
                                          //
                                          //     SizedBox(height: 10,),
                                          //     item.payment_status!.toString().toLowerCase() == "done"?  Container()
                                          //
                                          //         : GestureDetector(
                                          //       onTap: ()async{
                                          //
                                          //         if (!await launchUrl(Uri.https(item.payment_link!.toString(), ''))) {
                                          //           throw Exception('Could not launch');
                                          //         }
                                          //
                                          //         /* final Uri url = Uri(
                                          //                 scheme: 'https', host: 'https://www.google.com', path:'');
                                          //             if (!await launchUrl(url,
                                          //                 mode: LaunchMode.externalApplication)) {
                                          //               throw 'Could not launch $url';
                                          //             }*/
                                          //
                                          //
                                          //       },
                                          //       child: Container(
                                          //         width: 130,
                                          //         height: 40,
                                          //         decoration: const BoxDecoration(
                                          //           color: Colors.red,
                                          //           //  gradient: LinearGradient(colors: [Color(0xff372CD2), Color(0xff6058D3)]),
                                          //           borderRadius: BorderRadius.all(Radius.circular(20)),
                                          //           //  color: Colors.red
                                          //         ),
                                          //         child: Center(child: Padding(
                                          //           padding: const EdgeInsets.only(top: 10,bottom: 10),
                                          //
                                          //           child: Row(
                                          //             mainAxisAlignment: MainAxisAlignment.center,
                                          //             children: [
                                          //
                                          //               Text('Payment Link',style: TextStyle(
                                          //                   color: Colors.white,
                                          //                   fontSize: 17
                                          //               ),),
                                          //             ],
                                          //           ),
                                          //         )),
                                          //       ),
                                          //     ),
                                          //
                                          //   ],
                                          // ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
