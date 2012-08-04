/* ****************************************************** *
 *   FSum2Results extends standard results class          *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class FSum2Results extends ConvoLabResults {
  List<List<int>> results;
  bool match;

  FSum2Results(List<int> data, int value, this.results, this.match) : super(data, value);
}
