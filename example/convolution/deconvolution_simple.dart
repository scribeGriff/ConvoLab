// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example computing the deconvolution of two sequences, numerator and denominator.
 *
 * Examples using the function deconv() to compute the
 * Deconvoution of two non-casual signals whose polynomial
 * coefficients are defined in numerator and denominator and whose
 * position sequences are given by nn and dn.  Outputs the string
 * in latex format.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  // Example 1. Standard deconvolution with quotient and remainder.
  // numerator = z^2 + z + 1 + z^-1 + z^-2 +z^-3
  Sequence numerator = sequence([1, 1, 1, 1, 1, 1]);
  // Zeroth element is element 2.
  Sequence nn = numerator.position(2);
  // den = z + 2 + z^-1
  var denominator = sequence([1, 2, 1]);
  // Zeroth element is element 1.
  var dn = denominator.position(1);
  // Compute h = num / den and output quotient and remainder.
  var h = deconv(numerator, denominator, nn, dn);
  print('The quotient is ${h.q}');
  print('The remainder is ${h.r}');
  print(h.qn);
  print(h.rn);
  print(h.format('latex', 'z', 'h'));

  // Prints:
  // The quotient is [1, -1, 2, -2]
  // The remainder is [0, 0, 0, 0, 3, 3]
  // [-1, 0, 1, 2]
  // [-2, -1, 0, 1, 2, 3]
  // $$h(z) = z - 1 + 2z^{-1} - 2z^{-2} + \frac{3z^{-2} + 3z^{-3}}{z + 2 + z^{-1}}$$
  //
  // This corresponds to the following result for h:
  // h(z) = z - 1 + 2z^-1 - 2z^-2 + (3z^-2 + 3z^-3 / z + 2 + z^-1)

  // Example 2: Deconvolution where the degree of the numerator is less
  // than the degree of the denominator.  We simply swap the numerator
  // and denominator of the previous example.

  h = deconv(denominator, numerator, dn, nn);
  print('The quotient is ${h.q}');
  print('The remainder is ${h.r}');
  print(h.format('latex', 'z', 'h'));

  // Prints:
  // The quotient is []
  // The remainder is [1, 2, 1]
  // $$h(z) = \frac{z + 2 + z^{-1}}{z^{2} + z + 1 + z^{-1} + z^{-2} + z^{-3}}$$

  // Example 3:  Deconvolution where there is no remainder and the sequences
  // are causal (ie, their position sequence starts at n = 0).

  numerator = sequence([6, 17, 34, 43, 38, 24]);
  denominator = sequence([2, 3, 4]);

  // Compute h = num / den and output quotient and remainder.
  h = deconv(numerator, denominator);
  print('The quotient is ${h.q}');
  print('The remainder is ${h.r}');
  print(h.format('latex', 'z', 'h'));

  // Prints:
  // The quotient is [3, 4, 5, 6]
  // The remainder is [0, 0, 0, 0, 0, 0]
  // $$h(z) = 3 + 4z^{-1} + 5z^{-2} + 6z^{-3}}$$
}