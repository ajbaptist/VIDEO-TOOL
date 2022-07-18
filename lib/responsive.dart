import 'package:flutter/material.dart';

class DeviceSizeConfig{
 static MediaQueryData? mediaQueryData;
static double? screenWidth;
 static double? screenHeight;
 static double? blockSizeHorizontal;
 static double? blockSizeVertical;
 
  
 static double? safeAreaHorizontal;
 static double? safeAreaVertical;
 static double? safeBlockHorizontal;
 static double? safeBlockVertical;
 
 void init(BuildContext context) {
 mediaQueryData = MediaQuery.of(context);
 screenWidth = mediaQueryData!.size.width;
 screenHeight = mediaQueryData!.size.height;
 blockSizeHorizontal = (screenWidth! / 100);
 blockSizeVertical = screenHeight! / 100;
 
 }
}