part of convolab;

/* ****************************************************** *
 *   RndSelResults extends standard results class         *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class RndSelResults extends ConvoLabResults {
  final List<int> input;
  final int count;

  RndSelResults(List<int> data, int value, this.count, [this.input]) :
      super(data, value);
}
