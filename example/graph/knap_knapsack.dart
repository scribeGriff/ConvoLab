// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function knap() to compute the optimal solution to a
 * knapsack problem.
 *
 * Accepts a 2D array and the capacity of the knapsack.  The 2D array should
 * privide the value of the item followed by its weight: [value, weight].
 * It is assumed for this algorithm that all weights and the knapsack capacity
 * are integer values.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  List<List<int>> ksack1 = [[874, 580],
                            [620, 1616],
                            [345, 1906],
                            [369, 1942],
                            [360, 50],
                            [470, 294]];

  var capacity = 2000;
  var kpsk = knap(ksack1, capacity);
  print('The optimum knapsack has a value of ${kpsk.value}'
      ' with a weight of ${kpsk.weight}.');
  print('The optimum solution selects the following items:');
  for (var index = 0; index < ksack1.length; index++) {
    if (kpsk.data[index]) {
      print(ksack1[index]);
    }
  }
}

// Prints:
// The optimum knapsack has a value of 1704 with a weight of 924.
// The optimum solution selects the following items:
// [874, 580]
// [360, 50]
// [470, 294]
