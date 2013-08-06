// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * ConvoLab is a library of mostly signal processing algorithms.
 *
 * To use the library, add the following to your pubspec.yaml:
 *
 *     convolab:
 *       git: git://github.com/scribeGriff/ConvoLab.git
 *
 * After successfully running pub install, import the library as follows:
 *
 *     import 'package:convolab/convolab.dart';
 *
 * Library access is largely through top level function calls rather than
 * constructor methods.
 *
 */

library convolab;

import 'dart:math' as math;
import 'dart:json' as json;
import 'dart:collection';
import 'dart:async';

//import 'package:meta/meta.dart';

part 'src/exceptions/convolab_exception.dart';
part 'src/exceptions/data_format_exception.dart';
part 'src/exceptions/no_such_element_exception.dart';

part 'src/utilities/convolab_results.dart';
part 'src/utilities/poly_string.dart';

part 'src/algorithms/sorting/quicksort.dart';
part 'src/algorithms/sorting/mergesort.dart';
part 'src/algorithms/selection/find_sum2.dart';
part 'src/algorithms/selection/randomized_selection.dart';
part 'src/algorithms/fourier/fft.dart';
part 'src/algorithms/fourier/ifft.dart';
part 'src/algorithms/fourier/partial_sums.dart';
part 'src/algorithms/convolution/convolution.dart';
part 'src/algorithms/convolution/deconvolution.dart';
part 'src/algorithms/convolution/correlation.dart';

part 'src/math/lists.dart';
part 'src/math/complex.dart';
part 'src/math/hyperbolic.dart';
part 'src/math/logarithm.dart';
part 'src/math/row_vector.dart';
part 'src/math/find_min_max.dart';

part 'src/signals/waveforms.dart';

part 'src/sequences/sequence.dart';
part 'src/sequences/sequence_functions.dart';
part 'src/sequences/add_mult_seqs.dart';
part 'src/sequences/even_odd_seqs.dart';
part 'src/sequences/random_gaussian.dart';

void main() {
  Sequence x = sequence([3, 11, 7, 0, -1, 4, 2]);
  Sequence n = x.position(x.middle);
  print(x);
  print(n);
  Sequence nm2 = shiftseq(n, 2);
  print(nm2);
  Sequence w = rndseq(x.length);
  Sequence wn = nm2;
  print(wn);
  var seqsum = addseqs(x, nm2, w, wn);
  var xcorr = corr(x, n, seqsum.x, seqsum.n);
  print(xcorr.x);
  print(xcorr.n);

//  Sequence x = sequence([1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1]);
//  Sequence n = x.position(2);
//  print(n);
//  print(x);
//  Sequence n11 = shiftseq(n, 5);
//  Sequence n12 = shiftseq(n, -4);
//  print(n11);
//  print(n12);
//  var x1 = addseqs(x * 2, n11, x * -3, n12);
//  print(x1.y);
//  print(x1.n);

}