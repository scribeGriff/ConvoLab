// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the optimum solution to the knapsack alogorithm.
 *
 * Accepts a 2D array and the capacity of the knapsack.  The 2D array should
 * privide the value of the item followed by its weight: [value, weight].
 * It is assumed for this algorithm that all weights and the knapsack capacity
 * are integer values.
 *
 * Example usage.
 *     List<List<int>> ksack1 = [[874, 580],
 *                               [620, 1616],
 *                               [345, 1906],
 *                               [369, 1942],
 *                               [360, 50],
 *                               [470, 294]];
 *
 *     var capacity = 2000;
 *     var kpsk = knap(ksack1, capacity);
 *       print('The optimum knapsack has a value of ${kpsk.value}'
 *           ' with a weight of ${kpsk.weight}.');
 *     print('The optimum solution selects the following items:');
 *     for (var index = 0; index < ksack1.length; index++) {
 *       if (kpsk.data[index]) {
 *         print(ksack1[index]);
 *       }
 *     }
 *
 * Returns an object of type KnapResults if successful.
 * * List data: A boolean list of which items were included (true) or not
 *   (false).
 * * int value: The value of the optimal solution.
 * * int weight: The weight of the backpack with the optimal number of items.
 *
 * Dependencies included in this file:
 * * class KnapResults
 *
 */

/// The top level function apsp returns the object ApspResults.
KnapResults knap(var valueWeight, var capacity) =>
    new _Knapsack(valueWeight).computeCapacity(capacity);

class _Knapsack {
  // Just need some small value to indicate a minimum.
  // Small integer requires < -2^30 (32 bit) = -1073741824.
  static const minValue = -1073741824 >> 1;
  final valueWeight;
  List<List<int>> optimum;
  List<List<bool>> incItem;
  List<bool> selected;
  var option1, option2;
  var value = 0;
  var weight = 0;
  var N;

  _Knapsack(this.valueWeight);

  KnapResults computeCapacity(var W) {
    // The number of items is the length of the 2D array:
    N = valueWeight.length;

    // Create a 2D array and initialize all elements to 0.
    // Holds the optimal solution for each recurrance.
    optimum = new List.generate(N + 1, (var index) => new List.filled(W + 1, 0));

    // Create another 2D array and initialize all elements to false.
    // Keeps track of whether the item for that iteration is included in optimal solution.
    incItem = new List.generate(N + 1, (var index) => new List.filled(W + 1, false));

    // Iterate over number of items and the weight of each item
    // to determine the optimum solution for each.
    for (var n = 1; n <= N; n++) {
      for (var w = 1; w <= W; w++) {
        // Case 1: item excluded.
        option1 = optimum[n-1][w];
        // Case 2: item included.
        option2 = minValue;
        if (valueWeight[n - 1][1] <= w) {
          option2 = valueWeight[n - 1][0] +
              optimum[n - 1][w - valueWeight[n - 1][1]];
        }
        // Select which of the two options are optimal and if
        // this item was included in solution.
        optimum[n][w] = max(option1, option2);
        incItem[n][w] = option2 > option1;
      }
    }
    // Now assemble an array representing the optimum knapsack.
    selected = new List<bool>(N);
    for (var n = N, w = W; n > 0; n--) {
      if (incItem[n][w]) {
        selected[n - 1] = true;
        w = w - valueWeight[n - 1][1];
      } else {
        selected[n - 1] = false;
      }
    }
    for (var i = 0; i < selected.length; i++) {
      if (selected[i]) {
        value += valueWeight[i][0];
        weight += valueWeight[i][1];
      }
    }
    return new KnapResults(selected, value, weight);
  }
}

/// KnapResults extends the standard results class.
/// Returns a 2D array of the shortest paths between two vertices as data
/// and the shortest of the shortest paths as value.
class KnapResults extends ConvoLabResults {
  final int weight;

  KnapResults(List data, int value, this.weight) : super(data, value);
}