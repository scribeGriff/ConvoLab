// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function 2sat() to determine the satisfiability
 * of a 2d array of clauses.  Implements Kosaraju's algorithm to allow
 * the a linear bound on this NPC problem.
 */

import 'package:convolab/convolab.dart';
import 'dart:async';

void main() {
  // Unsatisfiable.  Same as 2sat_55unsat.txt in library ConvoHio.
  List<List> satfile1 = [[1, 1],
                         [-1, 2],
                         [-1, 3],
                         [-2, -3],
                         [4, 5]];

  // Satisfiable.  Same as 2sat_44sat.txt.
  List<List> satfile2 = [[1, 2],
                         [-1, 3],
                         [3, 4],
                         [-2, -4]];

  //  Unsatisfiable.  Same as 2sat_716unsat.txt.
  List<List> satfile3 = [[-1, -4],
                         [-2, -7],
                         [2, -6],
                         [2, 7],
                         [-6, 7],
                         [1, -5],
                         [1, 7],
                         [-5, 7],
                         [-1, -7],
                         [-3, 6],
                         [3, -4],
                         [3, -6],
                         [-4, -6],
                         [2, 5],
                         [-2, 3],
                         [-3, -5]];

  List graphs = [satfile1, satfile2, satfile3];

  for (var graph in graphs) {
    twosat(graph).then((isSat) {
      if (isSat) {
        print('The graph\n$graph\nis satisfiable.\n');
      } else {
        print('The graph\n$graph\nis not satisfiable.\n');
      }
    });
  }

  // prints:
  //The graph
  //[[1, 1], [-1, 2], [-1, 3], [-2, -3], [4, 5]]
  //is not satisfiable.

  //The graph
  //[[1, 2], [-1, 3], [3, 4], [-2, -4]]
  //is satisfiable.

  //The graph
  //[[-1, -4], [-2, -7], [2, -6], [2, 7], [-6, 7], [1, -5], [1, 7], [-5, 7], [-1, -7], [-3, 6], [3, -4], [3, -6], [-4, -6], [2, 5], [-2, 3], [-3, -5]]
  //is not satisfiable.
}

