/* *************************************************************** *
 *   Unit testing of MergeSort                                     *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

void mergeSortTests() {
  // MergeSort
  // number of inversions = n chose 2 = n(n-1)/2
  String filename = "tests/samples/inversion_list.txt";
  int inversions;
  MSortResults msResults;
  List<int> list10;
  List<int> auData = [1, 2, 3, 4, 5, 6, 7,8, 9, 10];
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
      inversions = dataList.length * (dataList.length - 1) >> 1;
      msResults = msort(dataList);
      expect(msResults, isNotNull);
      expect(msResults.value, equals(inversions));
      expect(msResults.data, equals(auData));
    });
    test('MergeSort of a large external array', (){
      inversions = 2407905288;
      msResults = msort(filename);
      list10 = msResults.data.getRange(0, 10);
      expect(msResults, isNotNull);
      expect(msResults.value, equals(inversions));
      expect(list10, equals(auData));
    });
  });
}
