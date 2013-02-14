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
 * Dependencies: dart:collection, DirectedGraph.
 * Reference: Kosaraju.java from Keith Schwarz (htiek@cs.stanford.edu)
 */

class _Kosaraju {

  HashMap stronglyConnectedComponents(DirectedGraph g) {

    /// Run a depth-first search in the reverse graph to get the order in
    /// which the nodes should be processed and save the results in a queue.
    Queue visitOrder = dfsVisitOrder(reverseGraph(g));

    /// Create the result map and a counter to keep track of which
    /// depth first search iteration this is.
    HashMap result = new HashMap();
    int iteration = 0;

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
      markReachableNodes(startPoint, g, result, iteration);
      // Increase the number of the next SCC to label.
      ++iteration;
    }
    return result;
  }

  /// Given a directed graph, return the reverse of that graph.
  DirectedGraph reverseGraph(DirectedGraph g) {
    DirectedGraph revg = new DirectedGraph();
    // Copy the nodes to revg graph.
    for (var node in g) {
      revg.addNode(node);
    }
    // Then copy the edges while reversing them.
    for (var start in g) {
      for (var end in g.edgesFrom(start)) {
        revg.addEdge(end, start);
      }
    }
    return revg;
  }

  /// Given a graph, returns a queue containing the nodes of that graph in
  /// the order in which a DFS of that graph finishes expanding the nodes.
  Queue dfsVisitOrder(DirectedGraph g) {
    // The resulting ordering of the nodes.
    Queue visorder = new Queue();
    // The set of nodes that we've visited so far.
    HashSet visited = new HashSet();
    // Perform a DFS for each node in g and whose origin is that node.
    for (var node in g) {
      recDFS(node, g, visorder, visited);
    }
    return visorder;
  }

  /// Recursively explores the given node with a DFS, adding it to the output
  /// list once the exploration is complete.
  void recDFS(var node, DirectedGraph g, Queue visorder, HashSet visited) {
    // If we've already been at this node, don't explore it again.
    if (visited.contains(node)) {
      return;
    } else {
      // Otherwise, mark that we've been here.
      visited.add(node);
    }
    // Recursively explore all the node's children.
    for (var endpoint in g.edgesFrom(node)) {
      recDFS(endpoint, g, visorder, visited);
    }
    // We're done exploring this node, so add it to the ordered queue of
    // visited nodes.
    visorder.addLast(node);
  }

  /// Recursively marks all nodes reachable from the given node by a DFS with
  /// the current label.
  void markReachableNodes(var node, DirectedGraph g, HashMap result,
                          int label) {
    // If we've visited this node before, stop the search.
    if (result.containsKey(node)) return;
    // Otherwise label the node with the current label, since it's
    // trivially reachable from itself.
    result[node] = label;
    // Explore all nodes reachable from here. */
    for (var endpoint in g.edgesFrom(node)) {
      markReachableNodes(endpoint, g, result, label);
    }
  }
}