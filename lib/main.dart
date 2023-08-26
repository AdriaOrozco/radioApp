import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_app/pages/home_page.dart';

void main() {
  DartPingIOS.register();
  runApp(const MainApp());
}

const _backgroundColor =  Color(0xFF121212);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _backgroundColor,
        body:  AnnotatedRegion<SystemUiOverlayStyle>(
         value: SystemUiOverlayStyle.light, 
         child: SafeArea(
          child: HomePage()
          )
        )
      ),
    );
  }
}
