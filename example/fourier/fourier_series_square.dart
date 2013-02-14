// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function fsps() to compute the partial sum
 * of the Fourier series of a single cycle of a square wave.  The
 * number of partial sums is contained in the list kvals.  The result
 * could be plotted to a canvas (using library convoweb) or saved to
 * a file (using convohio).
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  var waveform = square(1);
  var kvals = [1, 16, 80];
  var fourier = fsps(waveform, kvals);
  if (fourier != null) {
    print('We have computed ${fourier.psums.length} Fourier series.');
    if (fourier.psums[kvals[0]].every((element) => element is Complex)) {
      print('The computed Fourier series is of type Complex.');
    } else {
      print('The computed Fourier series is not Complex.');
    }
  } else {
    print('There was an error computing the Fourier series');
  }
}
