
import 'package:flutter/cupertino.dart';

class Constants {
  static const String BASE_URL = "https://lytechxagency.website/";
  static const String LOGIN = "Laravel_GoogleSheet/customer_detail?Phone=";



}

Text addText(String text,Color color,double fontSize,FontWeight fontWeight){
  return Text(text,style: TextStyle(color: color,fontSize: fontSize,fontWeight: fontWeight),);
}
Text addAlignedText(String text,Color color,double fontSize,FontWeight fontWeight){
  return Text(text,style: TextStyle(color: color,fontSize: fontSize,fontWeight: fontWeight),textAlign: TextAlign.center,);
}