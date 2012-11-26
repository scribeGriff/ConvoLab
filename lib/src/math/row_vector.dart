part of convolab;

/* ****************************************************** *
 *   Creating Row Vectors                                 *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

// Wrapper to illiminate need for using new keyword.
List vec(num start, num end, [num increment = 1])
    => new _RowVector(start, end, increment).createVec(false);

// Generates a vector of all 1s.
List ones(num length) => new _RowVector(0, length, 1).createVec(true);

// Generates a vector of all 0s.
List zeros(num length) => new _RowVector(0, length, 0).createVec(true);

class _RowVector {
  final num start;
  final num end;
  final num increment;

  const _RowVector(this.start, this.end, this.increment);

  List createVec(bool unit) {
    List a = [];
    if (unit) {
      a.insertRange(start, end, increment);
    } else {
      for (var i = start; i <= end; i += increment) {
        a.add(i);
      }
    }
    return a;
  }
}
