import 'package:flutter/material.dart';
import 'package:flutter_os_wear/utils.dart';
import 'package:flutter_os_wear/wear.dart';
import 'package:workmanager/workmanager.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String taskName = "vibrationTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
     // if ( Vibration.hasVibrator() ?? false) {
     final prefs = await  SharedPreferences.getInstance();
       prefs.setString('lastVibration', DateTime.now().minute.toString());
        Vibration.vibrate();
      //}
      print("Background vibration triggered.");
    }
    return Future.value(true);
  });
}

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  //Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(StartScreen());
}


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
  int count = 0;
  bool timerStatus = false;

  @override
void initState() {
  super.initState();
  _loadLastVibration();
}

void _loadLastVibration() async {
  final prefs = await SharedPreferences.getInstance();
  final last = prefs.getString('lastVibration');
  if (last != null) {
    setState(() {
      _text = "Last: ${last}";
    });
  }
}

  void _toggleTask()  {
    setState(() {
      timerStatus = !timerStatus;
    });
Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    if (timerStatus) {
       Workmanager().registerPeriodicTask(
        "uniqueTaskId",
        taskName,
        frequency: Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
      setState(() {
        //_text = "Started";
        _boxColor = Colors.green;
      });
    } else {
       Workmanager().cancelByUniqueName("uniqueTaskId");
      setState(() {
       // _text = "Stopped";
        _boxColor = Colors.red;
      });
    }
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
            screenSize = Size(
              boxInsetLength(screenSize.width / 2),
              boxInsetLength(screenSize.height / 2),
            );
          }

          return Center(
            child: Container(
              color: Colors.black,
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    color: _boxColor,
                    child: Text(
                      _text,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.blue[900]),
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(6),
                    ),
                    child: Text(
                      timerStatus ? 'STOP' : 'START',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: _toggleTask,
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
