import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../utils/storage_service.dart';

class HomeController extends GetxController {
  final StorageService _ss = StorageService();
  Rx<DateTime> currentDate = DateTime.now().obs;
  Rx<AppointmentDataSource> calendarSource = AppointmentDataSource([]).obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void setDate(DateTime? date) {
    currentDate.value = date ?? DateTime.now();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await _ss.getValue("tasks") ?? [];

    final List<Map<String, dynamic>> data =
    (tasks as List).map((e) => e as Map<String, dynamic>).toList();

    final result = await getAppointment(data);

    calendarSource.value = AppointmentDataSource(result);
  }

  Future<List<Appointment>> getAppointment(List<Map<String, dynamic>> data) async {
    final List<Appointment> list = [];
    final dateFormat = DateFormat("dd-MM-yyyy hh:mm a");

    for (var item in data) {
      final String date = item['date'];
      final String fromTime = item['fromTime'];
      final String toTime = item['toTime'];
      final String title = item['title'];
      final String type = item['type'];
      final String description = item['description'];
      final List<String> tasks = List<String>.from(item['tasks']);

      final DateTime startTime = dateFormat.parse("$date $fromTime");
      final DateTime endTime = dateFormat.parse("$date $toTime");

      if(startTime.year == currentDate.value.year && startTime.month == currentDate.value.month && startTime.day == currentDate.value.day){
        final extraData = {
          'description': description,
          'type': type,
          'tasks': tasks,
        };


        list.add(
          Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: title,
            notes: jsonEncode(extraData),
            color: getColorFromType(type),
          ),
        );
      }
    }
    return list;
  }

  Color getColorFromType(String type) {
    switch (type.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'education':
        return Colors.orange;
      case 'sport':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool isCurrentDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}


class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}