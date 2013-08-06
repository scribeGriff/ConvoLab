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
 *     Sequence wn = nm2;
 *     // Create noise corrupted and shifted signal.
 *     var seqsum = addseqs(x, nm2, w, wn);
 *     // Compute cross correlation between x(n) and y(n).
 *     var xcorr = corr(x, n, seqsum.x, seqsum.n);
 *     print(xcorr.x);
 *     print(xcorr.n);
 *
 */

// TODO: Need to move toward sequences only for convolution and deconvolution.
// TODO: Need to support autocorrelation and sequences with no position information.
CorrResults corr(Sequence seq1, Sequence pos1, Sequence seq2, Sequence pos2) {
  // Create x(-n).
  var flipseq1 = foldseq(seq1);
  var flippos1 = foldseq(pos1, negate:true);
  // Convolve y(n) with x(-n).
  var seq1xseq2 = conv(seq2.toList(), flipseq1.toList(), pos2.indexOf(0), flippos1.indexOf(0));
  return new CorrResults(sequence(seq1xseq2.data), sequence(seq1xseq2.time));

}

/// Returns a sample sequence as x and a sample position
/// sequence as n.
class CorrResults extends ConvoLabResults {
  final Sequence x;
  final Sequence n;

  CorrResults(this.x, this.n);
}

