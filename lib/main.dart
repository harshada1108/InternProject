import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internp/Pages/HomePage.dart';
import 'package:internp/Widgets/ContainerWidget.dart';
import 'package:internp/Widgets/FilterList.dart';
import 'package:internp/Widgets/LikedPage.dart';
import 'package:internp/Widgets/SavedPage.dart';
import 'package:internp/main.dart';
import 'package:internp/viewModel/Viewmodel.dart';
import 'dart:convert';

import 'package:internp/viewModel/fetchmodel.dart';
import 'package:internp/Pages/HomePage0.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}



