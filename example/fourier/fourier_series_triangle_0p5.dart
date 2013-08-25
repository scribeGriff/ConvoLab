// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Example using the function fsps() to compute the partial sum
 * of the Fourier series of three cycles of a triangle wave for a period
 * of half the length of the data specified in waveform.  The
 * number of partial sums is contained in the list kvals.  The result
 * could be plotted to a canvas (using library convoweb) or saved to
 * a file (using convohio).
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  var waveform = triangle(3).toList();
  var kvals = [10, 40, 80];
  var fourier = fsps(waveform, kvals, 0.5);
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
