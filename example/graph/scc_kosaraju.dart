// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 *   Example using the function scc() to compute the strongly connected
 *   components of a directed graph.  Implements the Kosaraju algorithm.
 */

import 'package:convolab/convolab.dart';
import 'dart:async';
import 'dart:collection';

void main() {
  List<List> sccfile1 = [[1, 1],
                         [1, 3],
                         [3, 2],
                         [2, 1],
                         [3, 5],
                         [4, 1],
                         [4, 2],
                         [4, 12],
                         [4, 13],
                         [5, 6],
                         [5, 8],
                         [6, 7],
                         [6, 8],
                         [6, 10],
                         [7, 10],
                         [8, 9],
                         [8, 10],
                         [9, 5],
                         [9, 11],
                         [10, 9],
                         [10, 11],
                         [10, 14],
                         [11, 12],
                         [11, 14],
                         [12, 13],
                         [13, 11],
                         [13, 15],
                         [14, 13],
                         [15, 14]];

  List<List> sccfile2 = [[1, 1],
                         [1, 2],
                         [2, 2],
                         [2, 3],
                         [2, 4],
                         [3, 1],
                         [3, 3],
                         [4, 4],
                         [4, 5],
                         [4, 7],
                         [5, 5],
                         [5, 6],
                         [6, 4],
                         [6, 6],
                         [7, 7],
                         [7, 8],
                         [7, 9],
                         [8, 8],
                         [8, 10],
                         [9, 8],
                         [9, 9],
                         [10, 7],
                         [10, 10]];

  List<List> sccfile3 = [[1, 4],
                         [2, 8],
                         [3, 6],
                         [4, 7],
                         [5, 2],
                         [6, 9],
                         [7, 1],
                         [8, 6],
                         [8, 5],
                         [9, 7],
                         [9, 3]];

  List<List> sccfile4 = [[1, 1],
                         [2, 3],
                         [3, 2],
                         [4, 3],
                         [2, 5]];

  List<List> sccfile5 = [[1, 2],
                         [2, 3],
                         [3, 4],
                         [4, 5],
                         [5, 6],
                         [6, 7],
                         [7, 8],
                         [8, 9],
                         [9, 1]];


  var futureScc = scc(sccfile1);
  futureScc.then((sccResults) {
    print('The size of each strongly connected component is ${sccResults.data}.');
    print('There are ${sccResults.value} nodes in this graph.');
    print('The map of nodes with the scc the node belongs in: \n'
        '${sccResults.sccNodes}');

    // We can reorder the results and put the scc as the key and the nodes
    // as the values.
    HashMap sets = new HashMap();
    for (var value in sccResults.sccNodes.values) {
      if (!sets.containsKey(value)) {
        sets[value] = new HashSet();
        for (var key in sccResults.sccNodes.keys) {
          if (sccResults.sccNodes[key] == value) {
            sets[value].add(key);
          }
        }
      }
    }
    print('The map of components with a list of the nodes belonging to it: \n'
        '$sets');
  });
  // Prints:
  // The size of each strongly connected component is [6, 5, 3, 1].
  // There are 15 nodes in this graph.
  // The map of nodes with the scc the node belongs in:
  // {1: 2, 2: 2, 3: 2, 4: 3, 5: 1, 6: 1, 7: 1, 8: 1, 9: 1, 10: 1, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0}
  // The map of components with a list of the nodes belonging to it:
  // {0: {11, 12, 13, 14, 15}, 1: {8, 9, 10, 5, 6, 7}, 2: {1, 2, 3}, 3: {4}}
}

