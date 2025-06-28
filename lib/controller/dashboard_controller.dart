import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sync_day/pages/afterLogin/bottomMenuPages/profile_screen.dart';
import 'package:sync_day/pages/afterLogin/bottomMenuPages/report_screen.dart';
import 'package:sync_day/pages/afterLogin/bottomMenuPages/statistics_screen.dart';

import '../pages/afterLogin/bottomMenuPages/home_screen.dart';

class DashboardController extends GetxController{

  RxInt index = 0.obs;

  final List<Widget> widget = [
    HomeScreen(),
    ReportScreen(),
    StatisticsScreen(),
    ProfileScreen()
  ];

  final List<Map<String,dynamic>> menu = [
    {
      "icon" : "assets/icons/home.png",
      "label" : "Home"
    },
    {
      "icon" : "assets/icons/report.png",
      "label" : "Report"
    },
    {
      "icon" : "assets/icons/statistics.png",
      "label" : "Statistics"
    },
    {
      "icon" : "assets/icons/profile.png",
      "label" : "Profile"
    }
  ];

  void openPage(int value){
    index.value = value;
  }

  @override
  void onInit() {
    super.onInit();
  }

}