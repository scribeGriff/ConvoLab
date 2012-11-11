part of convolab;

/* ****************************************************** *
 *   Creating Row Vectors                                 *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

// Wrapper to illiminate need for using new keyword.
List vec(num start, num end, [num increment = 1])
    => new RowVector(start, end, increment).newVector;

class RowVector {
  final num start;
  final num end;
  final num increment;

  const RowVector(this.start, this.end, this.increment);

  List get newVector => _create();

  List _create() {
    List a = [];
    for (var i = this.start; i <= this.end; i += this.increment) {
      a.add(i);
    }
    return a;
  }
}
