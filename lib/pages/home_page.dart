import 'package:flutter/material.dart';
import 'package:radio_app/components/floating_bar.dart';
import 'package:radio_app/components/radio_list.dart';
import 'package:radio_app/states/radio_bloc.dart';
import 'package:radio_app/states/radio_provider.dart';
import 'package:radio_browser_flutter/radio_browser_flutter.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  final blocState = RadioBloc();
  

 @override
  Widget build(BuildContext context) {
    return 
    RadioProvider(bloc: blocState, child: 
    AnimatedBuilder(
      animation: blocState, 
      builder: (context, _){
      return   blocState.loading && blocState.stations.isEmpty ? const Center(child: CircularProgressIndicator(),) : Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              RadioList(),
              FloatingBar(),
            ],
          ),
        )
      ],
    );
    })
    );
  }
}





 