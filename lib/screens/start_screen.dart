import 'package:flutter/material.dart'; 
import 'package:flutter_os_wear/utils.dart';
import 'package:flutter_os_wear/wear.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';
class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ColorChanger());
  }
}

class ColorChanger extends StatefulWidget {
  @override
  _ColorChangerState createState() => _ColorChangerState();
}
class _ColorChangerState extends State<ColorChanger> {
            Color _boxColor = Colors.grey;
            String _text = "0";
            int count=0;
            var timerstatus=false;
            late Timer _timer;
   void _changeBox() {
              setState(() {
                if(_timer.isActive){
                   _timer.cancel();
                 }
                 else{_startTimer();}
                timerstatus=!timerstatus;
              });
            }

            @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      try {
    setState(() {
       setState(() {
        Vibration.vibrate(preset: VibrationPreset.quickSuccessAlert);

        count++;
        _text = "${count }";
      });
    });
  } catch (e, stack) {
     setState(() {
       setState(() {
        count++;
        _text = " error ${count }";
      });
    });
  }
     
    });
  }

  @override
  void dispose() {
    setState(() {
        _text = "Cancelled ${count + 1}";
      });
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WatchShape(
        builder: (context, shape) {
          var screenSize = MediaQuery.of(context).size;
          final shape = InheritedShape.of(context)!.shape;
          if (shape == Shape.round) {
            // boxInsetLength requires radius, so divide by 2
            screenSize = Size(boxInsetLength(screenSize.width / 2),
                boxInsetLength(screenSize.height / 2));
          }
          var screenHeight = screenSize.height;
          var screenWidth = screenSize.width;       

           
          return Center(
            child: Container(
              color: Colors.black,
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
              padding: EdgeInsets.all(16),
              color: _boxColor,
              child: Text(
                _text,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
                  //FlutterLogo(size: 90),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.blue[900]),
    backgroundColor: MaterialStateProperty.all(Colors.teal),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    elevation:MaterialStateProperty.all(6),
    
                ),
                   // highlightColor: Colors.blue[900],
                //    elevation: 6.0,
                    child: Text(
                      'START',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    // color: Colors.blue[400],
                    onPressed: _changeBox,
                    // onPressed: () {
                    
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) {
                    //       return NameScreen(screenHeight, screenWidth);
                    //     }),
                    //   );
                    // },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
