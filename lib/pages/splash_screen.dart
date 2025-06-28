import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sync_day/routes/app_routes.dart';
import 'package:sync_day/utils/storage_service.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SplashScreen();

}

class _SplashScreen extends State<SplashScreen>{
  final StorageService _storage = Get.find();
  late dynamic _user;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async{
    _user = await _storage.getValue("sd_user");
    Future.delayed(Duration(seconds: 3),(){
      if(_user == null){
        Get.offAllNamed(AppRoutes.login);
      }else{
        Get.offAllNamed(AppRoutes.dashboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Text("Splash Screen"),
      )),
    );
  }

}