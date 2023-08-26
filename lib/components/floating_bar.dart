import 'package:flutter/material.dart';
import 'package:radio_app/pages/details_page.dart';
import 'package:radio_app/states/radio_provider.dart';

const _bottomBarHeight = 70.0;

class FloatingBar extends StatefulWidget{
  const FloatingBar({Key? key}) : super(key: key);

  @override
  _FloatingBarState createState() => _FloatingBarState();
}


class _FloatingBarState extends State<FloatingBar>{

  @override
  Widget build(BuildContext context){
    final blocState = RadioProvider.of(context)!.bloc;
    return 
     
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                height: _bottomBarHeight,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 10,
                    end: 10,
                  ),
                  child:
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
                    Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF535353),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10)
                      ),
                    ),
                    child: generateCardContent(blocState),
                  ),
          ))
        );
    }
}

Widget generateCardContent(blocState){
  return blocState.selectedStation.toString() == 'null' ?
      const SizedBox():
      Row(
        children: [
          const Padding(padding: EdgeInsets.only(left:10)),
          blocState.selectedStation.favicon.toString().isNotEmpty ? 
          Hero(tag: blocState.selectedStation.url.toString(), child: 
              Image.network(blocState.selectedStation.favicon.toString(), height: 50, width: 50, ) 
          )
          : 
          Hero(tag: blocState.selectedStation.url.toString(), child:
          const Icon(Icons.radio, size: 50, color: Colors.white,
          )),
          Flexible(child: 
          Container(padding: const EdgeInsets.only(left: 30, right: 30), width: 200, child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(blocState.selectedStation.name, style: const TextStyle(color: Colors.white), overflow: TextOverflow.visible,),
              Text(blocState.selectedStation.state, style:  TextStyle(color: Color(int.parse('FFB3B3B3', radix: 16 ))),),
            ],
          ),
          ),
          ),
          Flexible(child: 
          Container( child: 
            Center(child: 
            Align(alignment: Alignment.centerRight, child:
              blocState.loadingRadio ?
               const Padding(
                padding: const EdgeInsets.only(right: 10), child: 
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: 
                      CircularProgressIndicator(color: Colors.white, strokeWidth: 1,) ))
              :
              IconButton(
                iconSize: 40,
                padding: const EdgeInsets.only(right: 10),
                icon: Icon(
                  blocState.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  blocState.isPlaying ? blocState.stopPlaying() :
                  blocState.startPlaying();
                },
              )), 
             )
          ),
          
          )
        ],
      );
}