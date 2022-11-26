import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void animationTime() async{
    await Future.delayed(Duration(seconds:2));
    Navigator.pushReplacementNamed(context, '/quiz');

  }
  @override
  void initState(){
    super.initState();
    animationTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 70.0),
      ),
    );
  }
}
