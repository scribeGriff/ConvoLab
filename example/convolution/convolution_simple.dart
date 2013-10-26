// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example computing the convolution of two sequences, x and h.
 *
 * This example uses the function conv() to compute the
 * convolution of two non-casual signals whose polynomial
 * coefficients are defined in Sequence x and Sequence h and whose
 * position sequences are given by n and nh.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  // x = 3z^3 + 11z^2 + 7z - z^-1 + 4z^-2 + 2z^-3
  Sequence x = sequence([3, 11, 7, 0, -1, 4, 2]);
  // The zeroth element is the middle element of x.
  Sequence n = x.position(x.middle);
  // h = 2z + 3 - 5z^-2 + 2z^-3 + z^-4
  Sequence h = sequence([2, 3, 0, -5, 2, 1]);
  // The zeroth element is element 1.
  Sequence nh = h.position(1);
  // Compute y = x * h
  var y = conv(x, h, n, nh);
  print(y.x);
  print(y.n);
  print('The time zero index for the results is ${y.n.indexOf(0)}.');
  // Output the results in latex format.
  print(y.format());

  // Prints:
  // [6, 31, 47, 6, -51, -5, 41, 18, -22, -3, 8, 2]
  // [-4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7]
  // The time zero index for the results is 4.
  // $$y(n) = 6n^{4} + 31n^{3} + 47n^{2} + 6n - 51 - 5n^{-1} + 41n^{-2} + 18n^{-3} - 22n^{-4} - 3n^{-5} + 8n^{-6} + 2n^{-7}$$
  //
  // This corresponds to the following result for y:
  // y = 6z^4 + 31z^3 + 47z^2 + 6z - 51 - 5z^-1 + 41z^-2 + 18z^-3 - 22z^-4 - 3z^-5 + 8z^-6 + 2z^-7
}
