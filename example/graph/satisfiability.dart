// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function 2sat() to determine the satisfiability
 * of a 2d array of clauses.  Implements Kosaraju's algorithm to allow
 * the a linear bound on this NPC problem.
 */

import 'package:convolab/convolab.dart';

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

  if (twosat(satfile1)) {
    print('This file is satisfiable.');
  } else {
    print('This file is not satisfiable.');
  }
  // prints: This file is not satisfiable.

  if (twosat(satfile2)) {
    print('This file is satisfiable.');
  } else {
    print('This file is not satisfiable.');
  }
  // prints: This file is satisfiable.

  if (twosat(satfile3)) {
    print('This file is satisfiable.');
  } else {
    print('This file is not satisfiable.');
  }
  // prints: This file is not satisfiable.
}

