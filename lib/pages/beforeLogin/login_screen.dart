import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sync_day/pages/component/height_spacer.dart';
import 'package:sync_day/pages/component/primary_button.dart';
import 'package:sync_day/pages/component/text_field_wrapper.dart';
import 'package:sync_day/pages/component/title_wrapper.dart';
import 'package:sync_day/utils/app_colors.dart';

import '../../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _ac = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/login_bg.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 80,
                        horizontal: 10,
                      ),
                      width: double.infinity,
                      child: Form(
                        key: _ac.loginForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TitleWrapper(
                                    title: "Welcome To Sync Day",
                                    fontSize: 30,
                                  ),
                                  Text("Make the most of your time"),
                                  HeightSpacer(height: 40),
                                  Image.asset(
                                    "assets/images/glass_clock.png",
                                    width: 350,
                                    height: 350,
                                  ),
                                ],
                              ),
                            ),
                            HeightSpacer(height: 50),
                            TextFieldWrapper(
                              controller: _ac.email,
                              fillColor: AppColors.ghostWhite,
                              textColor: AppColors.black,
                              validator: _ac.isValidEmail,
                            ),
                            HeightSpacer(height: 20),
                            TextFieldWrapper(
                              controller: _ac.password,
                              fillColor: AppColors.ghostWhite,
                              textColor: AppColors.black,
                              validator: _ac.isValidPassword,
                            ),
                            HeightSpacer(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                onPressed: _ac.doLogin,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
