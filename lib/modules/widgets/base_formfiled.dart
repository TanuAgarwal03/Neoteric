import 'package:flutter/material.dart';

class BaseTextFormFiled extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  String? titleText;
  bool isPhone;
  TextInputType keyboardType;
  final Widget preffix;
  BaseTextFormFiled({super.key,required this.controller,required this.hintText,
    this.titleText="",
    this.preffix=const  SizedBox(height: 25,width: 15,),
    this.isPhone=false,
    this.keyboardType=TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(titleText.toString() != "")...[
           Text(titleText.toString(),style: const TextStyle(
            fontSize: 16,
          ),),
          const SizedBox(height: 10,),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(

            border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Color(0xffA1A1A1)),
                borderRadius: BorderRadius.circular(10.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Color(0xffA1A1A1)),
                borderRadius: BorderRadius.circular(10.0)),
            isDense: true,
            filled: true,

            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: hintText,
            fillColor: Colors.white70,
            prefixIconConstraints: const BoxConstraints(
              minHeight: 50,
              maxWidth: 40,
            ),
            constraints: const BoxConstraints(
              maxHeight: 50,
            ),
            prefixIcon: preffix,
          ),
        )
      ],
    );
  }
}
