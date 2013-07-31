// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Creates a row vector of type List.
 * * vec(start, end, [increment = 1]) - creates a fully specified vector
 *   beginning at start, going to end, in steps of increment.
 *
 */

/// Generates a fully specified vector.
List vec(num start, num end, [num increment = 1])
    => new _RowVector(start, end, increment).createVec();

class _RowVector {
  final num start;
  final num end;
  final num increment;

  const _RowVector(this.start, this.end, this.increment);

  List createVec() {
    List a = [];
    for (var i = start; i <= end; i += increment) {
        a.add(i);
      }
    return a;
  }
}