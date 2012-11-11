part of clabtests;

/* *************************************************************** *
 *   Unit testing of QuickSort                                     *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

void quickSortTests() {
  // QuickSort
  // number of inversions = n chose 2 = n(n-1)/2 this might be mergesort
  String filename = "test/samples/unsorted_list.txt";
  int comparisons;
  QSortResults qsResults;
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
    test('Quicksort of external file - first element pivot', (){
      comparisons = 162085;
      qsResults = qsort(filename, 'first');
      list10 = qsResults.data.getRange(0, 10);
      expect(qsResults, isNotNull);
      expect(qsResults.value, equals(comparisons));
      expect(list10, equals(auData));
    });
    test('Quicksort of external file - last element pivot', (){
      comparisons = 164123;
      qsResults = qsort(filename, 'last');
      list10 = qsResults.data.getRange(0, 10);
      expect(qsResults, isNotNull);
      expect(qsResults.value, equals(comparisons));
      expect(list10, equals(auData));
    });
    test('Quicksort of external file - median of 3 element pivot', (){
      comparisons = 138382;
      qsResults = qsort(filename);  // defaults to median3
      list10 = qsResults.data.getRange(0, 10);
      expect(qsResults, isNotNull);
      expect(qsResults.value, equals(comparisons));
      expect(list10, equals(auData));
    });
  });
}
