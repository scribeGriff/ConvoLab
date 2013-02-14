// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Examples using the function pstring() to format a List
 * to a polynomial string.  Formats supported are text,
 * html, latex.
 */

import 'package:convolab/convolab.dart';

void main() {

  List coefficients;
  String polyString;
  var zeroIndex;

  // 1.) Simple case - defaults
  coefficients = [2, 5, -3, 7];
  polyString = pstring(coefficients);
  print(polyString);
  // prints:
  // $$f(x) = 2 + 5x^{-1} - 3x^{-2} + 7x^{-3}$$

  // 2.) Setting options - html format
  polyString = pstring(coefficients, type: 'html', name: 'y', variable: 'n');
  print(polyString);
  // prints:
  // y(n) = 2 + 5n<sup>-1</sup> - 3n<sup>-2</sup> + 7n<sup>-3</sup>

  // 3.) Working with causal signals
  zeroIndex = 2;
  polyString = pstring(coefficients, index: zeroIndex, type: 'html',
      name: 'y', variable: 'n');
  print(polyString);
  // prints:
  // y(n) = 2n<sup>2</sup> + 5n - 3 + 7n<sup>-1</sup>

  // 4.) Another example working with causal signals
  coefficients = [1, 1, 1, 1, 1, 1];
  polyString = pstring(coefficients, index: zeroIndex, type: 'text');
  print(polyString);
  // prints:
  // f(x) = x^2 + x + 1 + x^-1 + x^-2 + x^-3
}