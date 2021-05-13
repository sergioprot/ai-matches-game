import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matches_game/game_init.dart';
import 'package:matches_game/text_constants.dart';

/// Home Screen.
///
/// Screen that user sees when opening the app.
/// Here user can see game rules, select initial matches count
/// and choose who will go first - user or AI.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Minimum, maximum and chosen matches counts.
  static const int matchesCountMin = 7;
  static const int matchesCountMax = 30;
  int matchesCount = matchesCountMin;

  /// Is AI selected to go first
  bool isAiSelected = false;

  /// Set initial screen state.
  @override
  void initState() {
    super.initState();
    matchesCount = matchesCountMin;
    isAiSelected = false;
  }

  /// Set [matchesCount] & rebuild screen
  void setMatchesCount(double value) {
    setState(() {
      matchesCount = value.toInt();
    });
  }

  /// Set [isAiSelected] and rebuild screen
  void setAiSelected(bool value) {
    setState(() {
      isAiSelected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Headline
            Center(
              child: Text(
                TextConstants.matchesGame,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),

            /// Rules
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: TextConstants.rules + ': ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: TextConstants.rulesText,
                  ),
                ],
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              maxLines: 5,
            ),

            /// Divider
            Divider(),

            /// Chosen matches count
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: TextConstants.matchesCount + ': ',
                  ),
                  TextSpan(
                    text: "$matchesCount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            /// Slider to choose initial matches count
            Slider(
              value: matchesCount.toDouble(),
              onChanged: (newValue) => setMatchesCount(newValue),
              divisions: matchesCountMax - matchesCountMin,
              min: matchesCountMin.toDouble(),
              max: matchesCountMax.toDouble(),
            ),

            Text(
              TextConstants.firstPlayer + ':',
            ),

            /// Switcher to choose the first player
            Row(
              children: [
                Expanded(
                  child: Text(
                    TextConstants.human,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: isAiSelected ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: Switch(
                    value: isAiSelected,
                    onChanged: (newValue) => setAiSelected(newValue),
                    inactiveTrackColor: Colors.black26,
                    activeTrackColor: Colors.black26,
                    inactiveThumbColor: Colors.black54,
                    activeColor: Colors.black54,
                    thumbColor: MaterialStateProperty.all<Color>(Theme.of(context).toggleableActiveColor),
                  ),
                ),
                Expanded(
                  child: Text(
                    TextConstants.ai,
                    style: TextStyle(
                      fontWeight: isAiSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),

            /// Button to start the game
            Center(
              child: ElevatedButton(
                onPressed: () {
                  GameInit gameInit = GameInit(isAiSelected, matchesCount);
                  Navigator.of(context).pushNamed('/game', arguments: gameInit);
                },
                child: Text(
                  TextConstants.play,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
