import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../controller/common_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../utils/app_colors.dart';
import '../../component/title_wrapper.dart';
import '../../component/width_spacer.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  final DateTime initialDate = DateTime.now();
  final CommonController _cc = Get.find<CommonController>();
  final HomeController _hc =
      Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _hc.setDate(null);
      _cc.getCurrentWeekDates(_hc.currentDate.value);
    });
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
                    getToday(_hc.currentDate.value)
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Obx((){
                return  Row(
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
                                Text(_cc.getDayName(item),style: TextStyle(
                                    color: isCurrentDate ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface
                                )),
                                Text(_cc.getDay(item),style: TextStyle(
                                    color: isCurrentDate ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface
                                )),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }).toList(),
                );
              })
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
                  viewNavigationMode: ViewNavigationMode.snap,
                  maxDate: initialDate,
                  dataSource: _hc.calendarSource.value,
                  initialDisplayDate: _hc.currentDate.value,
                  onViewChanged: (ViewChangedDetails details){
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      _cc.getCurrentWeekDates(details.visibleDates[0]);
                      _hc.setDate(details.visibleDates[0]);
                    });
                  },
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
                                color: Theme.of(context).colorScheme.onSurface
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeInterval: Duration(minutes: 30),
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

  Widget getToday(DateTime date){
    if(!_cc.isToday(date)){
      return SizedBox.shrink();
    }
    return Chip(
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
    );
  }
}
