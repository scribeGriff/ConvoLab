// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

library clabtests;

/**
 * Unit testing for ConvoLab library.
 *
 * Includes tests for the following library functions:
 * * hyperbolic functions
 * * randomized selection
 * * find sum of two numbers in a list
 * * mergesort
 * * quicksort
 * * fft/ifft
 * * complex numbers (not yet implemented)
 *
 */

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
    group('test of hyperbolic functions', () => hyperbolicTests());
    group('test of randomized selection', () => randomSelectTests());
    group('test of complex number functions', () => complexTests());
    group('test of finding sum of 2 numbers', () => findSum2Tests());
    group('test of mergesort', () => mergeSortTests());
    group('test of quicksort', () => quickSortTests());
    group('test of fft', () => fftTests());
  });
}
