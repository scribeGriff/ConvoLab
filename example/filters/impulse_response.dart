// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Computing the impulse response of a digital filter.
 *
 * The filter is defined by the following difference equation:
 * y(n) - y(n - 1) + 0.9y(n - 2) = x(n)
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  // Define an impulse sequence.
  var x = impseq(141, 20);
  // Define a position sequence for the impulse.
  var n = x.position(20);
  // Define the numerator coefficient of the filter.
  var b = sequence([1]);
  // Define the denominator coefficient of the filter.
  var a = sequence([1, -1, 0.9]);
  // Compute the impulse response.
  var h = filter(b, a, x);
  // Print the response and the final conditions.
  print(h.x);
  print(h.z);
  // Determine the stability of the filter by calculating the sum(abs(h(n)).
  print(h.x.abs().sum());
}