import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sync_day/utils/app_colors.dart';
import 'package:sync_day/utils/storage_service.dart';

class StatisticController extends GetxController{
  final StorageService _ss = Get.find<StorageService>();

  var typeColor = <String, Color>{
    'Education': AppColors.education,
    'Sports': AppColors.sports,
    'Personal': AppColors.personal,
    'Work': AppColors.work,
    'Other' : AppColors.other
  };

  final Map<String, Duration> dailyTotals = {
    'Mon': Duration.zero,
    'Tue': Duration.zero,
    'Wed': Duration.zero,
    'Thu': Duration.zero,
    'Fri': Duration.zero,
    'Sat': Duration.zero,
    'Sun': Duration.zero,
  };

  RxList<ActivityData> activityData = <ActivityData>[].obs;
  RxList<ChartData> chartData = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getWeekData();
  }


  void getWeekData() async{
    activityData.clear();
    chartData.clear();
    final tasks = await getTasks();
    generateWeeklyActivityData(tasks);
    generateWeeklyLineData(tasks);
  }

  void getMonthData() async{
    activityData.clear();
    chartData.clear();
    final tasks = await getTasks();
    generateMonthlyActivityData(tasks);
    generateMonthlyLineData(tasks);
  }

  void getYearData() async{
    activityData.clear();
    chartData.clear();
    final tasks = await getTasks();
    generateYearlyActivityData(tasks);
    generateYearlyLineData(tasks);
  }

  Future<List<Map<String,dynamic>>> getTasks() async{
    var tasks = await _ss.getValue("tasks") ?? [];
    final List<Map<String, dynamic>> data =
    (tasks as List).map((e) => e as Map<String, dynamic>).toList();
    return data;
  }

  void generateWeeklyActivityData(List<Map<String, dynamic>> raw) {
    final now = DateTime.now();
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    final thisSunday = thisMonday.add(const Duration(days: 6));
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    final Map<String, Duration> bucket = {};

    for (final item in raw) {
      final activityDate = dateFormatter.parse(item['date']);

      if (activityDate.isBefore(thisMonday) || activityDate.isAfter(thisSunday)) continue;

      final from = timeFormatter.parse(item['fromTime']);
      final to = timeFormatter.parse(item['toTime']);

      final start = DateTime(activityDate.year, activityDate.month, activityDate.day, from.hour, from.minute);
      final end = DateTime(activityDate.year, activityDate.month, activityDate.day, to.hour, to.minute);

      final diff = end.difference(start);
      final type = item['type'] as String;

      bucket[type] = (bucket[type] ?? Duration.zero) + diff;
    }

    final totalMinutes = bucket.values.fold<int>(0, (sum, dur) => sum + dur.inMinutes);
    final pieData = bucket.entries.map((entry) {
      final minutes = entry.value.inMinutes;
      final percent = minutes * 100 / totalMinutes;
      return ActivityData(
        entry.key,
        double.parse(percent.toStringAsFixed(1)),
        typeColor[entry.key] ?? AppColors.lightGrey,
      );
    }).toList();

    activityData.assignAll(pieData);
  }

  void generateWeeklyLineData(List<Map<String, dynamic>> raw) {
    final now = DateTime.now();
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    final thisSunday = thisMonday.add(const Duration(days: 6));

    final dateFormat = DateFormat('dd-MM-yyyy');
    final timeFormat = DateFormat('hh:mm a');


    for (final item in raw) {
      final date = dateFormat.parse(item['date']);

      if (date.isBefore(thisMonday) || date.isAfter(thisSunday)) continue;

      final from = timeFormat.parse(item['fromTime']);
      final to = timeFormat.parse(item['toTime']);

      final start = DateTime(date.year, date.month, date.day, from.hour, from.minute);
      final end = DateTime(date.year, date.month, date.day, to.hour, to.minute);

      final duration = end.difference(start);
      final dayName = DateFormat('EEE').format(date);

      if (dailyTotals.containsKey(dayName)) {
        dailyTotals[dayName] = dailyTotals[dayName]! + duration;
      }
    }

    final lineData = dailyTotals.entries.map((entry) {
      final hours = entry.value.inMinutes / 60;
      return ChartData(entry.key, double.parse(hours.toStringAsFixed(1)));
    }).toList();

    chartData.assignAll(lineData);
  }

  void generateMonthlyActivityData(List<Map<String, dynamic>> raw) {
    final now        = DateTime.now();
    final firstDay   = DateTime(now.year, now.month, 1);
    final lastDay    = DateTime(now.year, now.month + 1, 0);

    final dateFmt  = DateFormat('dd-MM-yyyy');
    final timeFmt  = DateFormat('hh:mm a');
    final bucket   = <String, Duration>{};

    for (final item in raw) {
      final day = dateFmt.parse(item['date']);
      if (day.isBefore(firstDay) || day.isAfter(lastDay)) continue;

      final start = timeFmt.parse(item['fromTime']);
      final end   = timeFmt.parse(item['toTime']);
      final diff  = DateTime(day.year, day.month, day.day, end.hour, end.minute)
          .difference(DateTime(day.year, day.month, day.day, start.hour, start.minute));

      final type = item['type'] as String;
      bucket[type] = (bucket[type] ?? Duration.zero) + diff;
    }

    final totalMin = bucket.values.fold<int>(0, (s, d) => s + d.inMinutes);
    final pieData  = bucket.entries.map((e) {
      final pct = e.value.inMinutes * 100 / (totalMin == 0 ? 1 : totalMin);
      return ActivityData(e.key, double.parse(pct.toStringAsFixed(1)),
          typeColor[e.key] ?? AppColors.lightGrey);
    }).toList();

    activityData.assignAll(pieData);
  }

  void generateMonthlyLineData(List<Map<String, dynamic>> raw) {
    final now           = DateTime.now();
    final firstDay      = DateTime(now.year, now.month, 1);
    final lastDay       = DateTime(now.year, now.month + 1, 0);
    final dateFmt       = DateFormat('dd-MM-yyyy');
    final timeFmt       = DateFormat('hh:mm a');

    // reset dailyTotals for fresh month
    final days          = _daysInMonth(now);
    final dailyTotals   = { for (var d = 1; d <= days; d++) d : Duration.zero };

    for (final item in raw) {
      final day = dateFmt.parse(item['date']);
      if (day.isBefore(firstDay) || day.isAfter(lastDay)) continue;

      final start = timeFmt.parse(item['fromTime']);
      final end   = timeFmt.parse(item['toTime']);
      final diff  = DateTime(day.year, day.month, day.day, end.hour, end.minute)
          .difference(DateTime(day.year, day.month, day.day, start.hour, start.minute));

      dailyTotals[day.day] = dailyTotals[day.day]! + diff;
    }

    final lineData = [
      for (var d = 1; d <= days; d++)
        ChartData(d.toString(), double.parse((dailyTotals[d]!.inMinutes / 60)
            .toStringAsFixed(1)))
    ];

    chartData.assignAll(lineData);
  }

  void generateYearlyActivityData(List<Map<String, dynamic>> raw) {
    final now      = DateTime.now();
    final jan1     = DateTime(now.year, 1, 1);
    final dec31    = DateTime(now.year, 12, 31);
    final dateFmt  = DateFormat('dd-MM-yyyy');
    final timeFmt  = DateFormat('hh:mm a');
    final bucket   = <String, Duration>{};

    for (final item in raw) {
      final day = dateFmt.parse(item['date']);
      if (day.isBefore(jan1) || day.isAfter(dec31)) continue;

      final start = timeFmt.parse(item['fromTime']);
      final end   = timeFmt.parse(item['toTime']);
      final diff  = DateTime(day.year, day.month, day.day, end.hour, end.minute)
          .difference(DateTime(day.year, day.month, day.day, start.hour, start.minute));

      final type = item['type'] as String;
      bucket[type] = (bucket[type] ?? Duration.zero) + diff;
    }

    final totalMin = bucket.values.fold<int>(0, (s, d) => s + d.inMinutes);
    final pieData  = bucket.entries.map((e) {
      final pct = e.value.inMinutes * 100 / (totalMin == 0 ? 1 : totalMin);
      return ActivityData(e.key, double.parse(pct.toStringAsFixed(1)),
          typeColor[e.key] ?? AppColors.lightGrey);
    }).toList();

    activityData.assignAll(pieData);
  }

  void generateYearlyLineData(List<Map<String, dynamic>> raw) {
    final now        = DateTime.now();
    final jan1       = DateTime(now.year, 1, 1);
    final dec31      = DateTime(now.year, 12, 31);
    final dateFmt    = DateFormat('dd-MM-yyyy');
    final timeFmt    = DateFormat('hh:mm a');

    final monthlyTotals = { for (var m = 1; m <= 12; m++) m : Duration.zero };

    for (final item in raw) {
      final day = dateFmt.parse(item['date']);
      if (day.isBefore(jan1) || day.isAfter(dec31)) continue;

      final start = timeFmt.parse(item['fromTime']);
      final end   = timeFmt.parse(item['toTime']);
      final diff  = DateTime(day.year, day.month, day.day, end.hour, end.minute)
          .difference(DateTime(day.year, day.month, day.day, start.hour, start.minute));

      monthlyTotals[day.month] = monthlyTotals[day.month]! + diff;
    }

    const monthNames = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final lineData = List.generate(12, (i) {
      final hrs = monthlyTotals[i + 1]!.inMinutes / 60;
      return ChartData(monthNames[i], double.parse(hrs.toStringAsFixed(1)));
    });

    chartData.assignAll(lineData);
  }



  int _daysInMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0).day;



}

class ChartData {
  final String day;
  final double hours;

  ChartData(this.day, this.hours);
}

class ActivityData {
  final String category;
  final double percentage;
  final Color color;

  ActivityData(this.category, this.percentage, this.color);
}