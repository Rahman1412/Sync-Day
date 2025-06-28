import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDialog {
  static void showPopup(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text("Calendar Dialog Content Here"),
        ),
      );
    });
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}