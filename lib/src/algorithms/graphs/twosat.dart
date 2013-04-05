// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the satisfiability of 2 variable clauses using Kosaraju's algorithm.
 *
 * Accepts a 2D array (List<List<int>>) of 2 variable clauses of the form
 * (A or B) - that is, a boolean expression in conjunctive normal form, 2-CNF.
 * Returns a boolean value indicating the satisfiability (or unsatisfiablilty)
 * of the input array.
 *
 * Example usage:
 *
 *     List<List> satfile = [[-1, -4],
 *                           [-2, -7],
 *                           [2, -6],
 *                           [2, 7],
 *                           [-6, 7],
 *                           [1, -5],
 *                           [1, 7],
 *                           [-5, 7],
 *                           [-1, -7],
 *                           [-3, 6],
 *                           [3, -4],
 *                           [3, -6],
 *                           [-4, -6],
 *                           [2, 5],
 *                           [-2, 3],
 *                           [-3, -5]];
 *
 *     twosat(satfile).then((isSat) {
 *       if (isSat) {
 *         print('The file is satisfiable.\n');
 *       } else {
 *         print('The file is not satisfiable.\n');
 *       }
 *     });
 *
 *     //prints:
 *     This file is not satisfiable.
 *
 * Dependencies:
 * * dart:collection
 * * class DirectedGraph
 * * class _Kosaraju
 *
 */

Future<bool> twosat(List<List> satlist) {
  // Check if the input data is valid.
  if (satlist == null || satlist.isEmpty) {
    throw new ArgumentError("Input data is not valid.");
  }
  // Variables.
  DirectedGraph clauses = new DirectedGraph();
  HashSet variables = new HashSet();

  /// Add each variable and its negation as a node
  /// to the directed graph clauses.
  for (List list in satlist) {
    for (var element in list) {
      clauses.addNode(element);
      clauses.addNode(-element);
      variables.add(element);
    }
  }
  /// Map each clause (A or B) to (-A ~> B) and (-B ~> A).
  for (List list in satlist) {
    clauses.addEdge(-list[0], list[1]);
    clauses.addEdge(-list[1], list[0]);
  }
  // If running up against max heap size, clear the input data
  // once graph and clauses have been created.
  if (satlist.length > 600000) {
    satlist.clear();
  }

  /// Compute the strongly connected components of the modified clauses in
  /// the directed graph clauses using Kosaraju's alogorithm.
  HashMap scc = new _Kosaraju().computeSCC(clauses, negIndex:true);

  /// Search through the strongly connected components.  If an element
  /// and its negation reside in the same strongly connected component,
  /// the clause is unsatisfiable.
  for (var element in variables) {
    if (scc[element] == (scc[-element])) {
      // Clauses are unsatisfiable.
      return new Future.of(() => false);
    }
  }
  /// Otherwise there is a variable that will satisfy all clauses.
  // Clauses are satisfiable.
  return new Future.of(() => true);
}

