// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Several classes to create specific vectors, including:
 * * ones(n) - creates a row vector containing 1s for length n.
 * * zeros(n) - creates a row vector containing 0s for length n.
 * * vec(start, end, [increment = 1]) - creates a fully specified vector
 *   beginning at start, going to end, in steps of increment.
 *
 */

/// Generates a vector of all 1s equal to length.
List ones(int length) => new List.filled(length, 1);

/// Generates a vector of all 0s equal to length.
List zeros(int length) => new List.filled(length, 0);

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