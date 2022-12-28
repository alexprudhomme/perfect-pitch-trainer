import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

const List<Widget> notes = <Widget>[
  Text('A'),
  Text('A#/B\u266D'),
  Text('B'),
  Text('C'),
  Text('C#/D\u266D'),
  Text('D'),
  Text('D#/E\u266D'),
  Text('E'),
  Text('F'),
  Text('F#/G\u266D'),
  Text('G'),
  Text('G#/A\u266D'),
];

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}
class _QuizState extends State<Quiz> {
  Map<String, List<String>> all_sounds = {
    'A': <String>['A2.mp3', 'A3.mp3', 'A4.mp3', 'A5.mp3', 'A6.mp3',],
    'Bb': <String>['Bb2.mp3', 'Bb3.mp3', 'Bb4.mp3', 'Bb5.mp3', 'Bb6.mp3',],
    'B': <String>['B2.mp3', 'B3.mp3', 'B4.mp3', 'B5.mp3', 'B6.mp3',],
    'C': <String>['C2.mp3', 'C3.mp3', 'C4.mp3', 'C5.mp3', 'C6.mp3',],
    'Db': <String>['Db2.mp3', 'Db3.mp3', 'Db4.mp3', 'Db5.mp3', 'Db6.mp3',],
    'D': <String>['D2.mp3', 'D3.mp3', 'D4.mp3', 'D5.mp3', 'D6.mp3',],
    'Eb': <String>['Eb2.mp3', 'Eb3.mp3', 'Eb4.mp3', 'Eb5.mp3', 'Eb6.mp3',],
    'E': <String>['E2.mp3', 'E3.mp3', 'E4.mp3', 'E5.mp3', 'E6.mp3',],
    'F': <String>['F2.mp3', 'F3.mp3', 'F4.mp3', 'F5.mp3', 'F6.mp3',],
    'Gb': <String>['Gb2.mp3', 'Gb3.mp3', 'Gb4.mp3', 'Gb5.mp3', 'Gb6.mp3',],
    'G': <String>['G2.mp3', 'G3.mp3', 'G4.mp3', 'G5.mp3', 'G6.mp3',],
    'Ab': <String>['Ab2.mp3', 'Ab3.mp3', 'Ab4.mp3', 'Ab5.mp3', 'Ab6.mp3',],
  };
  RangeValues currentRangeValues = RangeValues(2,6);
  bool isNoteRight = false;
  final List<bool> selectedNotes = <bool>[false, false, false, true, false, true,
                                          false, true, false, false, false, false];
  final Map<int, String> indexToLetter = {
    0:'A',
    1:'Bb',
    2:'B',
    3:'C',
    4:'Db',
    5:'D',
    6:'Eb',
    7:'E',
    8:'F',
    9:'Gb',
    10:'G',
    11:'Ab',
  };
  late String currentNote = '';
  late List<String> selectedPossibleSounds = <String>['C2.mp3', 'C3.mp3', 'C4.mp3',
    'C5.mp3', 'C6.mp3', 'D2.mp3', 'D3.mp3', 'D4.mp3', 'D5.mp3', 'D6.mp3', 'E2.mp3',
    'E3.mp3', 'E4.mp3', 'E5.mp3', 'E6.mp3',];
  bool isStart = true;
  bool isGameStart = false;
  bool isCurrentAnswerWrong = false;
  Color? colorBasic = Colors.grey[200];
  Color? colorWrong = Colors.red[300];
  Color? colorRight = Colors.green[300];
  late Color? colorA = colorBasic;
  late Color? colorBb= colorBasic;
  late Color? colorB = colorBasic;
  late Color? colorC = colorBasic;
  late Color? colorDb = colorBasic;
  late Color? colorD = colorBasic;
  late Color? colorEb = colorBasic;
  late Color? colorF = colorBasic;
  late Color? colorGb = colorBasic;
  late Color? colorG = colorBasic;
  late Color? colorAb = colorBasic;
  late Color? colorE = colorBasic;

  late int progressBarNumerator = 0;
  late int progressBarDenominator = 0;
  late double progressBar = progressBarNumerator/progressBarDenominator;
  late double progressBarTimes100 = progressBar * 100;
  late String progressBarRounded = progressBarTimes100.toStringAsFixed(2);

