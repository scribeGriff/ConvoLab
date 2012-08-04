/* *************************************************************** *
 *   Unit testing                                                  *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

#import('../lib/ConvoLab.dart');

#import('/C:/Users/Richard/Documents/development/Dart-Editor/dart/dart-sdk/lib/unittest/unittest.dart');

#source('hyperbolicTests.dart');
#source('randomSelectTests.dart');
#source('complexTests.dart');
#source('findSum2Tests.dart');
#source('mergeSortTests.dart');
#source('quickSortTests.dart');
#source('fftTests.dart');

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
