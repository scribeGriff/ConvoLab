// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the minimum spanning tree using Kruskal's algorithm.
 *
 * Accepts a 2D array (List<List<int>>) of edges (length m) and edge weights
 * of a connected graph (this algorithm does not check connectivity).
 * Also accepts an optional parameter specifying the number of nodes (n).
 * The run time is dominated by the sorting algorithm, which in this
 * implementation uses a simple O(m^2) bubble sort where m is the number
 * of edges.  A future version may implement an O(nlogn) sort.
 * Returns a 2D array of the minimum spanning tree of the input and the sum
 * of the edge weights of the mst.
 *
 * Example usage:
 *
 *     List<List<int>> adjList = [[1, 2, 2],
 *                                [1, 3, 5],
 *                                [1, 4, 7],
 *                                [4, 5, 13],
 *                                [3, 4, 3]];
 *     var n = 5;
 *     var mst = kmst(adjList, n);
 *     print(mst.data);
 *     print(mst.value);
 *
 *     //prints:
 *     [[1, 2, 2], [1, 3, 5], [3, 4, 3], [4, 5, 13]]
 *     23
 *
 * Returns an object of type KmstResults if successful.
 *
 * Dependencies:
 *
 * * class UnionFind
 * * class KmstResults
 *
 */

/// The top level function primst returns the object PrimstResults.
KmstResults kmst(var adjList, [var numVertices]) =>
    new _KruskalsMst(adjList).computeMST(numVertices);

/// The private class _KmsMst.
class _KruskalsMst {

  List<List<int>> adjList;
  List<List<int>> mstList = [];

  _KruskalsMst(this.adjList);

  KmstResults computeMST(var n) {
    if (n == null) n = adjList.length;

    /// Sort the adjacency list in ascending order.
    bool swapped = true;
    int j = 0;
    int tmp;
    while (swapped) {
      swapped = false;
      j++;
      for (var i = 0; i < adjList.length - j; i++) {
        if ((adjList[i][2]) > (adjList[i + 1][2])) {
          var tmp = adjList[i];
          adjList[i] = adjList[i + 1];
          adjList[i + 1] = tmp;
          swapped = true;
        }
      }
    }

    /// Create a union-find data structure
    var a = new UnionFind(n + 1);
    var u, v;

    /// For each edge, find the vertices that belong to the MST
    /// and add them to the tree if they do not cause a cycle.
    for (var k = 0; k < adjList.length; k++) {
      u = a.find(adjList[k][0]);
      v = a.find(adjList[k][1]);

      if (u != v) {
        a.union(u, v);
        mstList.add(adjList[k]);
      }
    }

    /// Sum the weights of the minimum spanning tree.
    var result = 0;
    for (final element in mstList) {
      if (element != null) result += element[2];
    }
    /// Returns the MST as an adjacency list and the sum of the edge weights.
    return new KmstResults(mstList, result);
  }
}

/// PrimstResults extends the standard results class.
/// Returns the MST as data and the sum of the edge weights as value.
class KmstResults extends ConvoLabResults {

  final List<List<int>> data;
  final int value;

  KmstResults(this.data, this.value) : super();
}
