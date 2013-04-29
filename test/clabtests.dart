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
    test('test of hyperbolic functions', () => hyperbolicTests());
    test('test of randomized selection', () => randomSelectTests());
    test('test of complex number functions', () => complexTests());
    test('test of finding sum of 2 numbers', () => findSum2Tests());
    test('test of mergesort', () => mergeSortTests());
    test('test of quicksort', () => quickSortTests());
    test('test of fft', () => fftTests());
  });
}
