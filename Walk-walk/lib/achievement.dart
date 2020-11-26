import 'package:daily_steps/dailySteps.dart';
import 'package:daily_steps/stats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class AchiPage extends StatefulWidget {
  @override
  AchiPageState createState() => AchiPageState();
}

class AchiPageState extends State<AchiPage> {
  int coinCountKey = 9999999;
  // ignore: non_constant_identifier_names
  Box<int> mark_check = Hive.box('steps');

  String daily(int step, int money) {
    //DailyStepsPageState.bought_coin.put(987654321, 0);
    //restart use this code
    int dailysteps = DailyStepsPageState.todaySteps;
    if (dailysteps >= step) {
      int mark = mark_check.get(step, defaultValue: 0);
      print('Before step: $step | mark: $mark');
      if (mark == 0) {
        int tmp =
            DailyStepsPageState.stepsBox.get(coinCountKey, defaultValue: 0);
        print('A | tmp: $tmp | coin_plus: ${tmp + money}');

        DailyStepsPageState.stepsBox.put(coinCountKey, tmp + money);
        tmp = DailyStepsPageState.stepsBox.get(coinCountKey, defaultValue: 0);
        print('B | tmp: $tmp');
        mark_check.put(step, step);
      }
      print('After step: $step | mark: $mark');
      return "Completed";
    } else {
      mark_check.put(step, 0);
      print(
          'Else step: $step | mark: ${mark_check.get(step, defaultValue: 0)}');
      return "Uncomplete";
    }
  }

  String total(int step, int money) {
    int savedKeyValue = 999;
    int totalsteps =
        DailyStepsPageState.stepsBox.get(savedKeyValue, defaultValue: 0);
    if (totalsteps >= step) {
      int mark = mark_check.get(step, defaultValue: 0);
      if (mark == 0) {
        int tmp =
            DailyStepsPageState.stepsBox.get(coinCountKey, defaultValue: 0);
        DailyStepsPageState.stepsBox.put(coinCountKey, tmp + money);
        mark_check.put(step, step);
      }
      return "Completed";
    } else {
      mark_check.put(step, 0);
      return "Uncomplete";
    }
  }

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.darkerGrotesqueTextTheme(
            Theme.of(context).textTheme,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.darkerGrotesqueTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Achievement"), // title of appbar
            ),
            body: getListView(),
            bottomNavigationBar: Container(
              height: 105.0,
              child: Row(children: <Widget>[
                Container(
                  width: 400,
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
                                  return StatsPage();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Total Steps',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ), //list widget function is been called
              ]),
            ))));
  }

  Widget getListView() {
    var listview = ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "100 Daily Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            daily(100, 1),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('1 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "500 Daily Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            daily(500, 5),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('5 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "1,000 Daily Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            daily(1000, 10),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('10 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "2,000 Daily Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            daily(2000, 20),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('20 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "5,000 Daily Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            daily(5000, 50),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('50 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "50,000 Total Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            total(50000, 500),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('500 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "100,000 Total Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            total(100000, 1000),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('1000 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(
            "500,000 Total Steps",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            total(500000, 5000),
            style: TextStyle(color: Colors.red),
          ),
          trailing: Text('5000 coin',
              style: TextStyle(color: Colors.green, fontSize: 24.0)),
        )
      ],
    );
    return listview;
  }
}
