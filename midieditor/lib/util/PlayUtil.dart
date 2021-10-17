

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicplayer_plugin/musicplayer_plugin.dart';
import '../BaseConfig.dart';

class PlayUtil {
  static Map<String, AudioPlayer> map_player = new Map();

   static void playSound(String assetsName){
     if (BaseConfig.platform == "web") {
       if(map_player[assetsName] == null){
         map_player[assetsName] = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
       }
       map_player[assetsName].play(assetsName);
     } else if(BaseConfig.platform == "android" || BaseConfig.platform=="ios" || BaseConfig.platform=="macos" || BaseConfig.platform=="web"){
       AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
       player.open(
         Audio(assetsName),
         showNotification: true,
       );
       player.play();
     } else if(BaseConfig.platform == "windows"){
       MusicplayerPlugin.playMusic(assetsName);
     }
   }

   static void playSoundWithPath(String path){
    AudioPlayer audioPlayer = AudioPlayer();
    if(BaseConfig.platform == "android" || BaseConfig.platform=="ios"){
      audioPlayer.play(path, isLocal: true);
    } else{
      MusicplayerPlugin.playMusic(path);
    }
       
  }
     
   
}