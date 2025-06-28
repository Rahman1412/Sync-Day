import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sync_day/controller/home_controller.dart';
import 'package:sync_day/models/task_model.dart';
import 'package:sync_day/pages/component/add_new_task.dart';
import 'package:sync_day/utils/storage_service.dart';

import 'common_controller.dart';

class TaskController extends GetxController {
  final CommonController _cc = Get.find<CommonController>();
  final StorageService _ss = Get.find<StorageService>();
  final GlobalKey<FormState> taskForm = GlobalKey<FormState>();
  late TextEditingController date, fromText, toText, title, description;
  final Rx<TimeOfDay?> fromTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> toTime = Rx<TimeOfDay?>(null);
  final RxList<TextEditingController> task = <TextEditingController>[].obs;
  Rx<String?> taskType = Rx<String?>(null);
  final HomeController hc = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    date = TextEditingController();
    fromText = TextEditingController();
    toText = TextEditingController();
    title = TextEditingController();
    description = TextEditingController();
  }

  void setCurrentDate(){
    date.text = _cc.getCurrentDate();
  }

  Future<void> selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFromTime
          ? (fromTime.value ?? TimeOfDay.now())
          : (toTime.value ?? TimeOfDay.now()),
      helpText: isFromTime ? "Select Start Time" : "Select End Time",
    );

    if (picked != null) {
      if (isBeforeTimeOfDay(picked, TimeOfDay.now())) {
        Get.snackbar("Invalid Time", "Time cannot be earlier than current time.");
        return;
      }
      if (isFromTime) {
        fromTime.value = picked;
        fromText.text = picked.format(context);

        if (toTime.value != null &&
            !isToAfterFrom(fromTime.value!, toTime.value!)) {
          toTime.value = null;
          toText.text = '';
        }
      } else {
        final gap = gapInMinutes(fromTime.value!, picked);
        if (gap < 20) {
          Get.snackbar(
            'Error!',
            'End time must be at least 20 minutes after start time.',
          );
          return;
        }
        if (fromTime.value != null && !isToAfterFrom(fromTime.value!, picked)) {
          Get.snackbar("Error!", "End time must be after start time.");
          return;
        }
        toTime.value = picked;
        toText.text = picked.format(context);
      }
    }
  }

  int gapInMinutes(TimeOfDay start, TimeOfDay end) =>
      (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);

  bool isBeforeTimeOfDay(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }


  bool isToAfterFrom(TimeOfDay from, TimeOfDay to) {
    final fromMinutes = from.hour * 60 + from.minute;
    final toMinutes = to.hour * 60 + to.minute;
    return toMinutes > fromMinutes;
  }


  void addTask() {
    task.add(TextEditingController());
  }

  void removeTask(TextEditingController item) {
    task.remove(item);
  }

  String? validateTask(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? validateFrom(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? validateTo(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? validateTitle(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return "Title is required";
    }
    return null;
  }

  String? validateTaskType(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return "Please select an activity type";
    }
    return null;
  }

  void addNewTask(
      BuildContext context
      ) async {
    if (!taskForm.currentState!.validate()) return;
    try {
      var data = TaskModel(
        date: date.text,
        fromTime: fromText.text,
        toTime: toText.text,
        title: title.text,
        type: taskType.value ?? "",
        tasks: task.map((element) => element.text).toList(),
        description: description.text,
      );

      var stored = await _ss.getValue("tasks") ?? [];
      stored.add(data.toJson());
      await _ss.setValue("tasks", stored);
      hc.loadTasks();
      AddNewTask.hide(context);
    } catch (e) {
    }
  }


  void updateTaskType(String? value) {
    taskType.value = value;
  }

  void clear(){
    date.clear();
    fromText.clear();
    toText.clear();
    title.clear();
    description.clear();
    fromTime.value = null;
    toTime.value = null;
    taskType.value = null;
    task.clear();
  }
}
