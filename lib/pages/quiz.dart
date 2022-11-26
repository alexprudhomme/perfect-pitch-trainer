import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  final List<bool> selectedNotes = <bool>[false, false, false, true, false, true,
                                          false, true, false, false, false, false];
  late String currentNote;
  late List<String> selectedPossibleSounds = <String>['C2.mp3', 'C3.mp3', 'C4.mp3',
    'C5.mp3', 'C6.mp3', 'D2.mp3', 'D3.mp3', 'D4.mp3', 'D5.mp3', 'D6.mp3', 'E2.mp3',
    'E3.mp3', 'E4.mp3', 'E5.mp3', 'E6.mp3',];
  bool isStart = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/clara.png'),
                  fit: BoxFit.cover,
                )
            ),
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            isStart ? playRandomNote(): playCurrentNote();
                            setState((){
                              isStart = false;
                            });
                          },
                          child: Text(
                            isStart ? 'Start': 'Hear Again'
                          ),
                        ),
                        ElevatedButton(onPressed: (){}, child: Text('A'))
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
                      selectedBorderColor: Colors.green[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.green[200],
                      color: Colors.green[400],
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: selectedNotes,
                      children: notes,
                    ),
                  ],
                )
            )
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