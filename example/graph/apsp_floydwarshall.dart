// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function apsp() to compute the all pairs shortest path.
 *
 * Implements the Floyd Warshall algorithm and returns a list of the shortest
 * paths between two nodes of a directed graph and the shortest shortest path.
 *
 * If the graph contains a negative cycle, returns null.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  // First example with no negative cycles.
  List<List<int>> adjl = [[1, 2, 2],
                          [1, 3, 5],
                          [2, 4, -4],
                          [4, 3, 8],
                          [4, 5, 2],
                          [3, 1, 4],
                          [3, 2, -3],
                          [3, 4, 6],
                          [3, 6, 5],
                          [6, 4, 1],
                          [6, 5, -5]];
  var nodes = 6;
  var edges = 11;
  var ssp = apsp(adjl, nodes, edges);
  if (ssp == null) {
    print('Negative cycle detected');
  } else {
    print('The shortest shortest path length is ${ssp.value}');
    print('The complete list of shortest paths:');
    for (List list in ssp.data) {
      print(list);
    }
  }
  // Prints: The shortest shortest path length is -7.
  // Also prints the 2D array of shortest paths for all nodes.

  // Second example with a negative cycle.
  adjl = [[1, 2, 2],
          [1, 3, 5],
          [2, 4, -4],
          [4, 3, 6],
          [4, 5, 2],
          [3, 1, 4],
          [3, 2, -3],
          [3, 4, 6],
          [3, 6, 5],
          [6, 4, 1],
          [6, 5, -5]];

  ssp = apsp(adjl, nodes, edges);
  if (ssp == null) {
    print('Negative cycle detected.');
  } else {
    print('The shortest shortest path length is ${ssp.value}');
    print('The complete list of shortest paths:');
    for (List list in ssp.data) {
      print(list);
    }
  }
  // Prints: Negative cycle detected.
}