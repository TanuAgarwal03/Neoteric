import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neoteric_flutter/booking_tab/booking_list_model.dart';
import 'package:neoteric_flutter/complaint_section/complaint_list_model.dart';
import 'package:neoteric_flutter/models/property_tyype/view_all_proprerties_model.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:neoteric_flutter/screens/login_screen.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/whatsappicon.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {

 @override
  void initState() {
    _init();
    super.initState();
  }

  _init()async{
    await HomeProvider.homeSharedInstanace.getAllbookingas();
  }






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                          child: addAlignedText('Booking List', Colors.black, 14,
                              FontWeight.w600),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.08,),
                        const WhatsappIcon(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<HomeProvider>(builder: (context, getBookings, child) {
            if (getBookings.getAllBooking == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var posts=getBookings.getAllBooking??[];
            return Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = posts[index];
              
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 40,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.property_booking_name!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          'Booking No. : ${item.booking_number!}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEC3B4).withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Date & time:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item.time != null?(item.date! + item.time!):item.timestamp!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              // overflow: TextOverflow.fade
                                            ),
                                            // maxLines: 2,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Customer Name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 15,),
                                          Expanded(
                                            child: Text(
                                              item.name!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Contact No.: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item.contact_no!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Club Services: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              textAlign: TextAlign.right,
                                              item.club_services!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'No. of Adults: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item.adult??"0",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'No. of children: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item.children??"0",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      /* Divider(
                                                 thickness: 0.5,
                                                 color: Colors.grey,
                                               ),
                                               Row(
                                                 mainAxisAlignment:
                                                 MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(
                                                     'Person Adult: ',
                                                     style: TextStyle(
                                                       fontWeight: FontWeight.w500,
                                                     ),
                                                   ),
                                                   Text(
                                                     item.person_adult!,
                                                     style: TextStyle(
                                                       fontWeight: FontWeight.w700,
                                                     ),
                                                   ),
                                                 ],
                                               ),*/
                                      /*Divider(
                                                 thickness: 0.5,
                                                 color: Colors.grey,
                                               ),
                                               Row(
                                                 mainAxisAlignment:
                                                 MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text(
                                                     'Person Child: ',
                                                     style: TextStyle(
                                                       fontWeight: FontWeight.w500,
                                                     ),
                                                   ),
                                                   Text(
                                                     item.person_child!,
                                                     style: TextStyle(
                                                       fontWeight: FontWeight.w700,
                                                     ),
                                                   ),
                                                 ],
                                               ),*/
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),


     /* body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureProvider<List<BookingListModel>>(
          create: (context) => fetchComplaintList(),
          initialData: [], // Set initialData to an empty list
          catchError: (context, error) {
            print('Error: $error');
            return []; // Return an empty list in case of an error.
          },
          child: Consumer<List<BookingListModel>>(
            builder: (context, items, _) {
              if (items.isEmpty) {
                if (items == null || items.isEmpty) {
                  // Show circular progress indicator while data is being fetched
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Show "no data found" message if the list is empty
                  return Center(child: Text('No data found'));
                }
              } else {
                // Display the list if it contains data
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 40,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.property_booking_name!,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text(
                                            'Property no: ${item.booking_number!}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffECEDEA),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Date & time:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item.timestamp!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Customer Name: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item.name!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Contact No.: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item.contact_no!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Room Type: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item.room_type!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Person Adult: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item.person_adult!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Person Child: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item.person_child!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        )

      ),*/

    );
  }



/*  Future<List<BookingListModel>> fetchComplaintList() async {


    SharedPreferences pref= await SharedPreferences.getInstance();
    print("get_preference_data===repair");
    // print(pref.getString("is_login"));
    print(pref.getString("primary_contact_no"));
    String mobileno=pref.getString("primary_contact_no").toString();

    //9425111133
    final response = await http.get(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Booking_history?Phone=$mobileno'));

    if (response.statusCode == 200) {

      // final List result = jsonDecode(response.body);
      //  final Map<String, dynamic> data = json.decode(response.body);
      // final List<dynamic> dataList = data['data'];
      // return dataList.map((itemJson) => GameListModel.fromJson(itemJson)).toList();
      // return result.map((e) => GameListModel.fromJson(e)).toList();


      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check the responseCode and responseMsg fields for success

      if(responseData['status'] == false){
        return [];
      }else{
        final List<dynamic> dataList = responseData['ComplaintData'];
        print("getApp===booking");
        print(responseData['ComplaintData']);
        print("check=booking==${dataList.length}");
        //   print(responseData['ComplaintData'][0]['Name']);
        //  print(dataList.first.toString());

        return dataList.map((itemJson) => BookingListModel.fromJson(itemJson)).toList();

      }



    }

    else {
      throw Exception('Failed to load data');
    }
  }*/










}
