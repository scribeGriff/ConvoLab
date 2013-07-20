// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of clabtests;

/**
 * Unit testing of MergeSort algorithm.
 */

void mergeSortTests() {
  // MergeSort
  // number of inversions = n chose 2 = n(n-1)/2
  int inversions;
  MsortResults msResults;
  List<int> list10;
  List<int> auData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  group('MergeSort algorithm tests:', (){
    test('MergeSort of small internal array - minimum inversions', (){
      List<int> dataList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      inversions = 0;
      msResults = msort(dataList);
      expect(msResults, isNotNull);
      expect(msResults.value, equals(inversions));
      expect(msResults.data, equals(auData));
    });
    test('MergeSort of small internal array - maximum inversions', (){
      List<int> dataList = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
      inversions = dataList.length * (dataList.length - 1) ~/ 2;
      msResults = msort(dataList);
      expect(msResults, isNotNull);
      expect(msResults.value, equals(inversions));
      expect(msResults.data, equals(auData));
    });
  });
}
