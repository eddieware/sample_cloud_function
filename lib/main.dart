import 'package:flutter/material.dart';
import 'package:sample_cloud_function/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'CRUD', home: HomePage());
  }
}
