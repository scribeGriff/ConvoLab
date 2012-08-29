/* *********************************************************** *
 *   ConvoLab: A signal processing library in Dart             *
 *   https://github.com/scribeGriff/ConvoLab                   *
 *   Library: ConvoLab (c) 2012 scribeGriff                    *
 * *********************************************************** */

#library('ConvoLab');
#import('dart:io');
#import('dart:math');
#import('dart:json');

#source('exceptions/ConvoLabException.dart');
#source('exceptions/DataFormatException.dart');

#source('utilities/ConvoLabResults.dart');
#source('utilities/QSortResults.dart');
#source('utilities/MSortResults.dart');
#source('utilities/FSum2Results.dart');
#source('utilities/RndSelResults.dart');
#source('utilities/FFTResults.dart');
#source('utilities/InputListHandler.dart');
#source('utilities/ComplexInputListHandler.dart');

#source('algorithms/sorting/QuickSort.dart');
#source('algorithms/sorting/MergeSort.dart');
#source('algorithms/selection/FindSum2.dart');
#source('algorithms/selection/RandomizedSelection.dart');
#source('algorithms/fourier/FFT.dart');
#source('algorithms/fourier/IFFT.dart');

#source('math/convertList.dart');
#source('math/Complex.dart');
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