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
 * Dependencies: dart:collection, DirectedGraph, StackBuffer.
 * Reference: Kosaraju.java from Keith Schwarz (htiek@cs.stanford.edu)
 */

class _Kosaraju {
  static var offset;
  static var scale;

  HashMap computeSCC(DirectedGraph g, {DirectedGraph grev, bool negIndex: false}) {
    /// Create the result map and a counter to keep track of which
    /// depth first search iteration this is.
    HashMap result = new HashMap();
    int iteration = 0;
    if (!negIndex) {
      offset = 0;
      scale = 1;
    } else {
      offset = g.length;
      scale = 2;
    }

    /// Run a depth-first search in the reverse graph to get the order in
    /// which the nodes should be processed and save the results in a queue.
    if (grev == null) {
      grev = transformGraph(g);
    }
    ListQueue visitOrder = initFirstDFS(grev);

    /// Continuously process the the nodes from the queue by running a
    /// depth first search from each unmarked node encountered.
    List resultHasKey = new List.filled(scale * g.length + 1, false);
    while (!visitOrder.isEmpty) {
      // If the last node has already been visited, ignore it and
      // continue on with the next node in the queue until empty.
      var startPoint = visitOrder.removeLast();
      if (resultHasKey[startPoint + offset]) {
        continue;
      }
      // Otherwise, run a depth first search from the node contained in
      // startPoint, updating the result map with everything visited as being
      // at the current iteration level.
      secondDFS(startPoint, g, result, iteration, resultHasKey);
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
    List visited = new List.filled(scale * g.length + 1, false);
    // Perform a DFS for each node in g and whose origin is given by node.
    for (var node in g) {
      if (!visited[node + offset]) {
        firstDFS(node, g, visitOrder, visited);
      }
    }
    return visitOrder;
  }

  /// Iteratively explores the given node with a DFS, adding it to the output
  /// list once the exploration is complete.
  void firstDFS(var node, DirectedGraph g, ListQueue visitOrder, var visited) {
    // Define an explicit stack of type StackEntry and
    // set its initial value to null.
    StackBuffer stack = null;
    var i = 0;
    bool flag = visited[node + offset] ? false : true;
    // Explicit stack while loop.
    while (true) {
      if (i == 0) {
        visited[node + offset] = flag;
      }
      var children = g.edgesFrom(node).toList();
      var n = children.length;
      // Main iteration loop, loops though children.
      for (; i < n; i++) {
        var child = children[i];
        if (visited[child + offset] != flag) {
          stack = new StackBuffer(node, i + 1, stack);
          node = child;
          i = 0;
          break;
        }
      }
      // If we iterate until no more children to explore,
      // add this node to the visit order.
      if (i == n) {
        visitOrder.addLast(node);
        if (stack == null) {
          return;
        }
        node = stack.node;
        i = stack.index;
        stack = stack.next;
      }
    }
  }

  // Step 3:
  /// Iteratively mark all nodes reachable from the given node
  /// by a DFS with the current label.
  void secondDFS(var node, DirectedGraph g, HashMap result, int label,
                 List resultHasKey) {
    ListQueue stack = new ListQueue();
    stack.add(node);
    while (!stack.isEmpty) {
      var child = stack.removeLast();
      if (!resultHasKey[child + offset]) {
        resultHasKey[child + offset] = true;
        result[child] = label;
        for (var endpoint in g.edgesFrom(child)) {
          if (!resultHasKey[endpoint + offset]) {
            stack.add(endpoint);
          }
        }
      }
    }
  }
}

/// StackBuffer is a simple data structure that keeps track of stack
/// variables when performing an iterative DFS using an explicit stack.
class StackBuffer {
  final index;
  final node;
  final next;

  StackBuffer(this.node, this.index, this.next);
}