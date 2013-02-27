// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Returns a map of the strongly connected components of a directed graph.
 *
 * Although an instance of this private class could be used directly, it is
 * more commonly instantiated through top level function calls to either scc(),
 * for computed the strongly connected components of a 2 dimensional array, or
 * 2sat(), for computing the satisfiability of a 2 dimensional array of 2
 * variable clauses.
 *
 * We can summarize the key elements of the algorithm in three concise steps:
 * * Compute a transform of the input graph g: g -> grev
 * * Perform the first DFS on grev: Returns order of visit nodes in grev
 * * Perform a second DFS on g in the reverse visit order returned by first DFS
 *
 * Dependencies: dart:collection, DirectedGraph.
 * Reference: Kosaraju.java from Keith Schwarz (htiek@cs.stanford.edu)
 */

class _Kosaraju {

  HashMap computeSCC(DirectedGraph g) {
    /// Create the result map and a counter to keep track of which
    /// depth first search iteration this is.
    HashMap result = new HashMap();
    int iteration = 0;

    /// Run a depth-first search in the reverse graph to get the order in
    /// which the nodes should be processed and save the results in a queue.
    ListQueue visitOrder = initFirstDFS(transformGraph(g));

    /// Continuously process the the nodes from the queue by running a
    /// depth first search from each unmarked node encountered.
    while (!visitOrder.isEmpty) {
      // If the last node has already been visited, ignore it and
      // continue on with the next node in the queue until empty.
      var startPoint = visitOrder.removeLast();
      if (result.containsKey(startPoint)) {
        continue;
      }
      // Otherwise, run a depth first search from the node contained in
      // startPoint, updating the result map with everything visited as being
      // at the current iteration level.
      secondDFS(startPoint, g, result, iteration);
      // Increase the number of the next SCC to label.
      iteration++;
    }
    return result;
  }

  // Step 1:
  /// Given a directed graph, return the reverse of that graph.
  DirectedGraph transformGraph(DirectedGraph g) {
    DirectedGraph grev = new DirectedGraph();
    // Copy the nodes to grev graph.
    for (var node in g) {
      grev.addNode(node);
    }
    // Then copy the edges while reversing them.
    for (var start in g) {
      for (var end in g.edgesFrom(start)) {
        grev.addEdge(end, start);
      }
    }
    return grev;
  }

  // Step 2:
  /// Given a graph, returns a queue containing the nodes of that graph in
  /// the order in which a DFS of that graph finishes expanding the nodes.
  ListQueue initFirstDFS(DirectedGraph g) {
    // The resulting ordering of the nodes.
    ListQueue visitOrder = new ListQueue();
    // The set of nodes that we've visited so far.
    HashSet visited = new HashSet();
    // Perform a DFS for each node in g and whose origin is given by node.
    for (var node in g) {
      firstDFS(node, g, visitOrder, visited);
    }
    return visitOrder;
  }

  /// Recursively explores the given node with a DFS, adding it to the output
  /// list once the exploration is complete.
  void firstDFS(var node, DirectedGraph g, ListQueue visitOrder, HashSet visited) {
    // If we've already been at this node, don't explore it again.
    if (visited.contains(node)) {
      return;
    } else {
      // Otherwise, mark that we've been here.
      visited.add(node);
    }
    // Recursively explore all the node's children.
    for (var endpoint in g.edgesFrom(node)) {
      firstDFS(endpoint, g, visitOrder, visited);
    }
    // We're done exploring this node, so add it to the ordered queue of
    // visited nodes.
    visitOrder.addLast(node);
  }

  // Step 3:
  /// Recursively marks all nodes reachable from the given node by a DFS with
  /// the current label.
  void secondDFS(var node, DirectedGraph g, HashMap result, int label) {
    // If we've visited this node before, return.
    if (result.containsKey(node)) return;
    // Otherwise label the node with the current label.
    result[node] = label;
    // Explore all nodes reachable from here.
    for (var endpoint in g.edgesFrom(node)) {
      secondDFS(endpoint, g, result, label);
    }
  }
}