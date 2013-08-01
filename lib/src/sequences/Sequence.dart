// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Top level functions to generate sequences of sampled values.
 *
 * These functions all return objects of the Sequence class:
 * * Sequence sequence(Iterable list, [int repeat = 1])
 * * Sequence position(int length, int n0)
 * * Sequence zeros(var n)
 * * Sequence ones(var n)
 * * Sequence impseq(int n, int index, [n0 = 0])
 * * Sequence stepseq(int n, int index, [n0 = 0])
 * * Sequence seqshift(Sequence position, int shift)
 * * Sequence seqfold(Sequence seq2fold, {position: false})
 *
 * Examples:
 *     var list = [1, 2, 3, 4];
 *     var seq1 = sequence(list);
 *     print(seq1 is Sequence);
 *     print(seq1);
 *     var seq2 = sequence(list.map((element) => element * 2));
 *     print(seq2);
 *     var seq3 = seq1 + seq2;
 *     print(seq3);
 *     print(sequence(seq1, 4));
 *     for(var element in seq3) {
 *       print(element);
 *     }
 *     var myposition = position(13, 2);
 *     print(myposition);
 *     var myshiftedposition = seqshift(myposition, 5);
 *     print(myshiftedposition);
 *     print(seqfold(myposition, position:true));
 *
 */

/// Creates a new sequence from Iterable list.
/// Make the sequence periodic by specifying the number of periods
/// with optional named parameter repeat.
Sequence sequence(Iterable list, [int repeat = 1]) {
  List temp = [];
  for (var i = 0; i < repeat; i++) {
    temp.addAll(list);
  }
  return new Sequence()..addAll(temp);
}

Sequence position(int length, int n0) {
  return new Sequence()..addAll(new List.generate(length, (var index) =>
      (index - n0), growable:false));
}

/// Creates a sequence of zeros of length n.
Sequence zeros(var n) => new Sequence()..addAll(new List.filled(n, 0));

/// Creates a sequence of ones of length n.
Sequence ones(var n) => new Sequence()..addAll(new List.filled(n, 1));

/// Creates a unit impulse sequence of length n.
/// The index parameter is referenced to delta(n - n0).
Sequence impseq(int n, int index, [n0 = 0]) => new Sequence()
    ..addAll(new List.generate(n, (j) => j == n0 - index ? 1 : 0));

/// Generates a unit step sequence of length n.
/// The index parameter is referenced to u(n - n0).
Sequence stepseq(int n, int index, [n0 = 0]) => new Sequence()
    ..addAll(new List.generate(n, (j) => j >= n0 - index ? 1 : 0));

/// Shifts a positional sequence by amount given by shift.
/// Returns a positional vector representing x(n) -> x(n - shift).
Sequence seqshift(Sequence position, int shift) => position + shift;

/// Flips a squence about it's zero index point.  Negates
/// the sequence if position set to true.
/// Represents y(n) -> x(-n)
/// TODO: Does this need to flip around the n0 point?
Sequence seqfold(Sequence seq2fold, {position: false}) {
  if (!position) {
    return sequence(seq2fold.reversed);
  } else {
    return sequence(seq2fold.reversed) * -1;
  }
}

/// Adds sequences of different lengths and/or with differing n0 indices.
List addSeqs(List seq1, List seq2, [int n01 = 0, int n02 = 0]) {
  // TODO
}

/// Multiplies sequences of different lengths and/or with differing n0 indices.
List multSeqs(List seq1, List seq2, [int n01 = 0, int n02 = 0]) {
  // TODO
}

/**
 * A class to represent a sequence of sampled values.
 *
 * This class extends from ListBase plus adds support for the '+', '-',
 * '/', and '*' operators.  These are element by element operations for
 * sequences of equal length and with the same n0 index.
 *
 * The class is tightly coupled to several top level functions:
 * * Sequence sequence(Iterable list, [int repeat = 1])
 * * Sequence zeros(var n)
 * * Sequence ones(var n)
 * * Sequence impseq(int n, int index, [n0 = 0])
 * * Sequence stepseq(int n, int index, [n0 = 0])
 *
 */

class Sequence<E> extends ListBase<E> {
  final sequence = new List();

  /// Getter length returns the length of the sequence.
  int get length => sequence.length;

  /// Setter length sets the length of the sequence.
  void set length(int length) {
    sequence.length = length;
  }

  // Implemented operators.
  /// Sets the entry at the given index in the list to value.
  void operator[]=(int index, E value) {
    sequence[index] = value;
  }

  /// Returns the element at the given index in the list.
  /// Throws RangeError if index is out of bounds.
  E operator [](int index) => sequence[index];

  // Overriden operators.  These operators perform element
  // by element operations only.
  /// Override '+' operator allows added two sequences
  /// or a constant to a sequence.
  //@override
  Sequence operator +(Object y) {
    var temp;
    if (y is num) {
      // Add y to each element in Sequence.
      temp = this.map((i) => i + y);
    } else if (y is Sequence) {
      // Perform sample by sample addition of (this) + y.
      temp = new List(y.length);
      Sequence x = this;
      for (var i = 0; i < x.length; i++) {
        temp[i] = x[i] + y[i];
      }
    }
    return new Sequence()..addAll(temp);
  }

  /// Override '-' operator allows subtracting two sequences
  /// or a constant from a sequence.
  //@override
  Sequence operator -(Object y) {
    var temp;
    if (y is num) {
      // Subtract y from each element in Sequence.
      temp = this.map((i) => i - y);
    } else if (y is Sequence) {
      // Perform sample by sample subtraction of (this) - y.
      temp = new List(y.length);
      Sequence x = this;
      for (var i = 0; i < x.length; i++) {
        temp[i] = x[i] - y[i];
      }
    }
    return new Sequence()..addAll(temp);
  }

  /// Override '*' operator allows multiplying two sequences
  /// or a sequence by a constant.
  //@override
  Sequence operator *(Object y) {
    var temp;
    if (y is num) {
      // Scale sequence by y.
      temp = this.map((i) => y * i);
    } else if (y is Sequence) {
      // Perform sample by sample multiplication of (this) * y.
      temp = new List(y.length);
      Sequence x = this;
      for (var i = 0; i < x.length; i++) {
        temp[i] = x[i] * y[i];
      }
    }
    return new Sequence()..addAll(temp);
  }

  /// Override '/' operator allows dividing two sequences
  /// or a sequence by a constant.
  //@override
  Sequence operator /(Object y) {
    var temp;
    if (y is num) {
      // Scale sequence by y.
      temp = this.map((i) => y / i);
    } else if (y is Sequence) {
      // Perform sample by sample division of (this) * y.
      temp = new List(y.length);
      Sequence x = this;
      for (var i = 0; i < x.length; i++) {
        temp[i] = x[i] / y[i];
      }
    }
    return new Sequence()..addAll(temp);
  }
  /// Getter iterator returns an iterator to the sequence
  /// to allow traversing the elements in the sequence.
  Iterator get iterator => sequence.iterator;
}