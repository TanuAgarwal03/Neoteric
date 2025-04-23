import 'package:flutter/material.dart';
import 'package:neoteric_flutter/all_properties/payment_screen.dart';
import 'package:neoteric_flutter/all_properties/youtube_player.dart';
import 'package:neoteric_flutter/models/property_tyype/paymnet_plan_model.dart';
import 'package:neoteric_flutter/utils/constants.dart';
import 'package:neoteric_flutter/widgets/navigation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/property_tyype/view_all_proprerties_model.dart';
import '../modules/widgets/base_tab_bar.dart';
import '../widgets/whatsappicon.dart';

class PropertiesDetails extends StatefulWidget {
  ViewAllPropertiesModel viewAllPropertiesModel;
   PropertiesDetails({super.key,required this.viewAllPropertiesModel});
  @override
  State<PropertiesDetails> createState() => _PropertiesDetailsState();
}

class _PropertiesDetailsState extends State<PropertiesDetails> with SingleTickerProviderStateMixin{

  late TabController tabController;
  Future<List<PaymentPlanModel>>? postsFuture;
  int selectedIndex=0;
  List<dynamic> propertyDetails=[];
  List<dynamic> propertyamentiesDetails=[];

  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedIndex,
    );
    if(widget.viewAllPropertiesModel.area != null)
    {
      propertyDetails.add({
        "icon":"assets/area.png",
        "title":"Area",
        "value":widget.viewAllPropertiesModel.area??"",
      });
    }
    if(widget.viewAllPropertiesModel.property_type != null)
    {
      propertyDetails.add({
        "icon":"assets/house.png",
        "title":"Property",
        "value":widget.viewAllPropertiesModel.property_type??"",
      });
    }
    if(widget.viewAllPropertiesModel.floor != null)
    {
      propertyDetails.add({
        "icon":"assets/floor.png",
        "title":"Floor",
        "value":widget.viewAllPropertiesModel.floor??"",
      });
    }

    if(widget.viewAllPropertiesModel.area != null)
    {
      propertyDetails.add({
        "icon":"assets/bed.png",
        "title":"Bedrooms",
        "value":widget.viewAllPropertiesModel.area??"",
      });
    }
    if(widget.viewAllPropertiesModel.rera != null)
    {
      propertyDetails.add({
        "icon":"assets/rera.png",
        "title":"Rera",
        "value":widget.viewAllPropertiesModel.rera??"",
      });
    }

    propertyamentiesDetails.add({
      "icon":"assets/track.png",
      "title":"Jogging/Cycling Track",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    propertyamentiesDetails.add({
      "icon":"assets/verified.png",
      "title":"24x7 Security",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    if(widget.viewAllPropertiesModel.temple != null && widget.viewAllPropertiesModel.temple!.isNotEmpty && widget.viewAllPropertiesModel.temple.toString().toLowerCase()=="yes")
      {
        propertyamentiesDetails.add({
          "icon":"assets/temple.png",
          "title":"Temple",
          "value":widget.viewAllPropertiesModel.area??"",
        });
      }

    propertyamentiesDetails.add({
      "icon":"assets/energy.png",
      "title":"24x7 Power Back",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    if(widget.viewAllPropertiesModel.evcharging != null &&
        widget.viewAllPropertiesModel.evcharging!.isNotEmpty &&
        widget.viewAllPropertiesModel.evcharging.toString().toLowerCase()=="yes")
    {
      propertyamentiesDetails.add({
        "icon":"assets/electriccar.png",
        "title":"EV Charging",
        "value":widget.viewAllPropertiesModel.area??"",
      });
    }

    propertyamentiesDetails.add({
      "icon":"assets/swimming.png",
      "title":"Swimming Pool",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    propertyamentiesDetails.add({
      "icon":"assets/park.png",
      "title":"Curated Park",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    propertyamentiesDetails.add({
      "icon":"assets/zym.png",
      "title":"Gymnasium",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    propertyamentiesDetails.add({
      "icon":"assets/club.png",
      "title":"Turf",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    propertyamentiesDetails.add({
      "icon":"assets/court.png",
      "title":"Padle Court",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    propertyamentiesDetails.add({
      "icon":"assets/lounge.png",
      "title":"Lounge",
      "value":widget.viewAllPropertiesModel.area??"",
    });
    if(widget.viewAllPropertiesModel.healthcare != null &&
        widget.viewAllPropertiesModel.healthcare!.isNotEmpty &&
        widget.viewAllPropertiesModel.healthcare.toString().toLowerCase()=="yes")
    {
      propertyamentiesDetails.add({
        "icon":"assets/healthcare.png",
        "title":"Healthcare",
        "value":widget.viewAllPropertiesModel.area??"",
      });
    }




    tabController.addListener(() {
      selectedIndex = tabController.index;
      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Row(
            children: [
              const Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 28,),
              addText('Back', Colors.black, 12, FontWeight.w400),
            ],
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        leadingWidth: 100,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title:  addAlignedText('Property Details', Colors.black, 14, FontWeight.w600),
        actions: const [
          Row(
            children: [
              WhatsappIcon(),
              SizedBox(width: 10,)
            ],
          ),
        ],

      ),

      body: ListView(
        children: [
          Image.network(widget.viewAllPropertiesModel.projectData?.image??"",fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addText(widget.viewAllPropertiesModel.projectData?.name??"", const Color(0xFF303030), 16, FontWeight.w500),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Image.asset("assets/location.png",height: 10,width: 10,),
                              const SizedBox(width: 5,),
                              Flexible(child: addText("${widget.viewAllPropertiesModel.location??""} | ", const Color(0xFF797979), 10, FontWeight.w500)),
                              InkWell(
                                onTap: ()async{
                                  if (await launch(
                                      widget.viewAllPropertiesModel.location_link.toString())) {
                                  throw Exception(
                                  'Could not launch');
                                  }
                                },
                                  child: addText("Click to get directions >", const Color(0xFFFF633A), 10, FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          InkWell(child: addText("View Payment Details >", const Color(0xFFFF633A), 14, FontWeight.bold),onTap: (){
                            pushTo(context, PaymentScreen(isPaymentDetail: true,));
                          },),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    if(widget.viewAllPropertiesModel.virtual_tour != null)
                    InkWell(
                      onTap: ()async{
                        if (await launch(
                        widget.viewAllPropertiesModel.virtual_tour.toString())) {
                        throw Exception(
                        'Could not launch');
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFE2E2E2)
                        ),
                        child: Image.asset("assets/virtual.png",height: 10,width: 10,),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                buildTabBar(),
              ],
            ),
          ),
          Visibility(visible: selectedIndex==0,child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: propertyDetails.length,
                  itemBuilder: (context, index) {
                    var property=propertyDetails[index];
                    return  Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFE2E2E2)
                          ),
                          child: Image.asset(property['icon'],height: 10,width: 10,),
                        ),
                        const SizedBox(height: 5,),
                        addText(property['title'], const Color(0xFF404040), 10, FontWeight.normal),
                        const SizedBox(height: 5,),
                        addText(property['value'], const Color(0xFF404040), 12, FontWeight.normal),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10,),
                const Divider(height: 1,),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addText("Amenities", const Color(0xFF303030), 20, FontWeight.w600),
                ),
                const SizedBox(height: 10,),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 100
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: propertyamentiesDetails.length,
                  itemBuilder: (context, index) {
                    var property=propertyamentiesDetails[index];
                    return  Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xFFE2E2E2)
                          ),
                          child: Image.asset(property['icon'],height: 10,width: 10,),
                        ),
                        const SizedBox(height: 5,),
                       addAlignedText(property['title'], const Color(0xFF1b1b1b), 10, FontWeight.normal),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),),
          Visibility(visible: selectedIndex==1,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addText("Property Photos", const Color(0xFF303030), 16, FontWeight.w600),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount:widget.viewAllPropertiesModel.projectData?.propertyPhotos.split(",").length ?? 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final service = widget.viewAllPropertiesModel.projectData?.propertyPhotos.split(",")[index];
                      return Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.7,
                            height: 200,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    service.toString(),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    loadingBuilder: (context, child,
                                        loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
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
                                    }
                                )
                            ),
                          ),
                          const SizedBox(width: 10,)
                        ],
                      );
                    },
                  ),
                ),
                addText("Construction Upadates", const Color(0xFF303030), 16, FontWeight.w600),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount:widget.viewAllPropertiesModel.projectData?.constructionUpadates.split(",").length ?? 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final service = widget.viewAllPropertiesModel.projectData?.constructionUpadates.split(",")[index];
                      return Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.7,
                            height: 200,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: service.toString().contains("youtube")?YouTubeVideoPlayer(
                                  url:service.toString()
                                ):Image.network(
                                    service.toString(),
                                    height: 200,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    loadingBuilder: (context, child,
                                        loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
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
                                    }
                                )
                            ),
                          ),
                          const SizedBox(width: 10,)
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),),




        ],
      ),



    );
  }
  Widget buildTabBar() {
    return BaseTabBar(tabController: tabController,tabList: const [
      Tab(
        text: "Property Details",
      ),
      Tab(
        text: "Photos",
      ),
    ],);
  }

}
