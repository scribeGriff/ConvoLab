// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example computing the cross correlation of two sequences, x and h.
 *
 * This example uses the function corr() to compute the
 * cross correlation of two non-casual signals, one of which
 * is a shifted and noise corrupted version of the other.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  // x(n)
  Sequence x = sequence([3, 11, 7, 0, -1, 4, 2]);
  // n = -3 to 3
  Sequence n = x.position(x.middle);
  // x(n - 2)
  Sequence nm2 = shiftseq(n, 2);
  // Generate the noise.
  Sequence w = rndseq(x.length);
  // Noise position sequence is same as shifted signal sequence.
  Sequence wn = sequence(nm2);
  // Add the noise to the shifted signal
  var seqsum = addseqs(x, w, nm2, wn);
  // Perform a cross correlation of x(n) with x(n - 2) + w(n)
  var xcorr = corr(x, seqsum.x, n, seqsum.n);
  print(xcorr.x);
  print(xcorr.n);
  // The results will vary depending on the generated noise, but the
  // peak of the value of xcorr.x should occur at xcorr.n = 2.  This
  // is because we should expect the shifted and noise corrupted signal
  // to be similar to the original x shifted by two positions.
  // Example data:
  // [6.57698320963356, 36.135258349463726, 55.874594842805166,
  //  13.620111736765466, 11.72196548319097, 119.69615806019918,
  //  199.4755102106739, 104.41991018486324, 3.996000444733204,
  //  9.790590262005292, 42.644880715813386, 24.313075411901014,
  //  3.8995171374210584]
  // [-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]

}