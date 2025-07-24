import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorTheme{
  static final blackColor = Color(0xFF1B1B1B);
  static final whiteColor = Color(0xFFF5F5F5);
  static final blueColor = Color(0xFF004F98);
  static final redColor = Colors.redAccent;
}

class ColorRiver extends StateNotifier<Color>{
  ColorRiver() : super(ColorTheme.blackColor);

  void setBlack()=>state=ColorTheme.blackColor;
  void setWhite()=>state=ColorTheme.whiteColor;
}

final colorProvider = StateNotifierProvider<ColorRiver, Color>(
  (ref){
    return ColorRiver();
  }
);