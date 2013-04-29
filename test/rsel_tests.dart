part of clabtests;

/**
 * Unit testing of randomized selection algorithm.
 */

void randomSelectTests() {
  //Random Selection algorithm
  int order;
  group('Randomized Selection algorithm tests:', (){
    test('5th highest order from list', (){
      List<int> dataList = [75, 22, 84, 121, 16, 3, 67, 42, 17, 91];
      order = 5;
      var topFive = rsel(dataList, order, true);
      expect(topFive, isNotNull);
      expect(topFive.value, equals(67));
      expect(topFive.data, hasLength(order));
      expect(topFive.count, inExclusiveRange(topFive.input.length,
        topFive.input.length*log2(topFive.input.length)));
    });
  });
}
