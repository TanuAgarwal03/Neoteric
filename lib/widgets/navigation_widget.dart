// Flutter imports:
import 'package:flutter/material.dart';

Future pushTo(BuildContext context, Widget name) async => await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => name),
);

void pushReplace(BuildContext context, Widget name) async{
  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => name,),
  );
}

Future<void> pushReplaceName(BuildContext context, String name) async {
  await Navigator.pushReplacementNamed(context, name);
}

void replaceRoute(BuildContext context, Widget name)async {
  await Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => name),
        (Route<dynamic> route) => false,
  );
}

void replaceNamedRoute(BuildContext context, Widget name) =>
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => name), (route) => false);
