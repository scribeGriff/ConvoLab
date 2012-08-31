/* *************************************************************** *
 *   Unit testing                                                  *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

#import('../lib/convolab.dart');

#import('package:unittest/unittest.dart');

#source('hyperbolic_tests.dart');
#source('rsel_tests.dart');
#source('complex_tests.dart');
#source('fsum2_tests.dart');
#source('msort_tests.dart');
#source('qsort_tests.dart');
#source('fft_tests.dart');

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
