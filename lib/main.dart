
import 'package:flutter/material.dart';
import 'package:flutter_os_wear/screens/ambient_screen.dart';
import 'package:flutter_os_wear/screens/start_screen.dart';
import 'package:flutter_os_wear/wear.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Timer Wear App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WatchScreen(),
        debugShowCheckedModeBanner: false,
      );
}

class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WatchShape(
        builder: (context, shape) => InheritedShape(
              shape: shape?? Shape.values.first,
              child: AmbientMode(
                builder: (context, mode) =>
                    mode == Mode.active ? StartScreen() : AmbientWatchFace(),
                    
              ),
            ),
      );
}