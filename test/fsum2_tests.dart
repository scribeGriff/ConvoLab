part of clabtests;

/* *************************************************************** *
 *   Unit testing of finding the sum of 2 numbers in a list        *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

void findSum2Tests() {
  group('Finding the sum of 2 numbers in a list tests:', (){
    test('FindSum2: no duplicates, single sum to match:', (){
      List<int> dataList = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
      List<List<int>> auData = [[6, 10], [7, 9]];
      int sum = 16;
      var findSum = fsum2(dataList, sum);
      expect(findSum, isNotNull);
      expect(findSum.value, equals(dataList.length));
      expect(findSum.results, equals(auData));
      expect(findSum.match, isTrue);
    });
    test('FindSum2: duplicates, single sum to match:', (){
      List<int> dataList = [1, 1, 1, 1, 1, 1, 1];
      List<List<int>> auData = [[1, 1], [1, 1], [1, 1]];
      int sum = 2;
      var findSum = fsum2(dataList, sum);
      expect(findSum, isNotNull);
      expect(findSum.value, equals(1));
      expect(findSum.results, equals(auData));
      expect(findSum.match, isTrue);
    });
  });
}
