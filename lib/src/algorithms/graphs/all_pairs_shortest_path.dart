// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the all pairs shortest paths using the Floyd Warshall algorithm.
 *
 * Given an directed graph of edges with their edge weights, compute the
 * shortest path between two vertices for all pairs of nodes in the graph.
 * If a negative cycle is detected, then the solution is not valid and null
 * is returned.  If a valid solution is obtained, then the value of the
 * shortest shortest path is returned and a list of all the shortest paths.
 *
 * Example usage.
 *     List<List<int>> adjl = [[1, 2, 2],
 *                             [1, 3, 5],
 *                             [2, 4, -4],
 *                             [4, 3, 8],
 *                             [4, 5, 2],
 *                             [3, 1, 4],
 *                             [3, 2, -3],
 *                             [3, 4, 6],
 *                             [3, 6, 5],
 *                             [6, 4, 1],
 *                             [6, 5, -5]];
 *     var nodes = 6;
 *     var edges = 11;
 *     var ssp = apsp(adjl, nodes, edges);
 *     if (ssp == null) {
 *       print('Negative cycle detected');
 *     } else {
 *       print('The shortest shortest path length is ${ssp.value}.');
 *     }
 *
 * Prints: The shortest shortest path length is -7.
 *
 * Returns an object of type ApspResults if successful or null if a
 * negative cycle was found.
 *
 * Dependencies included in this file:
 * * class ApspResults
 *
 */

/// The top level function apsp returns the object ApspResults.
ApspResults apsp(var adjList, var numVertices, var numEdges) =>
    new _Apsp(adjList).computeApsp(numVertices, numEdges);

class _Apsp {
  // Just need some large value to indicate that no path exists.
  // Small integer requires < 2^30 - 1 (32 bit) = 1073741823.
  static const largeValue = 1073741823 >> 1;
  final List<List> adjList;
  List<List> adjMatrix;
  List<List> apspList = new List();
  List<int> nodes = new List(2);

  _Apsp(this.adjList);

  ApspResults computeApsp(final N, final K) {
    var shortPath = largeValue;

    // Create a 2D array and populate it with a large value except at
    // i = j which is set equal to 0.
    adjMatrix = new List.generate(N, (i) =>
        new List.generate(N, (j) => i == j ? 0 : largeValue));

    // Map the adjacency list to the sparse array.
    for (var i = 1; i < adjList.length; i++) {
      adjMatrix[adjList[i][0] - 1][adjList[i][1] - 1] = adjList[i][2];
    }
    // Implement the Floyd Warshall dynamic programming algorithm.
    for (var i = 0; i < N; i++) {
      for (var j = 0; j < N; j++) {
        for (var k = 0; k < N; k++) {
          if (adjMatrix[j][k] > adjMatrix[j][i] + adjMatrix[i][k]) {
            adjMatrix[j][k] = adjMatrix[j][i] + adjMatrix[i][k];
          }
        }
        if (adjMatrix[j][j] < 0.0) {
          // Found a negative edge cycle. Exit and return null.
          return null;
        }
      }
    }
    // Map the sparse matrix to a list of all pairs shortest paths and find the
    // shortest - shortest path value and the nodes comprising the
    // shortest - shortest path.
    for (var i = 0; i < N; i++) {
      for (var j = 0; j < N; j++) {
        apspList.add([i + 1, j + 1, adjMatrix[i][j]]);
        if (adjMatrix[i][j] < shortPath) {
          shortPath = adjMatrix[i][j];
          nodes = [i + 1, j + 1];
        }
      }
    }
    return new ApspResults(apspList, shortPath, nodes);
  }
}

/// ApspResults extends the standard results class.
/// Returns a 2D array of the shortest paths between two vertices as data
/// and the shortest of the shortest paths as value.
class ApspResults extends ConvoLabResults {
  final List nodes;

  ApspResults(List data, int value, this.nodes) : super(data, value);
}