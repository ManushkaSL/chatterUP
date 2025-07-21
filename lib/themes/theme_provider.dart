import 'package:chatter_up/themes/dark_mode.dart';
import 'package:chatter_up/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = getLightMode();

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == getDarkMode();

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData == getLightMode()){
      themeData = getDarkMode();
    }else {
      themeData = getLightMode();
    }
  }
}