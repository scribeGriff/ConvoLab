/* *********************************************************** *
 *   ConvoLab: A signal processing library in Dart             *
 *   https://github.com/scribeGriff/ConvoLab                   *
 *   Library: ConvoLab (c) 2012 scribeGriff                    *
 * *********************************************************** */

#library('convolab');
#import('dart:io');
#import('dart:math');
#import('dart:json');

#source('exceptions/convolab_exception.dart');
#source('exceptions/data_format_exception.dart');

#source('utilities/convolab_results.dart');
#source('utilities/qsort_results.dart');
#source('utilities/msort_results.dart');
#source('utilities/fsum2_results.dart');
#source('utilities/rsel_results.dart');
#source('utilities/fft_results.dart');
#source('utilities/input_handler.dart');
#source('utilities/complex_input_handler.dart');

#source('algorithms/sorting/quicksort.dart');
#source('algorithms/sorting/mergesort.dart');
#source('algorithms/selection/find_sum2.dart');
#source('algorithms/selection/randomized_selection.dart');
#source('algorithms/fourier/fft.dart');
#source('algorithms/fourier/ifft.dart');

#source('math/convert_list.dart');
#source('math/complex.dart');
#source('math/hyperbolic.dart');
#source('math/logarithm.dart');

void main() {
  List<int> dataList = [75, 22, 84, 121, 16, 3, 67, 42, 17, 91];
  int order = 5;
  var topFive = rsel(dataList, order, true);
  print(topFive.value);
  var a = complex(1,1);
  print(a.string);
}