  void updateAllSounds(){
    for (var key in all_sounds.keys){
      all_sounds[key]?.clear();
    }
    for (int i = currentRangeValues.start as int; i < currentRangeValues.end + 1; i++){
      for(var key in all_sounds.keys){
        all_sounds[key]?.add('$key$i.mp3');
      }
      selectedPossibleSounds.clear();
      for (int i = 0; i < selectedNotes.length; i++){
        if(selectedNotes[i]){
          selectedPossibleSounds.addAll(all_sounds[indexToLetter[i]]!);
        }
      }
    }
  }
  AudioPlayer player = AudioPlayer();
  void rightAnswer(){
    Source source = AssetSource('sounds/right.mp3');
    player.setVolume(0.3);
    player.play(source);
    if(!isNoteRight){
      if(isCurrentAnswerWrong){
        isCurrentAnswerWrong = false;
      }else{
        progressBarNumerator++;
        progressBarDenominator++;
        progressBar = progressBarNumerator/progressBarDenominator;
        progressBarRounded = (progressBar*100).toStringAsFixed(2);
      }
      isNoteRight = true;
      isGameStart = true;
    }
  }
  void wrongAnswer(){
    Source source = AssetSource('sounds/wrong2.mp3');
    player.setVolume(0.3);
    player.play(source);
    if(!isNoteRight){
      isGameStart = true;
      if (!isCurrentAnswerWrong){
        progressBarDenominator++;
        progressBar = progressBarNumerator/progressBarDenominator;
        progressBarRounded = (progressBar*100).toStringAsFixed(2);
        isCurrentAnswerWrong = true;
      }
    }
  }
  void playRandomNote(){
    player.setVolume(1);
    final random = Random();
    String note = selectedPossibleSounds[random.nextInt(selectedPossibleSounds.length)];
    Source source = AssetSource('sounds/$note');
    player.play(source);
    currentNote = note;
  }
  void playCurrentNote(){
    player.setVolume(1);
    Source source = AssetSource('sounds/$currentNote');
    player.play(source);
  }
  bool checkAnswer(String letter){
    if(letter == 'Bb' || letter == 'Db' || letter == 'Eb' || letter == 'Gb' || letter == 'Ab'){
      if (currentNote[0] == letter[0] && currentNote[1] == letter[1]){
        return true;
      }
    }else{
      if(currentNote[0] == letter[0]){
        return true;
      }
    }
    return false;
  }
  void makeColorNotesBasic(){
    colorA = colorBasic;
    colorBb= colorBasic;
    colorB = colorBasic;
    colorC = colorBasic;
    colorDb = colorBasic;
    colorD = colorBasic;
    colorEb = colorBasic;
    colorF = colorBasic;
    colorGb = colorBasic;
    colorG = colorBasic;
    colorAb = colorBasic;
    colorE = colorBasic;
  }

