

import 'package:flutter/material.dart';
import 'package:radio_app/states/radio_provider.dart';

import '../pages/details_page.dart';


const _colorList = [
   'FF292C35', 'FFA58E74', 'FFE09145', 'FF343434', 'FFFCD9B8', 
];

class RadioList extends StatefulWidget{
  const RadioList({Key? key}) : super(key: key);

  @override
  _RadioListState createState() => _RadioListState();
}


class _RadioListState extends State<RadioList>{
  late FixedExtentScrollController controller; //in order to change the selected radio station manually

  @override
  void initState(){
    super.initState();
    controller = FixedExtentScrollController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final blocState = RadioProvider.of(context)!.bloc;
    return 
     GestureDetector(
        onTap: () => {
          Navigator.of(context).push(
            PageRouteBuilder(pageBuilder: (context, animation, __){
              return FadeTransition(
                opacity: animation,
                child:RadioDetails(
                  blocState: blocState, 
                )
                );
            }
            )
            )
          },
      child:     
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            color: null,
            child:   ListWheelScrollView.useDelegate(
            itemExtent: 170, //height of each item
            controller: controller,
            physics:const  FixedExtentScrollPhysics(),
            diameterRatio: 2,
            offAxisFraction: -2,
            squeeze: 0.95,
            onSelectedItemChanged: (index){
              blocState.selectStation(blocState.stations[index], index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
            childCount: blocState.stations.length,
              builder: (context, index){
                final station = blocState.stations[index];
                return   getRadioCard(station, index);
              },
            ))
        ),));
      }
}


Widget getRadioCard(station, index){
  
  return 

  FractionallySizedBox(
    widthFactor: 0.8,
    child: 
      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(int.parse(_colorList[index % _colorList.length], radix: 16)).withOpacity(0.5),
      ),
      width: double.infinity,
      child:
       
      Row(
        children: [
          const Padding(padding: EdgeInsets.only(left:10)),
          station.favicon.toString().isNotEmpty ? Image.network(station.favicon.toString(), height: 130, width: 130, ) : const Icon(Icons.radio, size: 130, color: Colors.white,),
          Flexible(child: 
          Container(padding: const EdgeInsets.only(left: 30, right: 30), child: 
          Column(
             mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(station.name, style: const TextStyle(color: Colors.white), overflow: TextOverflow.visible,),
              Text(station.state, style: const TextStyle(color: Colors.white),),
            ],
          )
          )
          )
        ],
      ))
  );
}
