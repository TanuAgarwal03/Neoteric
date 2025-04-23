// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' as media_type;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_model.dart';

// Project imports:


enum Method { post, get, delete, put,patch }

class APIManager {
  static final APIManager apiManagerInstanace = APIManager._internal();
  factory APIManager() => apiManagerInstanace;
  APIManager._internal();



  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<ApiResponseModel> request(
      String webUrl,
      Method method,
      Map<String, dynamic> param,
      ) async {
    log(webUrl);
    final bool connectionStatus = await _checkConnection();
    late ApiResponseModel apiResponse;
    late ErrorModel error;
    if (!connectionStatus) {
      error = ErrorModel(
        "No Internet",
        "No internet connection.",
        503,
      );
      return apiResponse = ApiResponseModel(null, error, false);
    }


    Dio dio = Dio();
    log("param");
    log(param.toString());
    late Response response;
    Map<String, String> headers = {};
    // final String? token = await localStorage.getValue("token");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (token != null) headers['Authorization'] = "Bearer $token";
    headers["Content-Type"] = "application/json";
    //headers["Accept-Language"] = prefs.getString("lang")??"en";
    String? encodedData= json.encode(param);
     log(encodedData);
    log(headers.toString());
    log(method.toString());
    try {
      if (method == Method.get) {
        response = await dio.get(webUrl, options: Options(headers: headers,),queryParameters: param);
      } else if (method == Method.post) {
       // safePrint("response.toString()");
        response = await dio.post(webUrl, options: Options(headers: headers), data: encodedData);
       // safePrint(response.toString());
      } else if (method == Method.put) {
        response = await dio.put(webUrl, options: Options(headers: headers), data: encodedData);
      } else if (method == Method.delete) {
        response = await dio.delete(webUrl, options: Options(headers: headers));
      }else if (method == Method.patch) {
        response = await dio.patch(webUrl, options: Options(headers: headers),data: encodedData);
      }
      log(response.data.toString());
      log(response.statusCode.toString());
      log(response.statusMessage.toString());
      // if (response.data != null) {
      //   log("ashdgjhkasghhjgjh-===");
      //   final responseObject = json.decode(response.data);
      //   final prettyString =
      //   const JsonEncoder.withIndent('  ').convert(responseObject);
      //   log("ashdgjhkasghhjgjh" + prettyString);
      // }
      //safePrint("NAVagvdhg"'message');
      final responseData = response.data;
      if (responseData['message'] == "jwt expired" ||
          responseData['message'] == "wt malformed") {
        error = ErrorModel(
          "Unauthorized",
          "Token Expired, Please login again.",
          response.statusCode??500,
        );
        apiResponse = ApiResponseModel(null, error, false);
      }
      if (response.statusCode! >= 200 && response.statusCode! < 401) {
        if (response.data.isNotEmpty) {
         // safePrint("ahBDJAdv");
          if (responseData['status'] == true) {
            apiResponse = ApiResponseModel(responseData, null, true);
          } else {
            //safePrint("ahBDJAdv====");
            error = ErrorModel(
              "Error",
              "${responseData['message']}",
              response.statusCode??500,
            );
            apiResponse = ApiResponseModel(null, error, false);
          }
        }
      } else if (response.statusCode == 401) {
        ErrorModel(
          "Unauthorized",
          "Token Expired, Please login again.",
            response.statusCode??500,
        );
        apiResponse = ApiResponseModel(null, error, false);
      } else if (response.statusCode == 500) {
        apiResponse = ApiResponseModel(
            null,
            ErrorModel(
              '',
              'Internal server error',
              response.statusCode??500,
            ),
            false);
      } else {
        //safePrint("ahsvdjhas");
        if (response.data.isNotEmpty) {
          error = ErrorModel(
            "",
            responseData['message'],
            response.statusCode??500
          );
          apiResponse = ApiResponseModel(responseData, error, false);
        } else {
          error = ErrorModel(
            "Something went wrong!",
            "Looks like there was an error in reaching our servers. Press Refresh to try again or come back after some time.",
            504,
          );
          apiResponse = ApiResponseModel(responseData, error, false);
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle server error response
        log('Server error: ${e.response!.statusCode}');
        log('Server error: ${e.response!.statusMessage}');
        log('Server error: ${e.response!.data!}');
        error = ErrorModel(
          "Something went wrong!",
          e.response!.data['message'],
          e.response!.statusCode!,
        );
        log('Server error: ${e.response!.data!}');
        apiResponse = ApiResponseModel(e.response?.data, error, false);
      } else {
        // log('Network error: ${e.message}');
        // log('Server error: ${e.response!.statusCode}');
        // log('Server error: ${e.response!.statusMessage}');
        // // Handle network error
        // log('Network error: ${e.message}');
        error = ErrorModel(
          "Something went wrong!",
          "Something went wrong. Please try again.",
          e.response?.statusCode??400,
        );
        apiResponse = ApiResponseModel(null, error, false);
      }
    }
    catch (e) {
      //safePrint("asjdajshdfsj");
      log("$e");
      error = ErrorModel(
        "Something went wrong!",
        "Something went wrong. Please try again.",
        504,
      );
      apiResponse = ApiResponseModel(null, error, false);
    }
    return apiResponse;
  }

  Future<ApiResponseModel> multipartRequest(
      String webUrl,
      List<FileInfo> files,
      Method method,
      Map<String, dynamic> param,
      ) async {
    var status = await _checkConnection();
    late ErrorModel error0;
    late ApiResponseModel apiResponse0;
    if (status != true) {
      var error =
      ErrorModel("No Internet", "Check Your Network Connection", 500);
      return ApiResponseModel("", error, false);
    }
    //safePrint(webUrl);
    Dio dio = Dio();
    late Response response;
    Map<String, String> headers = {};
    FormData formData = FormData.fromMap({});
    for (var item in files) {
      var multipartFile = MultipartFile.fromBytes(
        File(item.file.path).readAsBytesSync(),
        filename: "${item.name}.${item.ext}",
        contentType: media_type.MediaType(
            "${lookupMimeType(item.file.path, headerBytes: item.file.readAsBytesSync())}",
            "${lookupMimeType(item.file.path)}"),
      );
      formData.files.add(MapEntry(item.key, multipartFile));
    }
    // var token = await appAuth.getValue("token");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (token != null) headers['Authorization'] = "Bearer $token";
    headers["Content-Type"] = "application/json";
   // headers["Accept-Language"] = prefs.getString("lang")??"en";
    formData.fields.addAll(param.entries.map((e) => MapEntry(e.key, e.value.toString())));

    try {

      if(method==Method.post)
        {
          response = await dio.post(webUrl, options: Options(headers: headers), data: formData);
        }
      else if(method==Method.patch)
        {
          response = await dio.patch(webUrl, options: Options(headers: headers), data: formData);
        }
      else if(method==Method.put)
      {
        response = await dio.put(webUrl, options: Options(headers: headers), data: formData);
      }


      // safePrint(response.toString());
      // safePrint(response.data);
      // safePrint(response.statusCode);
      // safePrint(response.statusMessage);
      // safePrint(response.data);
        if (response.statusCode! < 300 && response.statusCode! >= 200) {
          var data = response.data;
          log(data.toString());
          if (data['status'] == true) {
            return apiResponse0=ApiResponseModel(data, null, true);
          } else {
            String error = data["message"];
            ErrorModel apiResponse = ErrorModel("", error, data['statusCode']);
            return apiResponse0=ApiResponseModel(null, apiResponse, false);
          }
        } else if (response.statusCode == 500) {
          ErrorModel apiResponse = ErrorModel(
            "Something went wrong!",
            "Looks like there was an error in reaching our servers. Press Refresh to try again or come back after some time.",
            504,
          );
          return apiResponse0=ApiResponseModel(null, apiResponse, false);
        } else {
          var errorData = json.decode(response.data);
          String error = errorData["message"];
          ErrorModel apiResponse = ErrorModel("", error, errorData['statusCode']);
          return apiResponse0=ApiResponseModel(null, apiResponse, false);
        }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle server error response
        error0 = ErrorModel(
          "Something went wrong!",
          e.response?.data['message']??"Something went wrong!",
          e.response!.statusCode!,
        );
        return apiResponse0 = ApiResponseModel(null, error0, false);
      } else {
        error0 = ErrorModel(
          "Something went wrong!",
         "Something went wrong. Please try again.",
          e.response!.statusCode!,
        );
        return apiResponse0 = ApiResponseModel(null, error0, false);
      }
    }
    catch (e) {
     // safePrint("asjdajshdfsj");
      log("$e");
      error0 = ErrorModel(
        "Something went wrong!",
        "Something went wrong. Please try again.",
        504,
      );
      return apiResponse0 = ApiResponseModel(null, error0, false);
    }

  }
}
