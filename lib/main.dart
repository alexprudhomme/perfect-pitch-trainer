import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:perfect_pitch_trainer/pages/loading.dart';
import 'package:perfect_pitch_trainer/pages/quiz.dart';



void main() {
  runApp(MaterialApp(
    title: 'Perfect Pitch Trainer',
    theme: ThemeData(
        useMaterial3: true
    ),
    initialRoute: '/',
    routes: {
      '/loading': (context) => Loading(),
      '/' : (context) => Quiz(),
    },
    ),
  );
}


/*if(selectedNotes[index]){
var set1 = Set.from(selectedPossiblesSounds);
var set2 = Set.from(A_sounds);
selectedPossiblesSounds = List.from(set1.difference(set2));
}else{
selectedPossiblesSounds.addAll(A_sounds);
}*/







