import 'package:flutter/material.dart';
import 'package:sync_day/utils/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.darkPink,
    onPrimary: AppColors.ghostWhite,
    secondary: AppColors.charcoalBlue,
    onSecondary: AppColors.ghostWhite,
    error: AppColors.errorRed,
    onError: AppColors.ghostWhite,
    surface: AppColors.ghostWhite,
    onSurface: Colors.black,
  ),

  highlightColor: AppColors.darkPink,

  cardTheme: CardThemeData(
    margin: EdgeInsets.all(5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.lightGrey, width: 1),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 6,
    backgroundColor: AppColors.darkPink,
    shape: CircleBorder(),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 4,
    unselectedItemColor: Colors.black,
    selectedItemColor: AppColors.darkPink,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),

  tabBarTheme: TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorAnimation: TabIndicatorAnimation.elastic,
    indicator: BoxDecoration(
      color: AppColors.darkPink,
      borderRadius: BorderRadius.circular(10),
    ),
    dividerColor: Colors.transparent,
    labelColor: AppColors.ghostWhite,
  ),


);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkYellow,
    onPrimary: AppColors.ghostWhite,
    secondary: AppColors.charcoalBlue,
    onSecondary: AppColors.ghostWhite,
    error: AppColors.errorRed,
    onError: AppColors.ghostWhite,
    surface: Colors.black,
    onSurface: AppColors.ghostWhite,
  ),

  cardTheme: CardThemeData(
    margin: EdgeInsets.all(5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.lightGrey, width: 1),
    ),
  ),

  highlightColor: AppColors.darkYellow,

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 6,
    backgroundColor: AppColors.darkYellow,
    shape: CircleBorder(),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 4,
    unselectedItemColor: AppColors.ghostWhite,
    selectedItemColor: AppColors.darkYellow,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),

  tabBarTheme: TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorAnimation: TabIndicatorAnimation.elastic,
    indicator: BoxDecoration(
      color: AppColors.darkYellow,
      borderRadius: BorderRadius.circular(10),
    ),
    dividerColor: Colors.transparent,
    labelColor: Colors.black,
  ),
);
