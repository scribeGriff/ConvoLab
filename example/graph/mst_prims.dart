// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function primst() to compute the minimum spanning
 * tree of a directed graph.
 *
 */

import 'package:convolab/convolab.dart';

void main() {

  List<List<int>> adjList = [[1, 2, 2],
                             [1, 3, 5],
                             [1, 4, 7],
                             [4, 5, 13],
                             [3, 4, 3]];

  var n = 5;
  var mst = primst(adjList, n);
  print(mst.data);
  print(mst.value);

  // prints:
  // [[1, 2, 2], [1, 3, 5], [3, 4, 3], [4, 5, 13]]
  // 23
}

