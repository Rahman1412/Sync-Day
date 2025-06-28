import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sync_day/controller/common_controller.dart';
import 'package:sync_day/controller/home_controller.dart';
import 'package:sync_day/pages/component/width_spacer.dart';
import 'package:sync_day/utils/app_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../component/title_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final CommonController _cc = Get.find<CommonController>();
  final HomeController _hc =
      Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : Get.put(HomeController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hc.setDate(null);
      _cc.getCurrentWeekDates(_hc.currentDate.value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Obx(
                () => Row(
                  children: [
                    TitleWrapper(title: _cc.getDay(_hc.currentDate.value)),
                    WidthSpacer(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_cc.getDayName(_hc.currentDate.value)),
                        Text(
                          "${_cc.getMonthName(_hc.currentDate.value)} ${_cc.getYear(_hc.currentDate.value)}",
                        ),
                      ],
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        "Today",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      backgroundColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      _cc.currentWeekDates.map((item) {
                        return Expanded(
                          child: Obx(() {
                            final isCurrentDate = _hc.isCurrentDate(
                              item,
                              _hc.currentDate.value,
                            );
                            return Card(
                              color:
                                  isCurrentDate
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _cc.getDayName(item),
                                      style: TextStyle(
                                        color:
                                            isCurrentDate
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.surface
                                                : Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      _cc.getDay(item),
                                      style: TextStyle(
                                        color:
                                            isCurrentDate
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.surface
                                                : Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }).toList(),
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                return SfCalendar(
                  view: CalendarView.day,
                  todayHighlightColor: Theme.of(context).highlightColor,
                  headerHeight: 0,
                  viewHeaderHeight: 0,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  showTodayButton: true,
                  viewNavigationMode: ViewNavigationMode.none,
                  dataSource: _hc.calendarSource.value,
                  initialDisplayDate: DateTime.now(),
                  appointmentBuilder: (
                    BuildContext context,
                    CalendarAppointmentDetails details,
                  ) {
                    final Appointment appointment = details.appointments.first;

                    return Card(
                      elevation: 4,
                      color: AppColors.card.withAlpha(128),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.subject,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${appointment.startTime.hour}:${appointment.startTime.minute.toString().padLeft(2, '0')} - ${appointment.endTime.hour}:${appointment.endTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeInterval: Duration(minutes: 20),
                    timeIntervalHeight: 100,
                    timeFormat: 'hh:mm a',
                    timeRulerSize: 80,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
