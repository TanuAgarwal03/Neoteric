import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:neoteric_flutter/booking_tab/add_booking.dart';
import 'package:neoteric_flutter/models/slider/slidermodel.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:neoteric_flutter/screens/home_tab.dart';
import 'package:http/http.dart' as http;
import 'package:neoteric_flutter/complaint_section/service_request_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'document_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  static  final List<Widget> _widgetOptions = <Widget>[
    const HomeTabScreen(),
    ServiceRequestScreen(isHome: false),
    //RequestHome(),
    const DocumentScreen(),
    AddBooking(isHome: false,)
    //BookingHome(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final int _currentIndex = 0;


  @override
  void initState() {
    HomeProvider.homeSharedInstanace.getOwenerContactNumber();
    HomeProvider.homeSharedInstanace.getImage();
    _init();
    getSharedPreferenceData();
    super.initState();
  }
  Future<void> _init()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    HomeProvider.homeSharedInstanace.changeUserName(pref.getString("name").toString());
    HomeProvider.homeSharedInstanace.changeMobileNo(pref.getString("primary_contact_no").toString());
  }


  void getSharedPreferenceData() async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    print("get_preference_data===repair");
    print(pref.getString("is_login"));
    print(pref.getString("primary_contact_no"));

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(




    /*  body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         *//* Center(
            child: ElevatedButton(
              child: const Text("Custom widget example"),
              onPressed: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CustomWidgetExample(
                  menuScreenContext: context,
                ),
              ),
            ),
          ),*//*
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              child: const Text("Built-in styles example"),
              onPressed: () => PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: ProvidedStylesExample(
                  menuScreenContext: context, key: null,
                ),
              ),
            ),
          ),
        ],
      ),*/

      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(

              //  icon: Icon(Icons.home),
                icon: ImageIcon(AssetImage('assets/home_bar.png',),size: 28,),
                label: 'Home',

                backgroundColor: Colors.white
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/complaint_bar.png'),size: 28,),
                label: 'Complaint',
               // title: Text('Search'),
                backgroundColor: Colors.white
            ),

            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/document.png'),size: 28,),
              label: 'Documents',
            //  title: Text('Profile'),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/booking_bar.png'),size: 28,),
              label: 'Booking',
            //  title: Text('Profile'),
              backgroundColor: Colors.white,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5
      ),


    );
  }


  Future<List<SliderModel>> getSliderData() async {


    // http://mudra.metzane.com/api/slider

    final response = await http.get(Uri.parse("https://lytechxagency.website/Laravel_GoogleSheet/Slider_images"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",

        });

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check the responseCode and responseMsg fields for success

        final List<dynamic> dataList = responseData['WorkCategory'];
        print("getApp===slider");
        print(responseData['WorkCategory']);
        print("check===slider${dataList.length}");

        return dataList.map((itemJson) => SliderModel.fromJson(itemJson)).toList();


    } else {
      throw Exception('Failed to load data');
    }


  }


}



