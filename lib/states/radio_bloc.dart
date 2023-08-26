import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/customClasses/radio_browser.dart' as customRadioBrowser;
import 'package:radio_browser_flutter/radio_browser_flutter.dart';

const _maxListLength = 30;

class RadioBloc extends ChangeNotifier{
   RadioBloc(){
     getStations();
    }

    List stations = [];
    bool loading = true;
    bool loadingRadio = false;
    int actualIndex = 0;
    var selectedStation;
    bool isPlaying = false;
    double volume = 0.5;
    AudioPlayer player = AudioPlayer();


    Future<void> selectStation(Station station, index) async {
     selectedStation = station;
     actualIndex = index;
     notifyListeners();
      if(isPlaying){ //keep playing next station
        try{
          loadingRadio = true;
          notifyListeners();
          await player.dispose();
          player = AudioPlayer();
          await player.setSourceUrl(station.url.toString());
          await player.resume();
          loadingRadio = false;
          notifyListeners();
        }
        catch(e){
          loadingRadio = false;
          notifyListeners();
          return;
        }
        
      }

    }

    void startPlaying()async {
      try{
          loadingRadio = true;
          notifyListeners();
          player = AudioPlayer();
          await player.setSourceUrl(selectedStation.urlResolved.toString());
          isPlaying = true;
          await player.resume();
          loadingRadio = false;
          notifyListeners();
      }
      catch(e){
        loadingRadio = false;
        notifyListeners();
        return;
      }
    }

    void stopPlaying()async{
      try{
      isPlaying = false;
      await player.dispose();
      notifyListeners();
      }catch(e){
        return;
      }
  
    }

    void nextStation()async{
      if(actualIndex == stations.length-1){
        actualIndex = 0;
      }
      else{
        actualIndex++;
      }
      selectStation(stations[actualIndex], actualIndex);
      startPlaying();
    }

    void previousStation()async{
      if(actualIndex == 0){
        actualIndex = stations.length-1;
      }
      else{
        actualIndex--;
      }
      selectStation(stations[actualIndex], actualIndex);
      startPlaying();
    }

    void changeVolume(double newVolume)async{
      volume = newVolume;
      await player.setVolume(volume);
      notifyListeners();
    }

    Future<void> getStations() async {
        try{
          await customRadioBrowser.RadioBrowserClient.initialize('RadioAppTest');
          loading=false;
          final result = await customRadioBrowser.RadioBrowserClient.instance.stations.search( state: 'Barcelona', limit: _maxListLength, hideBroken: false);
          stations = result;
          selectedStation = stations[0];
          notifyListeners();   
        }
        catch(e){
          throw Exception(e);
        }
      }

}
