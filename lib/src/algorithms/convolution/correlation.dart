// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Perform crosscorrelation or autocorrelation.
 *
 * Example:
 *     // x(n):
 *     Sequence x = sequence([3, 11, 7, 0, -1, 4, 2]);
 *     // n = -3, -2, -1, 0, 1, 2, 3.
 *     Sequence n = x.position(x.middle);
 *     // y(n) = x(n - 2) + w(n).
 *     // Shift n two places.
 *     Sequence nm2 = shiftseq(n, 2);
 *     // Generate gaussian noise.
 *     Sequence w = rndseq(x.length);
 *     Sequence wn = sequence(nm2);
 *     // Create noise corrupted and shifted signal.
 *     var seqsum = addseqs(x, w, nm2, wn);
 *     // Compute cross correlation between x(n) and y(n).
 *     var xcorr = corr(x, seqsum.x, n, seqsum.n);
 *     print(xcorr.x);
 *     print(xcorr.n);
 *
 *     prints:
 *     [5.020124415984023, 31.74811229652198, 54.337851908313304,
 *      13.297725982440669, -2.2771026999749457, 97.84500977600702,
 *      198.29340440790955, 100.54682848983684, -23.68238665566376,
 *      -17.35850051195083, 47.737359690914296, 33.80525231377048,
 *      5.819059373561337]
 *     [-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]
 *
 */

CorrResults corr(Sequence seq1, [Sequence seq2, Sequence pos1, Sequence pos2]) {
  if (seq2 == null) seq2 = sequence(seq1);  // This is the autocorrelation of a sequence.
  if (pos1 == null) pos1 = seq1.position(0);  // If no sequence is provided, assume n0 = 0.
  if (pos2 == null) pos2 = seq2.position(0);
  // Create x(-n).
  var flipseq1 = foldseq(seq1);
  var flippos1 = foldseq(pos1, negate:true);
  // Convolve y(n) with x(-n).
  var seq1xseq2 = conv(seq2, flipseq1, pos2, flippos1);
  return new CorrResults(seq1xseq2.x, seq1xseq2.n);

}

/// Returns a sample sequence as x and a sample position
/// sequence as n.
class CorrResults extends ConvoLabResults {
  final Sequence x;
  final Sequence n;

  CorrResults(this.x, this.n);
}