import 'dart:io';
import 'package:dart_midi/dart_midi.dart';
import 'package:midieditor/BaseConfig.dart';
import 'package:midieditor/util/XUtil.dart';

class MidiCreate {
  //判定是否为数字
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool isLetter(String s){
    bool _isLetter = true;
    s.codeUnits.forEach((c) {
      if(c>=0x41 && c<=0x5a){
       
     }
     else if(c>=0x61 && c<=0x7a){
       
     } else{
       _isLetter = false;
     }
    });
     
     return _isLetter;
  }

  //创建一个示例midi文件
  static MidiFile makeSimpleMidi(){
     List<List<MidiEvent>> tracks = [];
     List<MidiEvent> task1 = [];
     List<MidiEvent> task2 = [];
   MidiHeader header = new MidiHeader(ticksPerBeat: 400,numTracks: 2,format: 1);
   TimeSignatureEvent event_timesignature = TimeSignatureEvent();
   event_timesignature.numerator = 4;
   event_timesignature.denominator = 4;
   event_timesignature.metronome = 24;
   event_timesignature.thirtyseconds = 8;
   event_timesignature.type = "timeSignature";
   event_timesignature.deltaTime = 0;
   event_timesignature.meta = true;
   task1.add(event_timesignature);
   SetTempoEvent event_settempo = new SetTempoEvent();
   event_settempo.microsecondsPerBeat = 487804;
   event_settempo.meta = true;
   event_settempo.type = "setTempo";
   event_settempo.deltaTime = 0;
   
   task1.add(event_settempo);
   ProgramChangeMidiEvent event_program = new ProgramChangeMidiEvent();
   event_program.channel = 1;
   event_program.programNumber = 1; //乐器
   event_program.type = "programChange";
   event_program.meta = false;
   event_program.deltaTime = 0;
   task1.add(event_program);
   EndOfTrackEvent event_end = new EndOfTrackEvent();
   event_end.meta = true;
   event_end.type = "endOfTrack";
   event_end.meta = true;
   event_end.deltaTime = 0;
   event_end.running = false;


   task1.add(event_end);

   NoteOnEvent event_on = new NoteOnEvent();
   NoteOffEvent event_off = new NoteOffEvent();
   event_on.noteNumber = 80;
   event_on.velocity = 100;
   event_on.channel = 1;
   event_on.deltaTime = 0;
   event_on.running = false;
   event_on.type = "noteOn";


   event_off.noteNumber = 80;
   event_off.channel = 1;
   event_off.velocity = 0;
   event_off.type = "noteOff";
   event_off.deltaTime = 400;
   event_off.running = false;
   event_off.meta = false;


   EndOfTrackEvent event_end2 = new EndOfTrackEvent();
   event_end2.type = "endOfTrack";
   event_end2.meta = true;
   event_end2.running = false;
   event_end2.deltaTime = 0;
   
   task2.add(event_on);
   task2.add(event_off);
   task2.add(event_end2);
   tracks.add(task1);
   tracks.add(task2);
MidiFile parsedMidi = new MidiFile(tracks, header);
// var writer = MidiWriter();
// writer.writeMidiToFile(parsedMidi, File(outpath));
// printMifiFile(parsedMidi);
return parsedMidi;
  }

//输入字符串生成midi文件 返回midi文件名
  void makeTextToMidi(String text, String outpath) {
    // Open a file containing midi data
    var file = File(BaseConfig.cacheDir.path+"/"+'example.mid');
//乐谱
//     String text = """3556531233212
// 3556531233221
// 44566 65532
// 3556531233221
// """;
    String text2 = """1155665 4433221
5544332 5544332
1155665 4433221
""";

// Construct a midi parser
    var parser = MidiParser();

// Parse midi directly from file. You can also use parseMidiFromBuffer to directly parse List<int>
    MidiFile parsedMidi = makeSimpleMidi();// parser.parseMidiFromFile(file);
printMifiFile(parsedMidi);
// You can now access your parsed [MidiFile]
    print("----------------");
//音阶
    int leve = 7;
    //乐器
    int musical = 1;
    bool isAnnotation = false;
    int start = 0;
    int type = 0;
    String key = "";
    String value = "";
    print(parsedMidi.tracks.length.toString());
    
//拿到第二音轨并清空

    if (parsedMidi.tracks.length >= 2) {
      List<MidiEvent> task = parsedMidi.tracks[1];
      NoteOnEvent temp_note = new NoteOnEvent();
      NoteOffEvent temp_noteoff = new NoteOffEvent();
      EndOfTrackEvent task_end = new EndOfTrackEvent();
      TimeSignatureEvent timeEvent =
          parsedMidi.tracks[0][0] as TimeSignatureEvent;
      MidiHeader header = parsedMidi.header;
      print(
          "head ${header.timeDivision} ${header.ticksPerFrame} ${header.numTracks} ${header.ticksPerBeat} ${header.ticksPerFrame}");
      task.forEach((element) {
        if (element is NoteOnEvent) {
          temp_note = element;
        }
        if (element is NoteOffEvent) {
          temp_noteoff = element;
        }
        if (element is EndOfTrackEvent) {
          task_end = element;
          // task.remove(element);
        }
      });
      
      // temp_note.velocity = 90;
      // task.remove(task.length-1);
      // task.clear();
      temp_note.deltaTime = 0;
      temp_noteoff.deltaTime = 400;
      int upTime = temp_noteoff.deltaTime;
      for (int i = 0; i < text.length; i++) {
        
        var c = text[i];
        if(isAnnotation){
          switch(type){
            case 0:
              if(isLetter(c)){
                type = 1;
              }
              break;
            case 1:
              if(!isLetter(c)){
                if(c==":" || c==" "){
                  key = text.substring(start,i);
                  start = i+1;
                  type = 2;
                }
              }
              break;
            case 2:
              if(c=="," || c=="]"){
                value = text.substring(start,i);
                if(key == "p"){
                  musical = int.parse(value);
                  ProgramChangeMidiEvent event_program = new ProgramChangeMidiEvent();
                  event_program.channel = 1;
                  event_program.programNumber = musical; //乐器
                  event_program.type = "programChange";
                  event_program.meta = false;
                  event_program.deltaTime = 0;
   
                  task.insert(task.length-1, event_program);
                }
              }
              break;
          }
          if(c=="]"){
          isAnnotation = false;
          }
        }else if (isNumeric(c)) {
          var number = int.parse(c);
          
          if (number > 6) {
            number += 5;
          } else if (number > 5) {
            number += 4;
          } else if (number > 4) {
            number += 3;
          } else if (number > 2) {
            number += 2;
          } else if (number > 1) {
            number += 1;
          } 
          

          temp_note.noteNumber = leve * 12 + number;
          if(number == 0){
            temp_note.noteNumber = 12;
            temp_noteoff.noteNumber = 12;
          }
          temp_noteoff.deltaTime = 400;
          temp_noteoff.noteNumber = leve * 12 + number;
          // timeEvent.deltaTime += temp_note.deltaTime;
          
          upTime = temp_noteoff.deltaTime;
        } else if(c=="+"){
          temp_note.noteNumber += 12;
        }else if(c=="-"){
          temp_note.noteNumber -= 12;
        }
        else if(c=="#"){
          temp_note.noteNumber ++;
        }else if(c=="/"){
          temp_noteoff.deltaTime = temp_noteoff.deltaTime~/2;
        }else if(c=="_"){
          temp_noteoff.deltaTime = temp_noteoff.deltaTime*2;
        }else if(c=="."){ //音长加1/2
          temp_noteoff.deltaTime = temp_noteoff.deltaTime + upTime~/2;
        }else if(c==","){ //音长加1/4
          temp_noteoff.deltaTime = temp_noteoff.deltaTime + upTime * 1~/4;
        }else if(c=="["){ //表示注释，里面可以声明音量 乐器
          isAnnotation = true;
          start = i+1;
        }else if(c=="]"){
          isAnnotation = false;
        }
        else {
          temp_note.noteNumber = 12;
          temp_noteoff.noteNumber = 12;
          // timeEvent.deltaTime += temp_note.deltaTime;
          // temp_note.velocity = 0;
          print("\n");
        }
        print("${c} ${temp_note.noteNumber}");
        NoteOnEvent note_on = new NoteOnEvent();
        NoteOffEvent note_off = new NoteOffEvent();
        note_on.noteNumber = temp_note.noteNumber;
        note_on.velocity = temp_note.velocity;
        note_on.deltaTime = temp_note.deltaTime;
        note_on.channel = temp_note.channel;
        note_on.byte9 = temp_note.byte9;

        note_on.velocity = temp_note.velocity;

        note_on.type = temp_note.type;
        note_on.meta = temp_note.meta;
        note_on.running = temp_note.running;
        note_on.lastEventTypeByte = temp_note.lastEventTypeByte;
        note_on.useByte9ForNoteOff = temp_note.useByte9ForNoteOff;

        note_off.noteNumber = temp_noteoff.noteNumber;
        note_off.channel = temp_noteoff.channel;
        note_off.velocity = temp_noteoff.velocity;
        note_off.byte9 = temp_noteoff.byte9;
        note_off.deltaTime = temp_noteoff.deltaTime;

        note_off.type = temp_noteoff.type;
        note_off.meta = temp_noteoff.meta;
        note_off.running = temp_noteoff.running;
        note_off.lastEventTypeByte = temp_noteoff.lastEventTypeByte;
        note_off.useByte9ForNoteOff = temp_noteoff.useByte9ForNoteOff;
        
        if(c=="+"||c=="-"||c=="#"||c=="/"||c=="_"||c=="."||c==","){
          task.removeAt(task.length-1);
          task.removeAt(task.length-1);
        }
        if(!isAnnotation && c!="]"){
          task.insert(task.length - 1, note_on);
          task.insert(task.length - 1, note_off);
        }
        
      }
      if(!isAnnotation){
        task.removeAt(0);
        task.removeAt(0);
      }
      
      // task.add(task_end);
    }

// Construct a midi writer
    var writer = MidiWriter();

// Let's write and encode our midi data again
// You can also control `running` flag to compress file and  `useByte9ForNoteOff` to use 0x09 for noteOff when velocity is zero
    writer.writeMidiToFile(parsedMidi, File(outpath),running: true,useByte9ForNoteOff:true);
  }

static void printMidiEvent(MidiEvent event){
  print("type=${event.type} deltaTime=${event.deltaTime} meta=${event.meta} running=${event.running} lastEventTypeByte=${event.lastEventTypeByte} useByteForNode=${event.useByte9ForNoteOff}");
}
//打印midiFile
  static void printMifiFile(MidiFile parsedMidi) {
    MidiHeader header = parsedMidi.header;
    print("MidiHeader ${header.framesPerSecond} ${header.ticksPerBeat} ${header.ticksPerFrame} ${header.numTracks} ${header.format} ${header.timeDivision}");
    for (int i = 0; i < parsedMidi.tracks.length; i++) {
      List<MidiEvent> task = parsedMidi.tracks[i];
      for (int j = 0; j < task.length; j++) {
        MidiEvent event = task[j];
        if (event is NoteOnEvent) {
          print(
              "nodeOn ${event.noteNumber} ${event.velocity} channel=${event.channel} ${event.deltaTime} ${event.byte9}");
          event.noteNumber += 7;
        } else if (event is NoteOffEvent) {
          print("nodeOff ${event.noteNumber} ${event.velocity} ${event.channel} ${event.deltaTime} ${event.byte9}");
        } else if (event is TrackNameEvent) {
          print(
              "name ${event.text} ${event.meta} ");
        } else if (event is ControllerEvent) {
          print("ControllerEvent ${event.type} ${event.channel} ${event.value} ${event.number}");
        } else if (event is InstrumentNameEvent) {
          print("仪器名 ${event.text}");
        } else if (event is ProgramChangeMidiEvent) {
          // event.programNumber = 5;
          print("改变乐器 ${event.channel} ${event.programNumber}");
        } else if (event is TimeSignatureEvent) {
          print(
              "TimeSignatureEvent ${event.numerator}/${event.denominator} ${event.metronome} ${event.thirtyseconds}");
        } else if (event is SetTempoEvent) {
          print("SetTempoEvent ${event.microsecondsPerBeat} ${event.meta}");
        } else if (event is EndOfTrackEvent) {
          print(
              "End ${event.meta}");
        } else
          print(event.toString());
        
        printMidiEvent(event);
      }
      print("\n\n");
    }
  }
}
