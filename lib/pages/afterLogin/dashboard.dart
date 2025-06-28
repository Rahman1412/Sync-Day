import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sync_day/controller/common_controller.dart';
import 'package:sync_day/controller/dashboard_controller.dart';
import 'package:sync_day/controller/task_controller.dart';
import 'package:sync_day/pages/component/add_new_task.dart';

class Dashboard extends StatelessWidget {
  final DashboardController _dc = Get.find<DashboardController>();
  final TaskController _tc = Get.find<TaskController>();
  final CommonController cc = Get.find<CommonController>();

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _dc.index.value,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _dc.openPage,
        items:
        _dc.menu.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return BottomNavigationBarItem(
            icon: Image.asset(
                item["icon"],
                width: 24,
                height: 24,
                color:
                _dc.index.value == index
                    ? Theme.of(context).highlightColor
                    : Theme.of(context)
                    .colorScheme
                    .onSurface
            ),
            label: item["label"],
          );
        }).toList(),
      )),
      body: Obx(() {
        return _dc.widget[_dc.index.value];
      }),
      floatingActionButton: _getFloatingActionButton(context,_tc),
    );
  }

  Widget? _getFloatingActionButton(BuildContext context,TaskController tc) {
    return Obx(() {
      if (_dc.index.value != 0) return SizedBox.shrink();
      return FloatingActionButton(
        onPressed: (){
          tc.setCurrentDate();
          AddNewTask.showPopup(context,tc,cc);
        },
        child: Image.asset(
          "assets/icons/add.png",
          width: 24,
          height: 24,
          color: Theme.of(context).colorScheme.surface,
        ),
      );
    });
  }

}
