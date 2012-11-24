library clabtests;

/* *************************************************************** *
 *   Unit testing                                                  *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

import 'package:convolab/convolab.dart';
import 'package:unittest/unittest.dart';

part 'hyperbolic_tests.dart';
part 'rsel_tests.dart';
part 'complex_tests.dart';
part 'fsum2_tests.dart';
part 'msort_tests.dart';
part 'qsort_tests.dart';
part 'fft_tests.dart';

void main() {
  group('All Tests:', (){
    test('test of hyperbolic functions', () => hyperbolicTests());
    test('test of randomized selection', () => randomSelectTests());
    test('test of complex number functions', () => complexTests());
    test('test of finding sum of 2 numbers', () => findSum2Tests());
    test('test of mergesort', () => mergeSortTests());
    test('test of quicksort', () => quickSortTests());
    test('test of fft', () => fftTests());
  });
}
