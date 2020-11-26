//import 'package:daily_steps/start.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:achievement_view/achievement_view.dart';

import 'package:daily_steps/dailySteps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<int>('steps');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(DailyStepsPageState.stepsBox.get(9999999, defaultValue: 0));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Walk-walk',
      home: DailyStepsPage(),
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
    );
  }
}
