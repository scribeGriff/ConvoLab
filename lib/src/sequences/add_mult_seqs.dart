// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Add and multiply sequences of differing lengths and/or position.
 *
 *     var seq1 = sequence([1, 2, 3, 4]);
 *     var seq2 = sequence([8, 2, 3, 4]);
 *     var pos1 = seq1.position(2);
 *     var pos2 = seq2.position(-1);
 *     var addseqs12 = addSeqs(seq1, pos1, seq2, pos2);
 *     print(addseqs12.y);
 *     print(addseqs12.n);
 *
 */

/// Adds sequences of different lengths and/or with differing n0 indices.
AddMultSeqResults addSeqs(Sequence seq1, Sequence pos1, Sequence seq2,
                          Sequence pos2) {
  // Create a new sample position sequence, x(n), which will represent
  // the sum of the added sequences.
  var n = sequence(vec(math.min(pos1.min(), pos2.min()),
                       math.max(pos1.max(), pos2.max())));
  var y1 = zeros(n.length);
  var y2 = zeros(n.length);
  y1.setAll(n.indexOf(pos1.first), seq1);
  y2.setAll(n.indexOf(pos2.first), seq2);
  return new AddMultSeqResults(y1 + y2, n);

}

/// Multiplies sequences of different lengths and/or with differing n0 indices.
AddMultSeqResults multSeqs(Sequence seq1, Sequence pos1, Sequence seq2,
                           Sequence pos2) {
  // Create a new sample position sequence, x(n), which will represent
  // the sum of the added sequences.
  var n = sequence(vec(math.min(pos1.min(), pos2.min()),
                       math.max(pos1.max(), pos2.max())));
  var y1 = zeros(n.length);
  var y2 = zeros(n.length);
  y1.setAll(n.indexOf(pos1.first), seq1);
  y2.setAll(n.indexOf(pos2.first), seq2);
  return new AddMultSeqResults(y1 * y2, n);
}

/// Returns a sample sequence as y and a sample position
/// sequence as n.
class AddMultSeqResults extends ConvoLabResults {
  final Sequence y;
  final Sequence n;

  AddMultSeqResults(this.y, this.n);
}