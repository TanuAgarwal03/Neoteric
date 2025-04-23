// Dart imports:
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../booking_tab/booking_list_model.dart';
import '../complaint_section/complaint_list_model.dart';
import '../models/club_services_model.dart';
import '../models/profileimage_model.dart';
import '../models/property_tyype/paymnet_plan_model.dart';
import '../models/property_tyype/view_all_proprerties_model.dart';
import '../models/slider/slidermodel.dart';
import '../project_dropdown/project.dart';
import '../utils/api_manager.dart';
import '../utils/api_model.dart';
import '../utils/apis.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider homeSharedInstanace = HomeProvider._internal();
  factory HomeProvider() => homeSharedInstanace;
  HomeProvider._internal();

  final APIManager _apiManager = APIManager.apiManagerInstanace;
  final APIS _apis = APIS.apisSharedInstanace;

  String? _message;
  String? get message => _message;

  String? total_amount;
  String? pending_amount;

  String? profileImage;
  String? userName;
  String? userMobile;
  changeProfileImage(String profile) {
    profileImage = profile;
    notifyListeners();
  }

  changeUserName(String name) {
    userName = name;
    notifyListeners();
  }

  changeMobileNo(String number) {
    userMobile = number;
    notifyListeners();
  }

  List<SliderModel>? _getSliderImages;
  List<SliderModel>? get sliderImages => _getSliderImages;

  List<ViewAllPropertiesModel>? _getAllProperties;
  List<ViewAllPropertiesModel>? get getProperties => _getAllProperties;

  List<PaymentPlanModel>? _getAllPayment;
  List<PaymentPlanModel>? get getPaymentList => _getAllPayment;

  List<ProjectData>? _getAllProjects;
  List<ProjectData>? get getAllProject => _getAllProjects;

  List<ClubServicesModel>? _getAllAmenties;
  List<ClubServicesModel>? get getAllAmentiesList => _getAllAmenties;

  List<ClubServicesModel>? _getContactNumber;
  List<ClubServicesModel>? get getContactNumber => _getContactNumber;

  List<BookingListModel>? _getBookings;
  List<BookingListModel>? get getAllBooking => _getBookings;

  List<ComplaintListModel>? _getServiceList;
  List<ComplaintListModel>? get getAllServices => _getServiceList;

  ViewAllPropertiesModel? _propertyDetails;
  ViewAllPropertiesModel? get getPropertiesDetails => _propertyDetails;
  bool showAllProperties = false;

  List<int> selectedIndices = [];

  DateTime? rangeStart = DateTime.now();
  DateTime? rangeEnd = DateTime.now();
  changedata() {
    notifyListeners();
  }

  selectAmenties(bool isSelected, int index) {
    if (isSelected) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
    }
    notifyListeners();
  }

  resetAmenties() {
    selectedIndices = [];
    notifyListeners();
  }

  changeAllProperty(bool? changeStatus) {
    showAllProperties = changeStatus ?? false;
    notifyListeners();
  }

  changePropertyDetails(ViewAllPropertiesModel? propertyDetails) {
    _propertyDetails = propertyDetails;
    notifyListeners();
  }

  Future<void> uploadImage(File? image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobileno = pref.getString("primary_contact_no").toString();
    FileInfo? profileImage;
    if (image != null) {
      profileImage =
          FileInfo(image, "image", "image", image.path.split(".").last);
    }
    ApiResponseModel apiResponse = await _apiManager.multipartRequest(
      _apis.uploadImage,
      [profileImage!],
      Method.post,
      {"customer_id": mobileno},
    );
    if (apiResponse.status) {
      await getImage();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobileno = pref.getString("primary_contact_no").toString();
    ApiResponseModel apiResponse = await _apiManager.request(
      _apis.getImage,
      Method.get,
      {"Phone": mobileno},
    );
    if (apiResponse.status) {
      var profileImageModel = ProfileImageModel.fromJson(apiResponse.data);
      if (profileImageModel.profileData != null) {
        if (profileImageModel.profileData!.isNotEmpty) {
          profileImage = profileImageModel.profileData!.first.image.toString();
        }
      }
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getSliderData() async {
    ApiResponseModel apiResponse = await _apiManager.request(
      _apis.homeSliderImages,
      Method.get,
      {},
    );
    if (apiResponse.status) {
      final List<dynamic> dataList = apiResponse.data['WorkCategory'];
      _getSliderImages =
          dataList.map((itemJson) => SliderModel.fromJson(itemJson)).toList();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getPaymentData() async {
    _getAllPayment = null;
    notifyListeners();

    print(getPropertiesDetails!.property_id);
    print(userMobile);
    ApiResponseModel apiResponse = await _apiManager.request(
      "${_apis.getPayment}?property_id=${getPropertiesDetails!.property_id}&customer_id=$userMobile",
      Method.get,
      {},
    );
    print("apiResponse.data");

    print(apiResponse.data);
    if (apiResponse.status) {
      final List<dynamic> dataList = apiResponse.data['PaynentData'];
      total_amount = apiResponse.data['total_amount'].toString();
      pending_amount = apiResponse.data['pending_amount'].toString();
      _getAllPayment = dataList
          .map((itemJson) => PaymentPlanModel.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      final List<dynamic> dataList = apiResponse.data['PaynentData'];
      total_amount = apiResponse.data['total_amount'].toString();
      pending_amount = apiResponse.data['pending_amount'].toString();
      _getAllPayment = dataList
          .map((itemJson) => PaymentPlanModel.fromJson(itemJson))
          .toList();
      print("DBakdb");
      notifyListeners();
      throw HttpException(apiResponse.error!.description);
    }
  }

  Future<void> getAllAmenties() async {
    ApiResponseModel apiResponse = await _apiManager.request(
      _apis.getAllamenties,
      Method.get,
      {},
    );
    if (apiResponse.status) {
      final List<dynamic> dataList = apiResponse.data['requestData'];
      _getAllAmenties = dataList
          .map((data) => ClubServicesModel.fromJson(data))
          .where((project) => project.type == 'Club_Services')
          .toList();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getOwenerContactNumber() async {
    ApiResponseModel apiResponse = await _apiManager.request(
      _apis.getAllamenties,
      Method.get,
      {},
    );
    if (apiResponse.status) {
      final List<dynamic> dataList = apiResponse.data['requestData'];
      _getContactNumber = dataList
          .map((data) => ClubServicesModel.fromJson(data))
          .where((project) => project.type == 'Call_Contact_Number')
          .toList();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getProjectData() async {
    ApiResponseModel apiResponse = await _apiManager.request(
      _apis.projectList,
      Method.get,
      {},
    );
    if (apiResponse.status) {
      List<dynamic> projectsData = apiResponse.data['ProjectsData'];
      _getAllProjects =
          projectsData.map((data) => ProjectData.fromJson(data)).toList();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> fetchAllServicesList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobileno = pref.getString("primary_contact_no").toString();
    ApiResponseModel apiResponse = await _apiManager.request(
      "${_apis.serviceList}?Phone=$mobileno",
      Method.get,
      {},
    );
    if (apiResponse.status) {
      List<dynamic> projectsData = apiResponse.data['ComplaintData'];
      _getServiceList = projectsData
          .map((data) => ComplaintListModel.fromJson(data))
          .toList();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getAllbookingas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobileno = pref.getString("primary_contact_no").toString();
    ApiResponseModel apiResponse = await _apiManager.request(
      "${_apis.bookingList}?Phone=$mobileno",
      Method.get,
      {},
    );
    if (apiResponse.status) {
      List<dynamic> projectsData = apiResponse.data['ComplaintData'];
      _getBookings =
          projectsData.map((data) => BookingListModel.fromJson(data)).toList();
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }

  Future<void> getAllProperty() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobileno = pref.getString("primary_contact_no").toString();
    ApiResponseModel apiResponse = await _apiManager.request(
      "${_apis.propertyList}?Phone=$mobileno",
      Method.get,
      {},
    );
    print(' property Detail : $apiResponse');
    if (apiResponse.status) {
      List<dynamic> propertyData = apiResponse.data['userData'];
      _getAllProperties = propertyData
          .map((data) => ViewAllPropertiesModel.fromJson(data))
          .toList();
      print(propertyData);
    } else {
      throw HttpException(apiResponse.error!.description);
    }
    notifyListeners();
  }
}
