import 'package:flutter/material.dart';
import 'package:radio_app/states/radio_provider.dart';
import 'package:radio_browser_flutter/radio_browser_flutter.dart';

import '../states/radio_bloc.dart';

const _backgroundColor =  Color(0xFF121212);

class RadioDetails extends StatelessWidget{
  const RadioDetails({Key? key, required this.blocState}) : super(key: key);

  final RadioBloc blocState;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
      )
      ,
      body:
      AnimatedBuilder(
        animation: blocState,
        builder: (context, child) {
        return
         
          Center(
            child: 
              Column(
                children: [
                  
                  SizedBox(height: 100),
                  Hero(
                    tag: blocState.selectedStation.url.toString(),
                    child:
                    blocState.selectedStation.favicon.toString().isEmpty ?
                    Icon( Icons.radio, size: 200, color: Colors.white,)
                     : Image.network(
                        blocState.selectedStation.favicon.toString(),
                        height: 200,
                        width: 200,
                        )
                  ),
                  const SizedBox(height: 20)
                  ,
                      Text(blocState.selectedStation.name, style: const TextStyle(color: Colors.white, fontSize: 20), overflow: TextOverflow.visible,),
                      Text(blocState.selectedStation.state, style: const TextStyle(color: Colors.white, fontSize: 15),)
                    ,
                   const SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 60,
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                        onPressed: () {
                         blocState.previousStation();
                        },
                      ),
                      blocState.loadingRadio ?
                      const SizedBox(
                            height: 45,
                            width: 45,
                            child: 
                              CircularProgressIndicator(color: Colors.white, strokeWidth: 1,) 
                              )
                      :
                        IconButton(
                        iconSize: 60,
                        icon: Icon(
                          blocState.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          blocState.isPlaying ? blocState.stopPlaying() :
                          blocState.startPlaying();
                        },
                      ),
                      IconButton(
                        iconSize: 60,
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                        onPressed: () {
                        blocState.nextStation();
                        },
                      )
                    ],
                  )
                  ,
                  const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                         IconButton(
                        iconSize: 30,
                        icon: Icon(
                          blocState.volume == 0 ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          blocState.volume == 0 ? blocState.changeVolume(0.5) : blocState.changeVolume(0);
                        },
                      ),
                       Slider(
                       thumbColor: Colors.white,
                        activeColor: Colors.white,
                       value: blocState.volume, 
                       onChanged: (newvol){
                         blocState.changeVolume(newvol);
                       },
                       min: 0,
                       max:  1,
                       divisions: 100,
                     ) ,
                    ],)
          ],
          
          ),
          
        )
      ;
        },
      ));
    
  }
}