  @override
  Widget build(BuildContext context) {
    print(currentNote);
    print(selectedPossibleSounds);
    print(all_sounds);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(253, 245, 223, 1),
      body: SafeArea(
        child: Container(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 7.0,
                          percent: isGameStart ? progressBar : 0.0,
                          center: Text(
                              isGameStart ? '$progressBarNumerator/$progressBarDenominator' : ''),
                          progressColor: Color.fromRGBO(249, 44, 133, 0.5),
                        ),
                        const SizedBox(height: 50.0,),
                        Visibility(
                          visible: isNoteRight,
                            child: ElevatedButton(
                              onPressed: (){
                                playRandomNote();
                                makeColorNotesBasic();
                                setState(() {
                                  isNoteRight = false;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return const Color.fromRGBO(249, 44, 133, 0.8);
                                    }else if(states.contains(MaterialState.hovered)){
                                      return const Color.fromRGBO(249, 44, 133, 0.5);
                                    }
                                    return const Color.fromRGBO(239, 239, 239, 1); // Use the component's default.
                                  },
                                ),
                              ),
                              child: const Text('Next',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),),
                            )
                        ),
                        const SizedBox(height: 10.0,),
                        ElevatedButton(
                          onPressed: (){
                            isStart ? playRandomNote(): playCurrentNote();
                            setState((){
                              isStart = false;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromRGBO(249, 44, 133, 0.8);
                                }else if(states.contains(MaterialState.hovered)){
                                  return const Color.fromRGBO(249, 44, 133, 0.5);
                                }
                                return const Color.fromRGBO(239, 239, 239, 1); // Use the component's default.
                              },
                            ),
                          ),
                          child: Text(
                            isStart ? 'Start': 'Hear Again',
                            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),
                          ),
                        ),
                        const SizedBox(height: 30.0,),
                        Row(
                          children: [
                            Visibility(
                              visible: selectedNotes[0] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('A')){
                                        setState(() {
                                          colorA = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorA = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                      backgroundColor: MaterialStateProperty.all(colorA)
                                    ),
                                    child: const Text('A',style:  TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[1] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('Bb')){
                                        setState(() {
                                          colorBb = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState((){
                                          colorBb = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorBb)
                                    ),
                                    child: const Text('A#/B\u266D',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[2] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('B')){
                                        setState(() {
                                          colorB = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorB = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorB)
                                    ),
                                    child: const Text('B',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[3] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('C')){
                                        setState(() {
                                          colorC = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorC = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorC)
                                    ),
                                    child: const Text('C',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[4] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('Db')){
                                        setState(() {
                                          colorDb = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorDb = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorDb)
                                    ),
                                    child: const Text('C#/D\u266D',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[5] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('D')){
                                        setState(() {
                                          colorD = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorD = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorD)
                                    ),
                                    child: const Text('D',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                          ],
                        ),const SizedBox(height: 5.0,),
                        Row(
                          children: [
                            Visibility(
                                visible: selectedNotes[6] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('Eb')){
                                        setState(() {
                                          colorEb = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorEb = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorEb)
                                    ),
                                    child: const Text('D#/E\u266D',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[7] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('E')){
                                        setState(() {
                                          colorE = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorE = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorE),
                                    ),
                                    child: const Text('E',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[8] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('F')){
                                        setState(() {
                                          colorF = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorF = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorF)
                                    ),
                                    child: const Text('F',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[9] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('Gb')){
                                        setState(() {
                                          colorGb = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorGb = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorGb)
                                    ),
                                    child: const Text('F#/G\u266D',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[10] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('G')){
                                        setState(() {
                                          colorG = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorG = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorG)
                                    ),
                                    child: const Text('G',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                            const SizedBox(width: 5.0,),
                            Visibility(
                                visible: selectedNotes[11] && !isStart,
                                child: ElevatedButton(
                                    onPressed: (){
                                      if(checkAnswer('Ab')){
                                        setState(() {
                                          colorAb = colorRight;
                                          rightAnswer();
                                        });
                                      }else{
                                        setState(() {
                                          colorAb = colorWrong;
                                          wrongAnswer();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(75,40)),
                                        backgroundColor: MaterialStateProperty.all(colorAb)
                                    ),
                                    child: const Text('G#/A\u266D',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1) ),)
                                )
                            ),
                          ]
                        )
                      ],
                    ),
                    const SizedBox(width: 80.0,),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Octaves',
                          style: TextStyle(
                              color: Color.fromRGBO(94, 190, 196, 1),
                              fontSize: 20.0,
                          ),
                        ),

                        RangeSlider(
                          values: currentRangeValues,
                          onChanged: (RangeValues values) {
                            setState(() {
                              currentRangeValues = values;
                              updateAllSounds();
                            });
                          },
                          activeColor: Color.fromRGBO(94, 190, 196, 1),
                          max: 7,
                          divisions: 6,
                          min: 1,
                          labels: RangeLabels(
                            currentRangeValues.start.round().toString(),
                            currentRangeValues.end.round().toString(),
                          ),
                        ),
                        const SizedBox(height: 35.0,),
                        ToggleButtons(
                          direction: Axis.vertical,
                          onPressed: (int index) {
                            // All buttons are selectable.
                            setState(() {
                              selectedNotes[index] = !selectedNotes[index];
                              switch(index){
                                case 0:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['A']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['A']!);
                                  }
                                  break;
                                case 1:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['Bb']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['Bb']!);
                                  }
                                  break;
                                case 2:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['B']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['B']!);
                                  }
                                  break;
                                case 3:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['C']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['C']!);
                                  }
                                  break;
                                case 4:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['Db']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['Db']!);
                                  }
                                  break;
                                case 5:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['D']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['D']!);
                                  }
                                  break;
                                case 6:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['Eb']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['Eb']!);
                                  }
                                  break;
                                case 7:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['E']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['E']!);
                                  }
                                  break;
                                case 8:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['F']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['F']!);
                                  }
                                  break;
                                case 9:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['Gb']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['Gb']!);
                                  }
                                  break;
                                case 10:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['G']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['G']!);
                                  }
                                  break;
                                case 11:
                                  if(!selectedNotes[index]){
                                    selectedPossibleSounds = removeSound(selectedPossibleSounds, all_sounds['Ab']!);
                                  }else{
                                    selectedPossibleSounds.addAll(all_sounds['Ab']!);
                                  }
                                  break;
                              }
                              print(selectedPossibleSounds);
                              print(selectedNotes);
                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Color.fromRGBO(94, 190, 196, 1),
                          selectedColor: Colors.white,
                          fillColor: Color.fromRGBO(94, 190, 196, 1),
                          color: Color.fromRGBO(94, 190, 196, 1),
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          isSelected: selectedNotes,
                          children: notes,
                        ),
                      ],
                    ),
                  ],
                )
            ),
        ),
      ),
    );
  }
}

List<String> removeSound(List<String> _selectedPossibleSounds, List<String> _letterSounds){
  var set1 = Set.from(_selectedPossibleSounds);
  var set2 = Set.from(_letterSounds);
  return List.from(set1.difference(set2));
}