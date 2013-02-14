// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example taking the fourier transform (fft())and the inverse fourier
 * transform (ifft()) of a simple array and printing the results.  The first
 * example shows format for printing complex numbers and the second
 * example shows passing an optional print title to the show() method.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  FftResults x, y;
  List<int> samples = [0, 1, 2, 3];
  y = fft(samples);
  if (y != null) {
    y.show();
    // prints:
    // 6.00
    // -2.00 + 2.00j
    // -2.00
    // -2.00 - 2.00j
    // Now compute the inverse fft:
    x = ifft(y.data);
    x.show("The inverse fft is:");
    // prints:
    // The inverse fft is:
    // 0.00
    // 1.00
    // 2.00
    // 3.00
  } else {
    print('There was an error computing the Fourier transform');
  }
}
