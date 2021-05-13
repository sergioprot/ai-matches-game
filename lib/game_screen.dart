import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matches_game/game_init.dart';
import 'package:matches_game/match.dart';
import 'package:matches_game/matches_radio.dart';
import 'package:matches_game/node.dart';
import 'package:matches_game/text_constants.dart';

/// Game screen
///
/// Here user sees current game state.
/// He can see, whose turn is it now, how many matches left, how many matches are chosen on this turn.
///
/// If the current turn is user turn, then he can choose, how many matches to take.
/// Otherwise, he can see AI turn. It lasts 2 seconds to show some animation.
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// If [isAiTurn] is true, then current turn is AI turn.
  /// Otherwise, current turn is user turn.
  bool isAiTurn = false;

  /// Current matches number. -1 just means uninitialized. It will be initialized later.
  int matchesCount = -1;

  /// Current chosen matches number.
  MatchesRadio? matchesRadio = MatchesRadio.one;

  /// Initial game state.
  bool initIsAiTurn = false;
  int initMatchesCount = -1;

  /// Graph roots for game start [initNode] and for game current state [currentNode].
  late Node initNode;
  late Node currentNode;

  /// Initialize game screen.
  @override
  void initState() {
    super.initState();
    isAiTurn = false;
    matchesCount = -1;
    initIsAiTurn = false;
    initMatchesCount = -1;
    matchesRadio = MatchesRadio.one;
  }

  /// Set chosen matches count and rebuild screen.
  void setMatchesRadio(MatchesRadio? value) {
    setState(() {
      matchesRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Get arguments provided from HomeScreen.
    if (ModalRoute.of(context) != null) {
      final GameInit gameInit = ModalRoute.of(context)!.settings.arguments as GameInit;
      initMatchesCount = gameInit.initMatchesCount;
      initIsAiTurn = gameInit.isAiTurnFirst;
      initNode = Node.createAndEvaluate(matches: initMatchesCount);
    }
    if (matchesCount == -1) {
      /// Game has just started
      startGame();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.matchesGame),
        actions: [
          /// Button to restart game with the same settings.
          IconButton(
            icon: Icon(
              Icons.replay,
              size: 28.0,
            ),
            onPressed: () => startGame(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Headline - Your turn / AI turn / You won / You lose
            Center(
              child: Text(
                  isAiTurn
                      ? (matchesCount > 0)
                          ? TextConstants.aiTurn
                          : TextConstants.youLose
                      : (matchesCount > 0)
                          ? TextConstants.yourTurn
                          : TextConstants.youWin,
                  style: (matchesCount > 0)
                      ? Theme.of(context).textTheme.headline1
                      : isAiTurn
                          ? Theme.of(context).textTheme.headline1?.copyWith(color: Colors.red)
                          : Theme.of(context).textTheme.headline1?.copyWith(color: Colors.green)),
            ),

            /// Row with matches.
            ///
            /// All matches are light, except 1, 2 or 3 that are currently chosen to take away.
            Container(
              height: 180,
              child: GridView.count(
                crossAxisCount: 15,
                childAspectRatio: ((MediaQuery.of(context).size.width - 64) / 15) / 90,
                children: [
                  if (matchesCount > 0)
                    for (int i in List.generate(matchesCount - getPickedMatches(), (index) => index)) Match(),
                  if (matchesCount > 0)
                    for (int i in List.generate(getPickedMatches(), (index) => index)) Match(selected: true),
                ],
              ),
            ),
            Text(
              TextConstants.iTake,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            /// Radio buttons to choose matches to take away.
            Column(
              children: [
                RadioListTile<MatchesRadio>(
                  value: MatchesRadio.one,
                  groupValue: matchesRadio,
                  onChanged: (isAiTurn || (matchesCount < 1)) ? null : (MatchesRadio? value) => setMatchesRadio(value),
                  title: Text(TextConstants.oneMatch),
                ),
                RadioListTile<MatchesRadio>(
                  value: MatchesRadio.two,
                  groupValue: matchesRadio,
                  onChanged: (isAiTurn || (matchesCount < 2)) ? null : (MatchesRadio? value) => setMatchesRadio(value),
                  title: Text(TextConstants.twoMatches),
                ),
                RadioListTile<MatchesRadio>(
                  value: MatchesRadio.three,
                  groupValue: matchesRadio,
                  onChanged: (isAiTurn || (matchesCount < 3)) ? null : (MatchesRadio? value) => setMatchesRadio(value),
                  title: Text(TextConstants.threeMatches),
                ),
              ],
            ),

            /// Button to finish user turn
            Center(
              child: ElevatedButton(
                onPressed: (isAiTurn || (matchesCount <= 0)) ? null : () => humanTurn(),
                child: Text(TextConstants.ok),
              ),
            ),
            // ],
          ],
        ),
      ),
    );
  }

  /// Get picked matches count.
  int getPickedMatches() {
    switch (matchesRadio) {
      case MatchesRadio.one:
        return 1;
      case MatchesRadio.two:
        return 2;
      case MatchesRadio.three:
        return 3;
      case null:
        return 0;
    }
  }

  /// Get [MatchesRadio] based on picked matches count
  MatchesRadio? getMatchesRadio(int selected) {
    switch (selected) {
      case 1:
        return MatchesRadio.one;
      case 2:
        return MatchesRadio.two;
      case 3:
        return MatchesRadio.three;
      default:
        return null;
    }
  }

  /// Starts the game.
  ///
  /// Sets [matchesCount], [isAiTurn], [currentNode] to initial ones.
  /// If AI goes first, starts its' turn.
  void startGame() {
    setState(() {
      matchesCount = initMatchesCount;
      isAiTurn = initIsAiTurn;
      currentNode = initNode;
    });

    if (isAiTurn) {
      aiTurn();
    }
  }

  /// AI makes turn.
  ///
  /// Gets best move according to current state in graph [currentNode].
  /// Then waits for a second and animates decision (colors last 1/2/3 matches).
  /// Then waits for one more second and removes chosen amount of matches.
  /// Then user can make his turn.
  Future<void> aiTurn() async {
    Node newNode = currentNode.getBestMove();
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        matchesRadio = getMatchesRadio(currentNode.matches - newNode.matches);
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        currentNode = newNode;
        matchesCount = currentNode.matches;
        isAiTurn = false;
        matchesRadio = MatchesRadio.one;
      });
    });
  }

  /// Updates game state according to user decision.
  ///
  /// Sets updated [matchesCount], [isAiTurn], [matchesRadio],
  /// updates current node in graph [currentNode].
  ///
  /// If game is not finished yet, AI makes its' turn.
  void humanTurn() {
    setState(() {
      currentNode = currentNode.getNextNode(getPickedMatches());
      matchesCount -= getPickedMatches();
      isAiTurn = true;
      matchesRadio = MatchesRadio.one;
    });
    if (matchesCount > 0) {
      aiTurn();
    }
  }
}
