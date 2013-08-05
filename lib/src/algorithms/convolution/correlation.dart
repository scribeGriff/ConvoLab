// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Perform crosscorrelation or autocorrelation.
 *
 * Example:TODO
 *
 */

// TODO: Should we pass position sequences or zero indices?  Passing both
// for now since conv() expects index, but need to move toward seqences only.
CorrResults corr(Sequence seq1, Sequence pos1, Sequence seq2, Sequence pos2,
                 int index1, int index2) {
  var seqsum = addSeqs(seq1, pos1, seq2, pos2);
  var flipseq1 = foldseq(seq1);
  var flippos1 = foldseq(pos1, negate:true);
  var seq1xseq2 = conv(seq1.toList(), seq2.toList(), index1, index2);
  return new CorrResults(sequence(seq1xseq2.data), sequence(seq1xseq2.time));

}

/// Returns a sample sequence as x and a sample position
/// sequence as n.
class CorrResults extends ConvoLabResults {
  final Sequence x;
  final Sequence n;

  CorrResults(this.x, this.n);
}

