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

part 'src/math/lists.dart';
part 'src/math/complex.dart';
part 'src/math/hyperbolic.dart';
part 'src/math/logarithm.dart';
part 'src/math/row_vector.dart';
part 'src/math/find_min_max.dart';

part 'src/signals/waveforms.dart';

part 'src/sequences/Sequence.dart';
part 'src/sequences/sequence_functions.dart';

void main() {
  var seq1 = sequence([1, 2, 3, 4]);
  var seq2 = sequence([8, 2, 3, 4, 8, 3]);
  var pos1 = seq1.position(2);
  var pos2 = seq2.position(-3);
  print(seq1);
  print(pos1);
  print(seq2);
  print(pos2);
  var seq3 = sequence(vec(math.min(pos1.min(), pos2.min()), math.max(pos1.max(), pos2.max())));
  print(seq3);
}