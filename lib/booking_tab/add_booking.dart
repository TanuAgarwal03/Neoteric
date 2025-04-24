import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:neoteric_flutter/modules/widgets/base_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../all_properties/properties_details.dart';
import '../models/club_services_model.dart';
import '../providers/home_provider.dart';
import '../utils/constants.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/whatsappicon.dart';

class AddBooking extends StatefulWidget {
  bool isHome=false;
  AddBooking({super.key,required this.isHome});

  @override
  State<AddBooking> createState() => _AddBookingState();
}

class _AddBookingState extends State<AddBooking> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController endController = TextEditingController();
  bool isLoading = false;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<String> monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  List<String> weekDayList = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  String? _selectedRequestData;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  bool isAmSelected = true;

  @override
  void initState() {
    super.initState();

    _init();
  }




  _init() async {
    String formattedHour = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).hourOfPeriod.toString().padLeft(2, '0');
    String formattedMinute = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).minute.toString().padLeft(2, '0');
    _hourController.text=formattedHour;
    _minuteController.text=formattedMinute;
    String formattedDate =
    DateFormat('dd-MM-yyyy').format(selectedDay);
    print(
        formattedDate); //formatted date output using intl package =>  2021-03-16
    //you can implement different kind of Date Format here according to your requirement


    fromController.text =
        formattedDate;
    endController.text =
        formattedDate;
    print(fromController.text);
    getDataFromSharedPreferance();
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
    try {
      await HomeProvider.homeSharedInstanace.getAllAmenties();
    } catch (e) {
      print(e);
    }
  }

  void getDataFromSharedPreferance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = pref.getString("name").toString();
      phoneController.text = pref.getString("primary_contact_no").toString();
    });
  }

  void _selectAMPM(bool isAM) {
    setState(() {
      isAmSelected = isAM;
    });
  }

  int _childrentCounter = 0;

  void _incrementChildrenCounter() {
    setState(() {
      _childrentCounter++;
    });
  }

  void _decrementChildrenCounter() {
    setState(() {
      if (_childrentCounter > 0) {
        _childrentCounter--;
      }
    });
  }


  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart=DateTime.now();
  DateTime? _rangeEnd=DateTime.now();

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
                      children: [
                        widget.isHome?
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 120,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Row(
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ):const SizedBox(width: 120,height: 50,),
                        addAlignedText('Amenities Booking', Colors.black, 14,
                            FontWeight.w600),
                        const Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: WhatsappIcon(),
                        )),
                      ],
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
                                                                  ""} (Unit- ${propertyItem.unit_no ?? ""}) ",
                                                                  // (Unit- ${propertyItem.unit_no ?? ""})
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
            Consumer<HomeProvider>(builder: (context, getproperties, child) {
              if (getproperties.getAllAmentiesList == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    addText("Select Amenities", const Color(0xFF404040), 15,
                        FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount:
                            getproperties.getAllAmentiesList?.length ?? 0,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final amenties =
                              getproperties.getAllAmentiesList![index];
                          final isSelected =
                              getproperties.selectedIndices.contains(index);
                          return Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  getproperties.selectAmenties(
                                      isSelected, index);
                                },
                                child: Container(
                                  height: 90,
                                  width: 85,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF6F6F6),
                                      borderRadius: BorderRadius.circular(10),
                                      border: isSelected
                                          ? Border.all(
                                              color: const Color(0xFFFF3803),
                                              width: 0.5)
                                          : null),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        amenties.image ?? "",
                                        fit: BoxFit.cover,
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      addAlignedText(
                                          amenties.name ?? "",
                                          const Color(0xFF404040),
                                          12,
                                          FontWeight.w500)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  addText(
                      "Select Date", const Color(0xFF404040), 15, FontWeight.w500),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF404040)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        TableCalendar(
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekendStyle: const TextStyle(color: Color(0xFFFF3803)),
                            weekdayStyle: const TextStyle(color: Color(0xFFFF3803)),
                            dowTextFormatter: (date, locale) {
                              return weekDayList[date.weekday - 1];
                            },
                          ),
                          rangeStartDay: _rangeStart,
                          rangeEndDay: _rangeEnd,
                          rangeSelectionMode: _rangeSelectionMode,
                          onRangeSelected: (start, end, focusedDay) {
                            print(start);
                            print(end);
                            _focusedDay = focusedDay;
                            _rangeStart = start;
                            _rangeEnd = end;
                            if(start != null){
                              String formattedDate =
                              DateFormat('dd-MM-yyyy').format(start??DateTime.now());
                              fromController.text=formattedDate;
                            }
                            if(end != null){
                              String formattedDate =
                              DateFormat('dd-MM-yyyy').format(start??DateTime.now());
                              fromController.text=formattedDate;
                            }



                            //_rangeSelectionMode = RangeSelectionMode.toggledOn;
                            setState(() {
                              // Update the focused day only if the month changes
                              if (focusedDay.month != selectedDay.month) {
                                selectedDay = focusedDay;
                              }
                            });
                          },
                          // calendarStyle: ,
                          firstDay: DateTime.now(),
                          lastDay: DateTime.utc(2050, 3, 14),
                          currentDay: selectedDay,
                          focusedDay: selectedDay,
                          calendarFormat: format,
                          availableGestures: AvailableGestures.none,

                          startingDayOfWeek: StartingDayOfWeek.monday,

                          headerStyle: const HeaderStyle(
                              formatButtonVisible: false, titleCentered: true),

                          onFormatChanged: (CalendarFormat format) {
                            setState(() {
                              format = format;
                            });
                          },
                          //Day Changed on select
                          onDaySelected:
                              (DateTime selectDay, DateTime focusDay) {
                                if (!isSameDay(_selectedDay, selectedDay)) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    _rangeStart = null; // Important to clean those
                                    _rangeEnd = null;
                                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                                  });
                                }
                            // setState(() {
                            //   selectedDay = selectDay;
                            //   focusedDay = focusDay;
                            //   String formattedDate =
                            //   DateFormat('dd-MM-yyyy').format(selectedDay);
                            //   print(
                            //       formattedDate); //formatted date output using intl package =>  2021-03-16
                            //   //you can implement different kind of Date Format here according to your requirement
                            //
                            //
                            //     fromController.text =
                            //         formattedDate;
                            //     print(fromController.text);
                            //     //set output date to TextField value.
                            // });


                            // print("::::focus day=> " +
                            //     Get.find<AuthController>()
                            //         .focusedDay
                            //         .toString());
                          },
                          selectedDayPredicate: (DateTime date) {
                            return isSameDay(selectedDay, date);
                          },

                          // calender style
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: false,
                            rangeStartDecoration: const BoxDecoration(
                              color: Color(0xFFFF3803),
                              shape: BoxShape.circle,
                            ),
                            rangeStartTextStyle:  const TextStyle(color: Color(0xFFFFFFFF)),
                            rangeEndTextStyle:  const TextStyle(color: Color(0xFFFFFFFF)),
                            rangeEndDecoration: const BoxDecoration(
                              color: Color(0xFFFEC3B4),
                              shape: BoxShape.circle,
                            ),
                            rangeHighlightColor: const Color(0xFFFEC3B4),
                            // withinRangeDecoration: BoxDecoration(
                            //   color: Color(0xFFFF3803),
                            //   shape: BoxShape.circle,
                            // ),
                            selectedDecoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFFF3803)),
                                shape: BoxShape.circle,
                                color: const Color(0xFFFF3803)),
                            selectedTextStyle:
                                const TextStyle(color: Color(0xFFFFFFFF)),

                            // today
                            todayDecoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFFF3803)),
                                shape: BoxShape.circle,
                                color: const Color(0xFFFF3803)),
                            weekendTextStyle:
                                const TextStyle(color: Color(0xFFFF3803)),
                            //   weekNumberTextStyle: const TextStyle(color: ColorConstants.primaryColor)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              addText(
                                  "Time", const Color(0xFF000000), 12, FontWeight.bold),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(onTap: ()async{
                                      var timePicker=await showTimePicker(context: context, initialTime:
                                      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                                      builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                                    child: child!,
                                  );
                                },);
                                      if (timePicker != null) {
                                        String formattedHour = timePicker.hourOfPeriod.toString().padLeft(2, '0');
                                        String formattedMinute = timePicker.minute.toString().padLeft(2, '0');
                                        _hourController.text=formattedHour;
                                        _minuteController.text=formattedMinute;
                                        setState(() {

                                        });

                                        String period = timePicker.period == DayPeriod.am ? 'AM' : 'PM';

                                        print('Selected time: $formattedHour:$formattedMinute $period');
                                      }
                                    },
                                        child:Container(
                                          height: 35,
                                          width: 60,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFF6F6F6),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: addText(
                                              "${_hourController.text} : ${_minuteController.text}", const Color(0xFF000000), 12, FontWeight.bold),
                                        )),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      height: 35,
                                      child: ToggleButtons(
                                        isSelected: [isAmSelected, !isAmSelected],
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey,
                                        selectedColor: Colors.white,
                                        disabledColor: Colors.grey,
                                        fillColor: Colors.white, // Adjust the fill color as needed
                                        borderWidth: 1, // Border width
                                        onPressed: (index) {
                                          _selectAMPM(index == 0);
                                        },
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: 3),
                                            child: addText("AM", Colors.black, 12, FontWeight.w600)
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: 3),
                                            child: addText("PM", Colors.black, 12, FontWeight.w600)
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        const SizedBox(height: 30,),
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15)

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              addText("No. of Adults", const Color(0xFF404040), 14, FontWeight.bold),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.remove,),
                        onPressed: _decrementCounter,
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$_counter',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.add),
                        onPressed: _incrementCounter,
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
            Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  addText("No. of children", const Color(0xFF404040), 14, FontWeight.bold),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: const Icon(Icons.remove,),
                            onPressed: _decrementChildrenCounter,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$_childrentCounter',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add),
                            onPressed: _incrementChildrenCounter,
                            iconSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            isLoading
                ? const SpinKitChasingDots(
              //  isLoading? SpinKitRotatingCircle(
              color: Colors.red,
              size: 80.0,
              //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
            ):Padding(
              padding: const EdgeInsets.all(20.0),
              child: BaseButton(onPress: (){
                if(HomeProvider.homeSharedInstanace.selectedIndices.isEmpty)
                  {
                    Fluttertoast.showToast(
                        msg: "Please Select atleast one amenities",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                else if(_rangeStart == null && _rangeEnd == null)
                {
                  Fluttertoast.showToast(
                      msg: "Please Select Dates",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                else{
                  setState(() {
                    isLoading=true;
                  });
                  addDataToServer();
                }
              }, title: "Book Amenities",borderradius: 10,),
            )
          ],
        ),
      ),
    );
  }

  showDialogBoxConfirmed() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        //title: const Text("LogOut"),
        content:
            const Text("Thanks for your query we will connect with you soon."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //  logOut();
              Navigator.of(ctx).pop();
            },
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                color: Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                //  color: Colors.red
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "OK",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addDataToServer() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    List<dynamic> selectedNames = [];
    var amenities = HomeProvider.homeSharedInstanace.getAllAmentiesList; // Assuming this is a list of amenities

    if (amenities != null) {
      for (int index in HomeProvider.homeSharedInstanace.selectedIndices) {
        if (index >= 0 && index < amenities.length) {
          selectedNames.add('"${amenities[index].name.toString()}"');
        }
      }
    }

    print(selectedNames);
    String date=fromController.text.toString();
    if(fromController.text.toString() == endController.text.toString())
      {
        date=fromController.text.toString();
      }else{
      date="${fromController.text.toString()} to ${endController.text.toString()}";
    }

    final Map<String, dynamic> requestBody = {
      "property_booking_name": HomeProvider.homeSharedInstanace.getPropertiesDetails?.project_name??"",
      "name": nameController.text.toString(),
      "contact_no": phoneController.text.toString(),
      "club_services": selectedNames.toString() /*_selectedRequestData*/,
      "date": date,
      "person_adult": _counter.toString(),
      "person_Child": _childrentCounter.toString(),
      "booking_time": "${_hourController.text}:${_minuteController.text} ${isAmSelected?"AM":"PM"}",
      "Unit_No" :HomeProvider.homeSharedInstanace.getPropertiesDetails?.unit_no??""
      // Add any other required fields in the request body
    };
    print(jsonEncode(requestBody));

    final response = await http.post(
      Uri.parse('https://lytechxagency.website/Laravel_GoogleSheet/Booking'),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        fromController.text = "";
        _counter = 0;
        _childrentCounter = 0;
        String formattedHour = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).hourOfPeriod.toString().padLeft(2, '0');
        String formattedMinute = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).minute.toString().padLeft(2, '0');
        _hourController.text=formattedHour;
        _minuteController.text=formattedMinute;
        _rangeStart=DateTime.now();
        _rangeEnd=DateTime.now();
        String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
        fromController.text =
            formattedDate;
        print(
            formattedDate); //formatted date output using intl package =>  2021-03-16
        //you can implement different kind of Date Format here according to your requirement


        fromController.text =
            formattedDate;
        endController.text =
            formattedDate;
        print(fromController.text);
        selectedDay = DateTime.now();
        focusedDay = DateTime.now();
        HomeProvider.homeSharedInstanace.resetAmenties();
      });

      final jsonResponse = json.decode(response.body);

      print(jsonResponse['msg'].toString());

      /* Fluttertoast.showToast(
          msg: jsonResponse['msg'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);*/

      showDialogBoxConfirmed();
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Something went wrong. Please try again later.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception('Failed to load data');
    }
  }

  // String printSelectedNames() {
  //   List<String> selectedNames = _ServiceRequestData
  //       .where((item) => item.isSelected!)
  //       .map((item) =>  '"${item.name}"')
  //       .toList();
  //
  //   return selectedNames.toString();
  //   print(selectedNames.toString());
  // }
}
