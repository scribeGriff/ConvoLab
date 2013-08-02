// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * A class to represent a sequence of sampled values.
 *
 * This class extends from ListBase plus adds support for the '+', '-',
 * '/', and '*' operators.  These are element by element operations for
 * sequences of equal length and with the same n0 index.
 *
 * The class is tightly coupled to several top level functions:
 * * Sequence sequence(Iterable list, [int repeat = 1])
 * * Sequence position(int length, int n0)
 * * Sequence zeros(var n)
 * * Sequence ones(var n)
 * * Sequence impseq(int n, int index, [n0 = 0])
 * * Sequence stepseq(int n, int index, [n0 = 0])
 * * Sequence shiftseq(Sequence position, int shift)
 * * Sequence foldseq(Sequence seq2fold, {position: false})
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

  /// Class methods.
  /// Create a position vector (n) for this sequence given n0.
  Sequence position(int n0) {
    return new Sequence()..addAll(new List.generate(this.length, (var index) =>
        (index - n0), growable:false));
  }

  /// Calculate the minimum value of a sequence.
  num min() => this.fold(this.first, math.min);

  /// Calculate the maximum value of a sequence.
  num max() => this.fold(this.first, math.max);

  /// Calculate the sum of a sequence.
  num sum() => this.reduce((value, element) => value + element);

  /// Calculate the prod of a sequence.
  num prod() => this.reduce((value, element) => value * element);

  /// Calculate the energy of a sequence.
  num energy() => this.map((element) => (element * element).abs())
      .reduce((value, element) => value + element);

  /// Calculate the power of a sequence.
  num power() => this.energy() / this.length;

  /// Getter iterator returns an iterator to the sequence
  /// to allow traversing the elements in the sequence.
  Iterator get iterator => sequence.iterator;
}