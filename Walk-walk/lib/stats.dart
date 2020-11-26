import 'dart:async';
import 'package:daily_steps/achievement.dart';
import 'package:daily_steps/dailySteps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:google_fonts/google_fonts.dart';
//Fimport 'package:achievement_view/achievement_view.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  Box<int> stepsBox = Hive.box('steps');
  int todaySteps;
  int coinCountKey = 9999999;
  int savedKeyValue = 999;
  int coin = 0;
  int updatelastcoin = 0;

  final Color carbonBlack = Color(0xff1a1a1a);

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: carbonBlack,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Walk-walk",
          style: GoogleFonts.darkerGrotesque(fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Card(
              color: Colors.black87.withOpacity(0.7),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 30,
                  right: 20,
                  left: 20,
                ),
                child: Column(
                  children: <Widget>[
                    gradientShaderMask(
                      child: Text(
                        //todaySteps?.toString() ?? '0'
                        stepsBox
                                .get(savedKeyValue, defaultValue: 0)
                                ?.toString() ??
                            '0',
                        style: GoogleFonts.darkerGrotesque(
                          fontSize: 80,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      "Total Steps",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 105.0,
        child: Row(
          children: <Widget>[
            Container(
              width: 225,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.lightBlueAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(
                          left: 50.0, right: 50.0, bottom: 20.0, top: 20.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AchiPage();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Achievement',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 185,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(
                          left: 50.0, right: 50.0, bottom: 20.0, top: 20.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DailyStepsPage();
                            },
                          ),
                        );
                      },
                      child: const Text('Daily Step',
                          style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  Widget gradientShaderMask({@required Widget child}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.lightBlueAccent.shade700,
          Colors.blueAccent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }

  void startListening() {
    _pedometer = Pedometer();
    _subscription = _pedometer.pedometerStream.listen(
      getTodaySteps,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  Future<int> getTodaySteps(int value) async {
    //print(value);
    int savedStepsCountKey = 999999;
    //int count200 = 0;
    int savedStepsCount = stepsBox.get(savedStepsCountKey, defaultValue: 0);

    stepsBox.put(savedKeyValue, value);

    int todayDayNo = Jiffy(DateTime.now()).dayOfYear;
    if (value < savedStepsCount) {
      // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
      savedStepsCount = 0;
      // persist this value using a package of your choice here
      stepsBox.put(savedStepsCountKey, savedStepsCount);
    }

    // load the last day saved using a package of your choice here
    int lastDaySavedKey = 888888;
    int lastDaySaved = stepsBox.get(lastDaySavedKey, defaultValue: 0);

    // When the day changes, reset the daily steps count
    // and Update the last day saved as the day changes.
    if (lastDaySaved < todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      stepsBox
        ..put(lastDaySavedKey, lastDaySaved)
        ..put(savedStepsCountKey, savedStepsCount);
    }

    setState(() {
      todaySteps = value - savedStepsCount;
    });
    stepsBox.put(todayDayNo, todaySteps);

    coin = stepsBox.get(coinCountKey, defaultValue: 0);
    /*count200 += (todaySteps - count200);
    if ((count200 / (200 * (coin + 1))) >= 1) {
      coin += 1;
    }*/
    //coin = (value / 200).floor();
    if ((todaySteps - updatelastcoin) >= 200) {
      updatelastcoin = (todaySteps ~/ 200) * 200;
      coin += 1;
    }
    stepsBox.put(coinCountKey, coin);
    print('stats | todaySteps : $todaySteps | coin : $coin');
    //print('value : $value | savedStepsCount : $savedStepsCount');

    return todaySteps; // this is your daily steps value.
  }

  void stopListening() {
    _subscription.cancel();
  }
}
