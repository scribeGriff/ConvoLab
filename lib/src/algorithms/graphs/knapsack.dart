// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the optimum weight and value using the knapsack alogorithm.
 *
 * Example usage.
 *     List<List<int>> ksack1 = [[874, 580],
 *                               [620, 1616],
 *                               [345, 1906],
 *                               [369, 1942],
 *                               [360, 50],
 *                               [470, 294]];
 *
 *     var items = 6;
 *     var size = 2000;
 *     var kpsk = knap(ksack1, size, items);
 *     print('The optimum knapsack has ${knap.value} and ${knap.weight}.');
 *
 * Returns an object of type KnapResults if successful.
 *
 * Dependencies included in this file:
 * * class KnapResults
 *
 */

/// The top level function apsp returns the object ApspResults.
KnapResults knap(var valueWeight, var targetW, var targetN) =>
    new _Knapsack(valueWeight).computeCapacity(targetW, targetN);

class _Knapsack {
  const minValue = -2147483648;
  final valueWeight;
  List<List<int>> optimum;
  List<List<bool>> incItem;
  List<bool> selected;
  var option1, option2;
  var value = 0;
  var weight = 0;

  _Knapsack(this.valueWeight);

  KnapResults computeCapacity(var W, var N) {
    // Create a 2D array to hold the optimal solution for each
    // recurrance.  Populate with a zero value initially.
    optimum = new List<List<int>>(N + 1);
    for (var i = 0; i <= N; i++) {
      optimum[i] = new List<int>(W + 1);
    }
    for (var i = 0; i <= N; i++) {
      for (var j = 0; j <= W; j++) {
        optimum[i][j] = 0;

      }
    }
    // Create another 2D array to keep track of whether the
    // optimal solution included the item for that iteration.
    // Populate with boolean false initially.
    incItem = new List<List<bool>>(N + 1);
    for (var i = 0; i <= N; i++) {
      incItem[i] = new List<bool>(W + 1);
    }
    for (var i = 0; i <= N; i++) {
      for (var j = 0; j <= W; j++) {
      incItem[i][j] = false;
      }
    }
    // Iterate over number of items and the weight of each item
    // to determine the optimum solution for each.
    for (var n = 1; n <= N; n++) {
      for (var w = 1; w <= W; w++) {
        // Case 1: item excluded.
        option1 = optimum[n-1][w];
        // Case 2: item included.
        option2 = minValue;
        if (valueWeight[n][1] <= w) {
          option2 = valueWeight[n][0] + optimum[n - 1][w - valueWeight[n][1]];
        }
        // Select which of the two options are optimal and if
        // this item was included in solution.
        optimum[n][w] = max(option1, option2);
        incItem[n][w] = (option2 > option1);
      }
    }
    // Now assemble an array representing the optimum knapsack.
    selected = new List<bool>(N + 1);
    for (int n = N, w = W; n > 0; n--) {
      if (incItem[n][w]) {
        selected[n] = true;
        w = w - valueWeight[n][1];
      } else {
        selected[n] = false;
      }
    }
    for (var i = 1; i < selected.length; i++) {
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