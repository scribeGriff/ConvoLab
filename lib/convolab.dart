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
import 'dart:collection';

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
part 'src/algorithms/filters/filter.dart';

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