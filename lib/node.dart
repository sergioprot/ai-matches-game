import 'package:matches_game/level.dart';
import 'package:matches_game/node_matrix.dart';

/// Game graph node.
///
/// Represents one of possible game states.
class Node {
  /// Matches count
  final int matches;

  /// Level - MIN or MAX. Used for Minimax algorithm
  final Level level;

  /// Heuristic value of this node.
  ///
  /// It is -1 if MIN player wins from this state, and 1 if MAX player wins from this state.
  int mark;

  /// List of children nodes.
  ///
  /// Represents possible turns: possible states from the current state (node).
  List<Node> children;

  /// Node constructor
  Node({
    required this.matches,
    required this.level,
    this.mark = 0,
    this.children = const [],
  });

  /// Create Node and evaluate it (set heuristic value for it).
  ///
  /// To evaluate node, it creates all its' children.
  factory Node.createAndEvaluate({
    /// Matches count
    required int matches,

    /// Level (MIN or MAX). Defaults to MAX. Default value can be used for root only.
    Level level = Level.max,

    /// Graph row number.
    ///
    /// Used to save nodes and reuse them when creating graph. Defaults to 0 for root.
    int row = 0,
  }) {
    Node? savedNode = nodeMatrix.matrix[row][matches];
    if (savedNode != null) {
      return savedNode;
    }

    Node thisNode = Node(matches: matches, level: level);

    /// If this node is leaf, evaluate it and return.
    if (matches == 0) {
      /// Set -1 if current level is MIN and +1 if current level is MAX
      thisNode.mark = (level == Level.max) ? 1 : -1;
      return thisNode;
    }

    /// Non-leaf node:

    int childMatches = matches;

    /// Children have opposite level to its' parent
    Level childLevel = (level == Level.max) ? Level.min : Level.max;

    /// Children list
    List<Node> children = [];
    do {
      /// Take 1, 2 or 3 matches
      childMatches--;

      /// Create and evaluate child
      children.add(Node.createAndEvaluate(matches: childMatches, level: childLevel, row: row + 1));
    } while ((childMatches > 0) && (childMatches > matches - 3));

    thisNode.children = children;

    /// All children are evaluated.
    ///
    /// Now, knowing current level and children heuristic values, evaluate current node.
    /// Take minimum of children heuristic values, if current level is MIN.
    /// Take maximum of children heuristic values, if current level is MAX.
    int bestMark = children[0].mark;
    for (Node child in children) {
      if (level == Level.max && child.mark > bestMark) {
        bestMark = child.mark;
      } else if (level == Level.min && child.mark < bestMark) {
        bestMark = child.mark;
      }
    }
    thisNode.mark = bestMark;

    nodeMatrix.matrix[row][matches] = thisNode;
    return thisNode;
  }

  /// Debug: print node. Use it on root to output the entire graph.
  void printNode([int line = 0]) {
    String childrenString = '[';
    for (Node child in children) {
      childrenString += child.matches.toString() + ' ';
    }
    childrenString += ']';
    print(line.toString() + '. ' + this.matches.toString() + ' (' + this.mark.toString() + ') ' + childrenString);
    for (Node child in children) {
      child.printNode(line + 1);
    }
  }

  /// Get the best move from the current node.
  ///
  /// AI uses this function to get the best move.
  /// The best node from this node must have the same heuristic value.
  /// So, this function checks every current node child until finds the one with the same heuristic value.
  Node getBestMove() {
    for (Node child in children) {
      if (this.mark == child.mark) {
        return child;
      }
    }
    throw Exception('Have not found best move. Make sure current Node has children');
  }

  /// Get next node from current node, knowing taken matches amount.
  ///
  /// This function is used to change game state (change node) after user has made a decision.
  Node getNextNode(int matchesTaken) {
    return this.children[matchesTaken - 1];
  }
}
