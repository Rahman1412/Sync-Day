import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sync_day/controller/statistic_controller.dart';
import 'package:sync_day/pages/component/height_spacer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatisticsScreen();
}

class _StatisticsScreen extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TooltipBehavior _tooltipBehavior;
  final StatisticController _sc = Get.isRegistered<StatisticController>() ? Get.find<StatisticController>() : Get.put(StatisticController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.y hrs', activationMode: ActivationMode.singleTap);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final selectedIndex = _tabController.index;
      if(selectedIndex == 0){
        WidgetsBinding.instance.addPostFrameCallback((_){
          _sc.getWeekData();
        });
      }else if(selectedIndex == 1){
        WidgetsBinding.instance.addPostFrameCallback((_){
          _sc.getMonthData();
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_){
          _sc.getYearData();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).highlightColor.withAlpha(128),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: "Week"),
                    Tab(text: "Month"),
                    Tab(text: "Year"),
                  ],
                ),
              ),
              HeightSpacer(height: 15),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Obx(() => SfCircularChart(
                  series: <CircularSeries<ActivityData, String>>[
                    DoughnutSeries<ActivityData, String>(
                      dataSource: _sc.activityData.value,
                      xValueMapper: (ActivityData data, _) => data.category,
                      yValueMapper: (ActivityData data, _) => data.percentage,
                      pointColorMapper: (ActivityData data, _) => data.color,
                      dataLabelMapper: (ActivityData data, _) => "${data.category}\n${data.percentage}%",
                      dataLabelSettings:DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      radius: '90%',
                      innerRadius: '65%',
                    ),
                  ],
                )),
              ),
              HeightSpacer(height: 15),
              // Wrap(
              //   spacing: 10,
              //   children:
              //       _sc.activityData.map(
              //             (e) => Chip(
              //               label: Text(e.category),
              //               backgroundColor:
              //                   e.category == 'Education'
              //                       ? Colors.greenAccent
              //                       : null,
              //             ),
              //           )
              //           .toList(),
              // ),
              Obx(() => SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: true,
                  title: AxisTitle(text: 'Hours'),
                  interval: 1,
                  minimum: 1,
                  maximum: 100,
                  numberFormat: NumberFormat("0.#"),
                ),
                series: <CartesianSeries<dynamic, dynamic>>[
                  SplineSeries<ChartData, String>(
                    dataSource: _sc.chartData.value,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.hours,
                    color: Colors.green,
                    width: 3,
                    markerSettings: const MarkerSettings(isVisible: true),
                    enableTooltip: true,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
