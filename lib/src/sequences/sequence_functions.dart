// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Top level functions to generate sequences of sampled values.
 *
 * These functions all return objects of the Sequence class or the
 * SequenceResults class:
 * * Sequence sequence(Iterable list, [int repeat = 1])
 * * Sequence position(int length, int n0)
 * * Sequence zeros(var n)
 * * Sequence ones(var n)
 * * Sequence impseq(int n, int n0)
 * * Sequence stepseq(int n, int n0)
 * * Sequence shiftseq(Sequence position, int shift)
 * * Sequence foldseq(Sequence seq2fold, {negate: false})
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
 *     var myshiftedposition = shiftseq(myposition, 5);
 *     print(myshiftedposition);
 *     print(foldseq(myposition, position:true));
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

/// Generates a sample position sequence (n) given the length of a sample
/// sequence and the position of n0.  This function also exists as a method
/// of the Sequence class.
Sequence position(int length, int n0) {
  return new Sequence()..addAll(new List.generate(length, (var index) =>
      (index - n0), growable:false));
}

/// Creates a sequence of zeros of length n.
Sequence zeros(var n) => new Sequence()..addAll(new List.filled(n, 0));

/// Creates a sequence of ones of length n.
Sequence ones(var n) => new Sequence()..addAll(new List.filled(n, 1));

/// Creates a unit impulse sequence of length n.
/// The impulse is referenced to delta(n - n0).
Sequence impseq(int n, int n0) => new Sequence()
    ..addAll(new List.generate(n, (j) => j == n0 ? 1 : 0));

/// Generates a unit step sequence of length n.
/// The transistion is referenced to u(n - n0).
Sequence stepseq(int n, int n0) => new Sequence()
    ..addAll(new List.generate(n, (j) => j >= n0 ? 1 : 0));

/// Shifts a positional sequence by amount given by shift.
/// Returns a positional vector representing x(n) -> x(n - shift).
/// TODO: Should this be a method of a sequence?
Sequence shiftseq(Sequence position, int shift) => position + shift;

/// Flips a squence about it's zero index point.  Negates
/// the sequence if position set to true.
/// Represents y(n) -> x(-n)
/// TODO: Should this be a method of a sequence?
Sequence foldseq(Sequence seq2fold, {negate: false}) {
  if (!negate) {
    return sequence(seq2fold.reversed);
  } else {
    return sequence(seq2fold.reversed) * -1;
  }
}

