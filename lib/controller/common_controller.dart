import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CommonController extends GetxController{

  List<String> activityType = [
    "Education",
    "Work",
    "Sport",
    "Personal",
    "Other"
  ];
  final RxList<DateTime> currentWeekDates = <DateTime>[].obs;



  void getCurrentWeekDates(DateTime date) {
    if (currentWeekDates.any((d) =>
    d.year == date.year && d.month == date.month && d.day == date.day)) {
    }

    int weekday = date.weekday;
    DateTime monday = date.subtract(Duration(days: weekday - 1));
    List<DateTime> week = List.generate(7, (i) => monday.add(Duration(days: i)));

    currentWeekDates.assignAll(week);
  }
  String getDayName(DateTime date){
    String day = DateFormat('EEE').format(date);
    return day;
  }

  String getDay(DateTime date){
    return date.day.toString();
  }

  String getYear(DateTime date){
    return date.year.toString();
  }

  String getMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  bool isToday(DateTime date){
    final today = DateTime.now();
    if(date.year == today.year && date.month == today.month && date.day == today.day) return true;
    return false;
  }

  String getCurrentDate(){
    DateTime _date = DateTime.now();
    String date = DateFormat("dd-MM-yyyy").format(_date);
    return date;
  }



}

