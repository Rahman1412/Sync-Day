import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sync_day/models/user.dart';
import 'package:sync_day/routes/app_routes.dart';
import 'package:sync_day/utils/storage_service.dart';

class AuthController extends GetxController{
  final StorageService _storage = Get.find();
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  late TextEditingController email, password;

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  String? isValidEmail(String? value){
    if(value == null || value.isEmpty){
      return "Email is required";
    }
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if(!regex.hasMatch(value)){
      return "Invalid email";
    }
    return null;
  }

  String? isValidPassword(String? value){
    if(value == null || value.isEmpty){
      return "Password is required";
    }
    return null;
  }

  Future<void> doLogin() async {
    if(!loginForm.currentState!.validate()) return;
    User _data = User(email: email.text, password: password.text);
    try{
      await _storage.setValue("sd_user",_data.toJson());
      Get.offAllNamed(AppRoutes.dashboard);
    }catch(e){
      print("Exception ======== ${e}");
    }
  }
}