import 'package:flutter/material.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
class RoutineData{

  dynamic data =  [ ["","Mon","Tue","Wed","Thu","Fri"],
  ["7:30 AM-\n8:15 AM","","","","",""],
  ["9 AM-\n9:45 AM","","","","",""],
  ["10 AM-\n10:45 AM","","","","",""],
  ["11 AM-\n11:45 AM","","","","",""],
  ["12 PM-\n12:45 PM","","","","",""],
  ["2 PM-\n2:45 PM","","","","",""],
  ["3 PM-\n3:45 PM","","","","",""],
  ["4 PM-\n4:45 PM","","","","",""],
  ["5 PM-\n5:45 PM","","","","",""],
  ["6:15 PM-\n7 PM","","","","",""]];

       Map<int, dynamic> colorScheme = {
         1: Colors.red,
         2: Colors.blue.shade300,
         3: Colors.greenAccent,
         4: Colors.orangeAccent,
         5: Colors.purpleAccent,
         6: Colors.pink.shade200,
         7: Colors.teal.shade200,
         8: Colors.grey,
         9: Colors.lightGreenAccent.shade700,
         10: Colors.red.shade300,
         11: Colors.tealAccent,
         12: Colors.cyanAccent,
         13: Colors.blueAccent,
         14: Colors.indigo,
         15: Colors.deepPurple,
         16: Colors.cyan,
         17: Colors.lightGreen,
         18: Colors.amber.shade900,

       };
}