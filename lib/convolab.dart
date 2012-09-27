/* *********************************************************** *
 *   ConvoLab: A signal processing library in Dart             *
 *   https://github.com/scribeGriff/ConvoLab                   *
 *   Library: ConvoLab (c) 2012 scribeGriff                    *
 * *********************************************************** */

#library ('convolab');

#import ('dart:io');
#import ('dart:math');
#import ('dart:json');

#source('src/exceptions/convolab_exception.dart');
#source('src/exceptions/data_format_exception.dart');

#source('src/utilities/convolab_results.dart');
#source('src/utilities/qsort_results.dart');
#source('src/utilities/msort_results.dart');
#source('src/utilities/fsum2_results.dart');
#source('src/utilities/rsel_results.dart');
#source('src/utilities/fft_results.dart');
#source('src/utilities/fsps_results.dart');
#source('src/utilities/input_handler.dart');
#source('src/utilities/double_input_handler.dart');
#source('src/utilities/complex_input_handler.dart');

#source('src/algorithms/sorting/quicksort.dart');
#source('src/algorithms/sorting/mergesort.dart');
#source('src/algorithms/selection/find_sum2.dart');
#source('src/algorithms/selection/randomized_selection.dart');
#source('src/algorithms/fourier/fft.dart');
#source('src/algorithms/fourier/ifft.dart');
#source('src/algorithms/fourier/partial_sums.dart');

#source('src/math/lists.dart');
#source('src/math/complex.dart');
#source('src/math/hyperbolic.dart');
#source('src/math/logarithm.dart');

#source('src/signals/waveforms.dart');