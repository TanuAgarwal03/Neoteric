import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  Function() onPress;
  String title;
  double? fontSize;
  double? borderradius;
  FontWeight? fontWeight;
  Color? btnColor;
  BaseButton({super.key,required this.onPress,required this.title,this.fontSize=16,this.fontWeight=FontWeight.w500,
  this.btnColor=Colors.white,this.borderradius=30});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration:  BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xffFF3D00), Color(0xffFF2E00)]),
          borderRadius: BorderRadius.all(Radius.circular(borderradius??30)),
          //  color: Colors.red
        ),
        child: Center(child: Padding(
          padding: const EdgeInsets.only(top: 10,bottom: 10),
          child: Text(title,style: TextStyle(
              color: btnColor,
              fontWeight: fontWeight,
              fontSize: fontSize
          ),),
        )),
      ),
    );
  }
}
