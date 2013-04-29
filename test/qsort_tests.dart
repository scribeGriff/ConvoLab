// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of clabtests;

/**
 * Unit testing of QuickSort algorithm.
 */

void quickSortTests() {
  // QuickSort
  int comparisons;
  QsortResults qsResults;
  List<int> list10;
  List<int> auData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  group('QuickSort algorithm tests:', (){
    test('QuickSort of small internal array - maximum comparisons', (){
      comparisons = 19;
      List<int> dataList = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
      qsResults = qsort(dataList);
      expect(qsResults, isNotNull);
      expect(qsResults.value, equals(comparisons));
      expect(qsResults.data, equals(auData));
    });
  });
}
