import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matches_game/game_screen.dart';
import 'package:matches_game/home_screen.dart';

class MatchesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matches',
      routes: {
        '/': (context) => HomeScreen(),
        '/game': (context) => GameScreen(),
      },
      theme: ThemeData(
        /// Main colors
        backgroundColor: Colors.yellow.shade50,
        scaffoldBackgroundColor: Colors.amber.shade50,
        primaryColor: Colors.deepOrangeAccent,
        toggleableActiveColor: Colors.deepOrange,

        /// Text themes
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            fontSize: 16.0,
            height: 1.4,
          ),
        ).apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),

        /// Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              Size(256, 48),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return Colors.deepOrangeAccent;
            }),
          ),
        ),

        /// Slider theme
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.orangeAccent,
          inactiveTrackColor: Colors.black26,
          thumbColor: Colors.deepOrange,
        ),
      ),
    );
  }
}
