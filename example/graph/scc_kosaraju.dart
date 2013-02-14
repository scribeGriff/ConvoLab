// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 *   Example using the function scc() to compute the strongly connected
 *   components of a directed graph.
 */

import 'package:convolab/convolab.dart';

void main() {
// Same as testscc1.txt.
  List<List> sccfile = [[1, 1],
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


  var sccResults = scc(sccfile);
  print(sccResults.data);
  print(sccResults.value);
  print(sccResults.sccGraph);

  // Prints:
  // [6, 5, 3, 1]
  //  15
  // {1: 2, 2: 2, 3: 2, 4: 3, 5: 1, 6: 1, 7: 1, 8: 1, 9: 1, 10: 1, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0}
}

