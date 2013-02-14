// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * A class to represent a directed graph.
 *
 * Provides methods for building and manipulating a directed graph, such as
 * addNode, addEdge, removeEdge, edgeExists, edgesFrom as well as an iterator
 * getter.  The graph is stored as a HashMap.
 *
 *     DirectedGraph dirgph = new DirectedGraph();
 *     List<List> vertices = new InputListHandler().
 *         array2d('lib/external/vertices.txt');
 *
 *     for (List list in vertices) {
 *       for (var element in list) {
 *         dirgph.addNode(element);
 *       }
 *     }
 *
 *     for (List list in vertices) {
 *       dirgph.addEdge(list[0], list[1]);
 *     }
 *
 * Reference: DirectedGraph.java from Keith Schwarz (htiek@cs.stanford.edu)
 *
 */

class DirectedGraph extends Iterable {
  final HashMap dGraph = new HashMap();

  /// Adds a new node to the graph.  If the node already exists, then the
  /// graph is unchanged.
  HashMap addNode(var node) {
    if (!dGraph.containsKey(node)) {
      dGraph[node] = new HashSet();
    }
  }

  /// Given a start and destination node, adds an arc from the start node
  /// to the destination.  If the edge already exists, then the graph is
  /// unchanged.  If either endpoint does not exist in the graph, throws a
  /// NoSuchElementException.

  HashMap addEdge(var start, var dest) {
    if (dGraph.containsKey(start) && dGraph.containsKey(dest)) {
      dGraph[start].add(dest);
    } else {
      throw new NoSuchElementException("Both nodes must be in the graph.");
    }
  }

  /// Removes the edge from start to dest from the graph.  If the edge does
  /// not exist, then returns the HashMap unchanged.  If either endpoint does
  /// not exist in the graph, throws a NoSuchElementException.
  HashMap removeEdge(var start, var dest) {
    if (dGraph.containsKey(start) && dGraph.containsKey(dest)) {
      dGraph[start].remove(dest);
    } else {
      throw new NoSuchElementException("Both nodes must be in the graph.");
    }
  }

  /// Given two nodes in the graph, returns whether there is an edge from
  /// the first node to the second node.  If either node does not exist in
  /// the graph, throws a NoSuchElementException.
  bool edgeExists(var start, var end) {
    if (dGraph.containsKey(start) && dGraph.containsKey(end)) {
      return dGraph[start].contains(end);
    } else {
      throw new NoSuchElementException("Both nodes must be in the graph.");
    }
  }

  /// Given a node in the graph, returns set of the edges leaving that
  /// node as a set of endpoints.  If the node doesn't exist, throws a
  /// NoSuchElementException.
  HashSet edgesFrom(var node) {
    final HashSet arcs = dGraph[node];
    if (arcs == null) {
      throw new NoSuchElementException("Source node does not exist.");
    } else {
      return arcs;
    }
  }

  /// Getter iterator returns an iterator to the directed graph's
  /// keys to allow traversing the nodes in the graph.
  Iterator get iterator => dGraph.keys.iterator;
}