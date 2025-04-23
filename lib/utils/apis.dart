class APIS {
  static final APIS apisSharedInstanace = APIS._internal();
  factory APIS() => apisSharedInstanace;

  APIS._internal();

  static const String apiUrl = "https://lytechxagency.website/Laravel_GoogleSheet/";

  String homeSliderImages = "${apiUrl}Slider_images";
  String projectList = "${apiUrl}projects_list";
  String propertyList = "${apiUrl}PropertyDetails";
  String getAllamenties = "${apiUrl}All_Category";
  String bookingList = "${apiUrl}Booking_history";
  String serviceList = "${apiUrl}Service_Request_List";
  String uploadImage = "${apiUrl}ProfileUpdate";
  String getImage = "${apiUrl}GetProfileImage";
  String getPayment = "${apiUrl}Payment_List";


}
