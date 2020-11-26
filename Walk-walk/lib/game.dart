import 'dart:async';
import 'dart:math';
import 'package:daily_steps/dailySteps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sensors/sensors.dart';
import 'package:flare_flutter/flare_actor.dart';
//import 'package:achievement_view/achievement_view.dart';

class MyGame extends StatefulWidget {
  MyGameState createState() => MyGameState();
}

class MyGameState extends State<MyGame> with TickerProviderStateMixin {
  createPopups(BuildContext context, String x) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(
              x,
              style: TextStyle(fontSize: 36, color: Colors.white),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
/*
  liveFull(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(
              "  Live is Full",
              style: TextStyle(fontSize: 36, color: Colors.white),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  coinNotenough(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(
              "  Coins not Enough",
              style: TextStyle(fontSize: 36, color: Colors.white),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }*/

  Animation<double> bulletAnimation, targetAnimation;
  AnimationController bulletController, targetController;
  double bulletYPoint = 0,
      targetYPoint = 0,
      bulletXPoint = 0,
      targetXPoint = 0,
      x = 0;
  int count = 1;
  int endGame = 0;
  Box<int> highScore = Hive.box('steps');
  int highScoreKey = 12345;
  int heartKey = 444444;
  // ignore: non_constant_identifier_names
  int tmp_heart;
  int coinCountKey = 9999999;
  int boughtKey = 987654321;
  static Box<int> countHeart = Hive.box('steps');

  var rand = Random();
  static const Color white = Colors.white;
  Widget box = Container(height: 30, width: 30, color: white);
  void init() {
    bulletController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    accelerometerEvents.listen((AccelerometerEvent event) {
      if ((-x * 5 - event.x).abs() > 0.1) {
        if (event.x < -5)
          stream.addValue(1);
        else if (event.x > 5)
          stream.addValue(-1);
        else {
          x = -double.parse(event.x.toStringAsFixed(1)) / 5;
          stream.addValue(x);
        }
      }
    });
    initialize();
  }

  void initialize() {
    bulletYPoint = 1;
    targetYPoint = -1;
    bulletAnimation = Tween(begin: 1.0, end: -1.0).animate(bulletController)
      ..addStatusListener((event) {
        if (event == AnimationStatus.completed) {
          bulletController.reset();
          bulletController.forward();
        }
      })
      ..addListener(() {
        stream.bulletStream.add(bulletAnimation.value);
      });
    bulletController.forward();
    targetController = AnimationController(
        duration:
            Duration(milliseconds: count < 45 ? 10000 - (count * 200) : 1000),
        vsync: this);
    targetAnimation = Tween(begin: -1.0, end: 1.0).animate(targetController)
      ..addListener(() {
        setState(() {
          targetYPoint = targetAnimation.value;
        });
        if (targetAnimation.value == 1) {
          endGame = 2;
        }
      });
    targetController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (bulletXPoint > targetXPoint - 0.15 &&
        bulletXPoint < targetXPoint + 0.15) {
      if (bulletYPoint < targetYPoint) {
        setState(() {
          count++;
          int tmp = countHeart.get(highScoreKey, defaultValue: 3);
          if ((count - 1) > tmp) {
            countHeart.put(highScoreKey, count - 1);
          }
          print('coin : ${DailyStepsPageState.coin}');
          if (rand.nextBool())
            targetXPoint = rand.nextDouble();
          else
            targetXPoint = -rand.nextDouble();
        });
        bulletController.reset();
        initialize();
      }
    }

    if (endGame == 1 && bulletAnimation.value == 1) {
      bulletXPoint = x;
    }
    if (endGame == 2) {
      tmp_heart = highScore.get(heartKey, defaultValue: 3);
      if (tmp_heart > 0) {
        tmp_heart -= 1;
        print(tmp_heart);
        highScore.put(heartKey, tmp_heart);
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(children: <Widget>[
        Image.asset(
          "assets/space.png",
          alignment: Alignment.center,
          height: 2500.0,
          width: 2000.0,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DailyStepsPage();
                        },
                      ),
                    );
                  }),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                alignment: Alignment.centerLeft,
                child: Image.asset("assets/dollar (1).png"),
              ),
              Container(
                  padding: EdgeInsets.only(right: 150.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '${DailyStepsPageState.coin - DailyStepsPageState.bought_coin.get(boughtKey, defaultValue: 0)}',
                      style: TextStyle(color: Colors.white, fontSize: 24))),
              Container(
                padding: EdgeInsets.only(right: 5.0, left: 45.0),
                alignment: Alignment.centerLeft,
                child: Image.asset("assets/heart.png"),
              ),
              Container(
                  padding: EdgeInsets.only(right: 5.0),
                  alignment: Alignment.centerLeft,
                  child: Text('${highScore.get(heartKey, defaultValue: 3)}',
                      style: TextStyle(color: Colors.white, fontSize: 24))),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          endGame = 0;

                          int tmp = DailyStepsPageState.stepsBox
                              .get(coinCountKey, defaultValue: 0);
                          int cntHeart =
                              countHeart.get(heartKey, defaultValue: 3);
                          int bought = DailyStepsPageState.bought_coin
                              .get(boughtKey, defaultValue: 0);
                          if (DailyStepsPageState.stepsBox
                                  .get(999, defaultValue: 0) ==
                              0) {
                            DailyStepsPageState.bought_coin.put(boughtKey, 0);
                          }
                          if (cntHeart < 3) {
                            if ((tmp - bought) < 5) {
                              //return createPopups(context, "  Coins not Enough");
                              print('coin not enough');
                            } else {
                              countHeart.put(heartKey, cntHeart + 1);
                              DailyStepsPageState.bought_coin
                                  .put(boughtKey, bought + 5);
                            }
                          } else {
                            //return createPopups(context, "  Live is Full");
                            print('live is full');
                          }
                          return MyGame();
                        },
                      ),
                    );
                  })
            ],
          ),
          body: endGame != 1
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 150.0),
                        child: Text(
                          "Space Shooter",
                          style: TextStyle(color: white, fontSize: 52),
                        ),
                      ),
                      Container(
                          height: 160,
                          width: 140,
                          child: Image.asset("assets/space-shuttle (2).png")),
                      Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Text(
                          "High Score : ${countHeart.get(highScoreKey, defaultValue: 0)?.toString() ?? '0'}",
                          style: TextStyle(color: white, fontSize: 36),
                        ),
                      ),
                      Text(
                        endGame == 2 ? "Score:${count - 1}" : "",
                        style: TextStyle(color: white, fontSize: 36),
                      ),
                      GestureDetector(
                        onTap: () {
                          tmp_heart = countHeart.get(heartKey, defaultValue: 3);
                          if (tmp_heart > 0) {
                            init();
                            endGame = 1;
                            count = 1;
                            initialize();
                          } else {
                            createPopups(context, "  Need More Live");
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          child: (endGame == 2)
                              ? Icon(
                                  Icons.refresh,
                                  color: white,
                                  size: 62,
                                )
                              : FlareActor("assets/play_button.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  animation: "animate"),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                        child: Stack(children: <Widget>[
                      Align(
                        alignment: Alignment(0.8, -0.9),
                        child: Text(
                          "Score: ${count - 1}",
                          style: TextStyle(fontSize: 32, color: white),
                        ),
                      ),
                      StreamBuilder(
                        initialData: 1.0,
                        stream: stream.bulletStreamGet,
                        builder: (context, stream) {
                          bulletYPoint = stream.data;
                          return Align(
                              alignment: Alignment(bulletXPoint, stream.data),
                              child:
                                  //  Icon(Icons.arrow_upward)
                                  Container(
                                width: 15,
                                child: FlareActor("assets/bullet.flr",
                                    alignment:
                                        Alignment(bulletXPoint, stream.data),
                                    fit: BoxFit.fitWidth,
                                    animation: "float"),
                              ));
                        },
                      ),
                      Align(
                        alignment: Alignment(targetXPoint, targetYPoint),
                        child: Container(
                          height: 100,
                          width: 60,
                          child: Image.asset("assets/alien (2).png"),
                          alignment: Alignment(targetXPoint, targetYPoint),
                        ),
                      )
                    ])),
                    StreamBuilder(
                      initialData: 0.0,
                      stream: stream.shooterStreamGet,
                      builder: (ctx, stream) {
                        x = stream.data;
                        return Align(
                          alignment: Alignment(stream.data, 1),
                          child: Container(
                            width: 60,
                            height: 20,
                            child: FlareActor("assets/earth.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.fitWidth,
                                animation: "Preview2"),
                          ),
                          //box
                        );
                      },
                    )
                  ],
                ),
        ),
      ]),
    );
  }
}

class Streams {
  StreamController shooterStreamController =
          StreamController<double>.broadcast(),
      bulletStreamController = StreamController<double>.broadcast();

  Sink get shooterStream => shooterStreamController.sink;
  Sink get bulletStream => bulletStreamController.sink;

  Stream<double> get shooterStreamGet => shooterStreamController.stream;
  Stream<double> get bulletStreamGet => bulletStreamController.stream;

  addValue(double value) {
    shooterStream.add(value);
  }

  addBulletValue(double value) {
    bulletStream.add(value);
  }

  voiddispose() {
    shooterStreamController.close();
    bulletStreamController.close();
  }
}

Streams stream = Streams();
