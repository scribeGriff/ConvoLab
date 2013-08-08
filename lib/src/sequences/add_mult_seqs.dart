// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Add, subtract and multiply sequences of differing lengths and/or position.
 *
 *     var seq1 = sequence([1, 2, 3, 4]);
 *     var seq2 = sequence([8, 2, 3, 4]);
 *     var pos1 = seq1.position(2);
 *     var pos2 = seq2.position(-1);
 *     var addseqs12 = addseqs(seq1, seq2, pos1, pos2);
 *     print(addseqs12.x);
 *     print(addseqs12.n);
 *
 */

/// Adds sequences of different lengths and/or with differing n0 indices.
AddMultSeqResults addseqs(Sequence seq1, Sequence seq2, Sequence pos1,
                          Sequence pos2) {
  // Create a new sample position sequence, x(n), which will represent
  // the sum of the added sequences.
  var n = sequence(vec(math.min(pos1.min(), pos2.min()),
                       math.max(pos1.max(), pos2.max())));
  var x1 = zeros(n.length);
  var x2 = zeros(n.length);
  x1.setAll(n.indexOf(pos1.first), seq1);
  x2.setAll(n.indexOf(pos2.first), seq2);
  return new AddMultSeqResults(x1 + x2, n);
}

/// Multiplies sequences of different lengths and/or with differing n0 indices.
AddMultSeqResults multseqs(Sequence seq1, Sequence seq2, Sequence pos1,
                           Sequence pos2) {
  // Create a new sample position sequence, x(n), which will represent
  // the product of the multiplied sequences.
  var n = sequence(vec(math.min(pos1.min(), pos2.min()),
                       math.max(pos1.max(), pos2.max())));
  var x1 = zeros(n.length);
  var x2 = zeros(n.length);
  x1.setAll(n.indexOf(pos1.first), seq1);
  x2.setAll(n.indexOf(pos2.first), seq2);
  return new AddMultSeqResults(x1 * x2, n);
}

/// Returns a sample sequence as y and a sample position
/// sequence as n.
class AddMultSeqResults extends ConvoLabResults {
  final Sequence x;
  final Sequence n;

  AddMultSeqResults(this.x, this.n);
}