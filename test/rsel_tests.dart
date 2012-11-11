part of clabtests;

/* *************************************************************** *
 *   Unit testing of randomized selection algorithm                *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

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
    test('12th lowest order from file', (){
      order = 12;
      String filename = "test/samples/unsorted_list.txt";
      var ostat = rsel(filename, order);
      expect(ostat, isNotNull);
      expect(ostat.value, equals(order));
      expect(ostat.data, hasLength(order));
      expect(ostat.count, inExclusiveRange(ostat.input.length,
          ostat.input.length*log2(ostat.input.length)));
    });
  });
}
