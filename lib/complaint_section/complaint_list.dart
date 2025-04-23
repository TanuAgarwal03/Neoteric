import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neoteric_flutter/complaint_section/complaint_list_model.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/whatsappicon.dart';

class ComplaintList extends StatefulWidget {
  const ComplaintList({super.key});

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  bool showText = false;

 //s Future<List<ComplaintListModel>>? postsFuture;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init()async{
    await HomeProvider.homeSharedInstanace.fetchAllServicesList();
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
                          child: addAlignedText('Service List', Colors.black, 14,
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
            if (getBookings.getAllServices == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var posts=getBookings.getAllServices??[];
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
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        //  color: Colors.red
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(item.image!,width: 120,height: 120,fit: BoxFit.cover,
                                      errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                        return Image.asset('assets/default.jpeg',width: 120,height: 120,);
                                      },
                                    )
                                ),
              
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                  
                                  
                                  
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width-160,
                                          //  color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0,top: 0),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffECEDEA),
                                                    //gradient: LinearGradient(colors: [Color(0xffFF3D00), Color(0xffFF2E00)]),
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    //  color: Colors.red
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(item.status!,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff537062)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  
                                  
                                  
                                            ],
                                          ),
                                        ),
                                  
                                        const SizedBox(height: 7,),
                                  
                                        Text(item.name!,style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                        ),),
                                  
                                        const SizedBox(height: 5,),
                                  
                                        Row(
                                          children: [
                                  
                                            Text('Mobile no: ${item.contact!}',style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600
                                            ),),
                                          ],
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
                                  color:const Color(0xFFFEC3B4).withOpacity(0.2),
                                  //gradient: LinearGradient(colors: [Color(0xffFF3D00), Color(0xffFF2E00)]),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  //  color: Colors.red
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Project Name:', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.projectName!, style: const TextStyle(
                                              fontWeight: FontWeight.w700
                                          ),),
                                        ],
                                      ),
                                      const Divider(thickness: 0.5,color: Colors.grey,),
              
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Date & time:', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.timestamp!, style: const TextStyle(
                                              fontWeight: FontWeight.w700
                                          ),),
                                        ],
                                      ),
                                      const Divider(thickness: 0.5,color: Colors.grey,),
                                      /*  Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Customer: ', style: TextStyle(
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                Text(item.name!,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(thickness: 0.5,color: Colors.grey,),*/
              
                                      /*    Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Contact No.: ', style: TextStyle(
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                Text(item.contact!,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(thickness: 0.5,color: Colors.grey,),*/
              
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Request Category: ', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.request_category!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 0.5,color: Colors.grey,),
              
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Request Type: ', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.request_type!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 0.5,color: Colors.grey,),
              
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Request About: ', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.request_about!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 0.5,color: Colors.grey,),
              
              
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Description: ', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.narration!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 0.5,color: Colors.grey,),
              
              
                                      /*Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Contact : ', style: TextStyle(
                                                    fontWeight: FontWeight.w500
                                                ),),
                                                Text(item.contact!,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(thickness: 0.5,color: Colors.grey,),*/
              
              
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Comments From Admin: ', style: TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),),
                                          Text(item.commetns_from_admin!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Divider(thickness: 0.5,color: Colors.grey,),
              
              
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
      )

    );
  }



  /*Future<List<ComplaintListModel>> fetchComplaintList() async {


    SharedPreferences pref= await SharedPreferences.getInstance();
    print("get_preference_data===repair");
   // print(pref.getString("is_login"));
    print(pref.getString("primary_contact_no"));
    String mobileno=pref.getString("primary_contact_no").toString();

                                                                                                                 //9425111133
    final response = await http.get(Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Complaints_list?Phone=$mobileno'));


    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map<ComplaintListModel>((item) => ComplaintListModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }


    *//*if (response.statusCode == 200) {

      // final List result = jsonDecode(response.body);
      //  final Map<String, dynamic> data = json.decode(response.body);
      // final List<dynamic> dataList = data['data'];
      // return dataList.map((itemJson) => GameListModel.fromJson(itemJson)).toList();
      // return result.map((e) => GameListModel.fromJson(e)).toList();


      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check the responseCode and responseMsg fields for success

        final List<dynamic> dataList = responseData['ComplaintData'];
        print("getApp===");
        print(responseData['ComplaintData']);
        print("check===${dataList.length}");
        print(responseData['ComplaintData'][0]['Name']);
        print(dataList.first.toString());

        if(dataList.length > 0){
          print('get_search_===greater than 0');
          return dataList.map((itemJson) => ComplaintListModel.fromJson(itemJson)).toList();
        }else{
          print('get_search_=== less than 0');
          return [];
        }




    } else {
      throw Exception('Failed to load data');
    }*//*



  }

*/

}
