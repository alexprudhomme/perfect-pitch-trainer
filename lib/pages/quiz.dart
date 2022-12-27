import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../helpers/sounds.dart';

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
  bool isNoteRight = false;
  final List<bool> selectedNotes = <bool>[false, false, false, true, false, true,
                                          false, true, false, false, false, false];
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

  void rightAnswer(){
    AudioPlayer player=AudioPlayer();
    Source source = AssetSource('sounds/right.mp3');
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
    AudioPlayer player=AudioPlayer();
    final random = Random();
    String note = selectedPossibleSounds[random.nextInt(selectedPossibleSounds.length)];
    Source source = AssetSource('sounds/$note');
    player.play(source);
    currentNote = note;
  }
  void playCurrentNote(){
    AudioPlayer player=AudioPlayer();
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
    print(progressBarDenominator);
    print(progressBarNumerator);
    print(progressBar);
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
                    ToggleButtons(
                      direction: Axis.vertical,
                      onPressed: (int index) {
                        // All buttons are selectable.
                        setState(() {
                          selectedNotes[index] = !selectedNotes[index];
                          switch(index){
                            case 0:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, A_sounds);
                              }else{
                                selectedPossibleSounds.addAll(A_sounds);
                              }
                              break;
                            case 1:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, Bb_sounds);
                              }else{
                                selectedPossibleSounds.addAll(Bb_sounds);
                              }
                              break;
                            case 2:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, B_sounds);
                              }else{
                                selectedPossibleSounds.addAll(B_sounds);
                              }
                              break;
                            case 3:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, C_sounds);
                              }else{
                                selectedPossibleSounds.addAll(C_sounds);
                              }
                              break;
                            case 4:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, Db_sounds);
                              }else{
                                selectedPossibleSounds.addAll(Db_sounds);
                              }
                              break;
                            case 5:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, D_sounds);
                              }else{
                                selectedPossibleSounds.addAll(D_sounds);
                              }
                              break;
                            case 6:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, Eb_sounds);
                              }else{
                                selectedPossibleSounds.addAll(Eb_sounds);
                              }
                              break;
                            case 7:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, E_sounds);
                              }else{
                                selectedPossibleSounds.addAll(E_sounds);
                              }
                              break;
                            case 8:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, F_sounds);
                              }else{
                                selectedPossibleSounds.addAll(F_sounds);
                              }
                              break;
                            case 9:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, Gb_sounds);
                              }else{
                                selectedPossibleSounds.addAll(Gb_sounds);
                              }
                              break;
                            case 10:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, G_sounds);
                              }else{
                                selectedPossibleSounds.addAll(G_sounds);
                              }
                              break;
                            case 11:
                              if(!selectedNotes[index]){
                                selectedPossibleSounds = removeSound(selectedPossibleSounds, Ab_sounds);
                              }else{
                                selectedPossibleSounds.addAll(Ab_sounds);
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