// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the minimum spanning tree using Prim's algorithm.
 *
 * Accepts a 2D array (List<List<int>>) of edges (length m) and edge weights
 * of a connected graph (this algorithm does not check connectivity).
 * Also accepts an optional parameter specifying the number of nodes (n).
 * If n is not specified, run time is appoximately O(m^2).  If n is specified,
 * the run time is approximately O(mn).
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
 *     var mst = primst(adjList, n);
 *     print(mst.data);
 *     print(mst.value);
 *
 *     //prints:
 *     [[1, 2, 2], [1, 3, 5], [3, 4, 3], [4, 5, 13]]
 *     23
 *
 * Returns an object of type PrimstResults if successful.
 *
 * Dependencies included in this file:
 *
 * * class _Edge
 * * class PrimstResults
 *
 * Reference: Algorithms of the Intelligent Web
 * Haralambos Marminis
 * Dmitry Babenko
 *
 */

/// The top level function primst returns the object PrimstResults.
PrimstResults primst(var adjList, [var numVertices]) =>
    new _PrimsMst(adjList).computeMST(numVertices);

/// The private class _PrimsMst.
class _PrimsMst {

  List<List<int>> adjList;
  List<List<int>> adjMatrix;
  List<List<int>> mstree;
  List<List<int>> mstList = [];
  List<bool> allV = [];

  _PrimsMst(this.adjList);

  PrimstResults computeMST(var n) {
    if (n == null) n = adjList.length;

    adjMatrix = new List<List<int>>(n);
    // create the sublists
    for (var i = 0; i < n; i++) {
      adjMatrix[i] = new List<int>(n);
    }

    // populate with a very large number
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        adjMatrix[i][j] = 1000000;
      }
    }

    // Map the list to a sparse array.
    for (var i = 0; i < adjList.length; i++) {
      adjMatrix[adjList[i][0] - 1][adjList[i][1] - 1] = adjList[i][2];
      adjMatrix[adjList[i][1] - 1][adjList[i][0] - 1] = adjList[i][2];
    }

    mstree = new List<List<int>>(adjMatrix.length);

    allV.insertRange(0, adjMatrix.length, false);
    allV[0] = true;

    for (var i = 0; i < adjMatrix.length; i++) {
      mstree[i] = new List<int>(adjMatrix.length);
    }

    for (var i = 0; i < adjMatrix.length; i++) {
      for (var j = 0; j < adjMatrix.length; j++) {
        mstree[i][j] = null;
      }
    }

    _Edge e = null;

    /// Main while loop continues until findMinimumEdge returns null.
    while ((e = findMinimumEdge(allV)) != null) {
      allV[e.j] = true;
      mstree[e.i][e.j] = e.w;
      mstree[e.j][e.i] = e.w;
    }

    /// Converts the minimum spanning tree to an adjacency
    /// list and sums the weights.
    var result = 0;
    for (var i = 0; i < mstree.length; i++) {
      for (var j = 0; j < mstree.length; j++) {
        if (mstree[i][j] != null && mstree[i][j] != 1000000) {
          result += mstree[i][j];
          mstList.add([i + 1, j + 1, mstree[i][j]]);
          mstree[j][i] = null;
        }
      }
    }
    /// Returns the MST as an adjacency list and the sum of the edge weights.
    return new PrimstResults(mstList, result);
  }

  /// Returns a new edge object for next minimum weight edge.
  _Edge findMinimumEdge(List<bool> mstV) {
    _Edge e = null;
    var minW = 10000000;
    var minI = null;
    var minJ = null;
    var m = adjMatrix.length;
    for (var i = 0; i < m; i++) {
      if (mstV[i] == true) {
        for (var j = 0; j < m; j++) {
          if (mstV[j] == false) {
            if (minW > adjMatrix[i][j]) {
              minW = adjMatrix[i][j];
              minI = i;
              minJ = j;
            }
          }
        }
      }
    }
    if (minI != null) e = new _Edge(minI, minJ, minW);
    return e;
  }
}

/// Private class _Edge creates an edge object with vertices i, j
/// and edge weigth w.
class _Edge {
  final i;
  final j;
  final w;

  _Edge (this.i, this.j, this.w);
}

/// PrimstResults extends the standard results class.
/// Returns the MST as data and the sum of the edge weights as value.
class PrimstResults extends ConvoLabResults {

  final List<List<int>> data;
  final int value;

  PrimstResults(this.data, this.value) : super();
}
