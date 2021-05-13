import 'package:matches_game/node.dart';

/// Node Matrix class.
///
/// Contains the only variable: 2D List of Nodes.
/// Having i (row number) and j (column number), this 2D List element at position [i][j]
/// represents game state, when i turns were made and j matches left.
///
/// This List is used to calculate each Node just once.
/// So, every time when Node.createAndEvaluate function is called to create and evaluate new node,
/// it will first check if this node already exists in NodeMatrix.matrix.
class NodeMatrix {
  List<List<Node?>> matrix =
      List.generate(31, (row) => List.generate(31, (index) => null, growable: false), growable: false);

  NodeMatrix();
}

/// NodeMatrix Singleton.
NodeMatrix nodeMatrix = NodeMatrix();
