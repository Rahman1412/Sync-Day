import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sync_day/controller/common_controller.dart';
import 'package:sync_day/controller/task_controller.dart';
import 'package:sync_day/pages/component/calendar_dialog.dart';
import 'package:sync_day/pages/component/height_spacer.dart';
import 'package:sync_day/pages/component/primary_button.dart';
import 'package:sync_day/pages/component/text_field_wrapper.dart';
import 'package:sync_day/pages/component/title_wrapper.dart';
import 'package:sync_day/pages/component/width_spacer.dart';
import 'package:sync_day/utils/app_colors.dart';

class AddNewTask {
  static void showPopup(
    BuildContext context,
    TaskController tc,
    CommonController cc,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          maxChildSize: 0.95,
          minChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Form(
                      key: tc.taskForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWrapper(title: "New Task", fontSize: 20),
                          HeightSpacer(height: 10),
                          Text("Date"),
                          HeightSpacer(height: 2),
                          GestureDetector(
                            onTap: () => CalendarDialog.showPopup(context),
                            child: TextFieldWrapper(
                              controller: tc.date,
                              enabled: false,
                            ),
                          ),
                          HeightSpacer(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("From"),
                                    HeightSpacer(height: 2),
                                    GestureDetector(
                                      onTap: () => tc.selectTime(context, true),
                                      child: TextFieldWrapper(
                                        controller: tc.fromText,
                                        enabled: false,
                                        hint: "__:__",
                                        validator: tc.validateFrom,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              WidthSpacer(width: 10),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("To"),
                                    HeightSpacer(height: 2),
                                    GestureDetector(
                                      onTap:
                                          () => tc.selectTime(context, false),
                                      child: TextFieldWrapper(
                                        controller: tc.toText,
                                        enabled: false,
                                        hint: "__:__",
                                        validator: tc.validateTo,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          HeightSpacer(height: 10),
                          Text("Title"),
                          HeightSpacer(height: 2),
                          TextFieldWrapper(
                            controller: tc.title,
                            hint: "Enter Title",
                            validator: tc.validateTitle,
                          ),
                          HeightSpacer(height: 10),
                          Text("Type"),
                          HeightSpacer(height: 2),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: tc.taskType.value,
                              items: cc.activityType.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (String? value) => tc.updateTaskType(value),
                              validator: (value) => tc.validateTaskType(value),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.lightGrey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.lightGrey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.errorRed),
                                ),
                              ),
                              hint: Text("Select Activity Type"),
                            )
                            ;
                          }),
                          HeightSpacer(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tasks"),
                              IconButton(
                                onPressed: () => tc.addTask(),
                                icon: Image.asset("assets/icons/add-task.png"),
                              ),
                            ],
                          ),
                          Obx(() {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 5.0),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tc.task.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWrapper(
                                          controller: tc.task[index],
                                          validator: tc.validateTask,
                                        ),
                                      ),
                                      WidthSpacer(width: 10),
                                      IconButton(
                                        onPressed:
                                            () => tc.removeTask(tc.task[index]),
                                        icon: Image.asset(
                                          "assets/icons/remove-task.png",
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                          Text("Description (Optional)"),
                          HeightSpacer(height: 2),
                          TextFieldWrapper(
                            controller: tc.description,
                            maxLines: 3,
                            hint: "Enter Description",
                          ),
                          HeightSpacer(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              onPressed: () => tc.addNewTask(context),
                            ),
                          ),
                          HeightSpacer(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: () => hide(context),
                      icon: Image.asset(
                        "assets/images/close.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_){
      tc.clear();
    });
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
