import 'package:flutter/material.dart';
import 'package:flu_map/GoogleMap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: G_map(),
    );
  }
}
