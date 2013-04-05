// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the strongly connected components of a graph using Kosaraju's
 * algorithm.
 *
 * Accepts a 2D array (List<List<int>>) of edges of a directed graph.  The
 * edges are assumed to be directed from the first column vertex to the second
 * column vertex.
 *
 * Example usage:
 *
 *     List<List> sccfile = [[1, 1],
 *                           [1, 3],
 *                           [3, 2],
 *                           [2, 1],
 *                           [3, 5],
 *                           [4, 1],
 *                           [4, 2],
 *                           [4, 12],
 *                           [4, 13],
 *                           [5, 6],
 *                           [5, 8],
 *                           [6, 7],
 *                           [6, 8],
 *                           [6, 10],
 *                           [7, 10],
 *                           [8, 9],
 *                           [8, 10],
 *                           [9, 5],
 *                           [9, 11],
 *                           [10, 9],
 *                           [10, 11],
 *                           [10, 14],
 *                           [11, 12],
 *                           [11, 14],
 *                           [12, 13],
 *                           [13, 11],
 *                           [13, 15],
 *                           [14, 13],
 *                           [15, 14]];
 *
 *     scc(sccfile).then((sccResults) {
 *       print('the results');
 *     });
 *
 * Returns an object of type SccResults which contains the following fields:
 * * sccResults.data: A List of the size of the strongly connected components.
 * * sccResults.value: An integer representing the number of vertices.
 * * sccResults.sccGraph: A map of all the vertices and their scc group as a
 *   K,V pair.
 *
 * For this example:
 *     print(sccResults.data);
 *     print(sccResults.value);
 *     print(sccResults.sccGraph);
 *
 * Prints:
 *     [6, 5, 3, 1]
 *     15
 *     {1: 2, 2: 2, 3: 2, 4: 3, 5: 1, 6: 1, 7: 1, 8: 1, 9: 1, 10: 1, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0}
 *
 *
 * Dependencies:
 * * dart:collection
 * * class DirectedGraph
 * * class _Kosaraju
 * * class SccResults
 *
 */

/// Top level function scc accepts an edge list and returns
/// an object of type SccResults.
Future<SccResults> scc(List<List> edgeList) {
  // Check if the edge list data is valid.
  if (edgeList == null || edgeList.isEmpty) {
    throw new ArgumentError("Edge list data is not valid.");
  }
  // Variables.
  HashMap components;
  List sccValues = [];
  List sumComponents = [];
  var offset = 0;

  // Create two new directed graph.
  DirectedGraph graph = new DirectedGraph();
  DirectedGraph grev = new DirectedGraph();

  /// Populate the directed graph with the vertices from the edge list.
  for (List list in edgeList) {
    for (var element in list) {
      graph.addNode(element);
    }
  }
  /// Populate the directed graph with the directed edges.
  for (List list in edgeList) {
    graph.addEdge(list[0], list[1]);
  }
  /// Populate the reversed graph with the vertices from the edge list.
  for (List list in edgeList) {
    for (var element in list) {
      grev.addNode(element);
    }
  }
  /// Populate the reversed graph with the directed edges in reverse order.
  for (List list in edgeList) {
    grev.addEdge(list[1], list[0]);
  }

  // For really large graphs, heap space can be an issue.
  if (edgeList.length > 500000) {
    edgeList.clear();
  }

  /// Compute the strongly connected components of the
  /// directed graph using Kosaraju's alogorithm.
  components = new _Kosaraju().computeSCC(graph, grev: grev);

  /// Compute the size of each scc group and store it in a sorted list.
  sccValues = components.values.toList()
      ..sort();
  var N = sccValues.length;
  for (var i = 0; i < N - 1; i++) {
    if (sccValues[i] != sccValues[i + 1]) {
      sumComponents.add(i + 1 - offset);
      offset = i + 1;
    }
  }
  sumComponents..add(N - offset)..sort((a, b) => b.compareTo(a));

  /// Return the SccResults object.
  return new Future.of(() =>
      new SccResults(sumComponents, N, components, graph));
}

/// SccResults extends the standard results class.
/// Returns the size of each SCC as data, the number of vertices in the
/// graph as value and the results of the scc as sccGraph.
class SccResults extends ConvoLabResults{
  final sccNodes;
  final graph;

  SccResults(data, value, this.sccNodes, this.graph) : super(data, value);
}

