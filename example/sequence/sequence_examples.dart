// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

/**
 * Examples generating and working with the Sequence class.
 *
 */

import 'package:convolab/convolab.dart';

void main() {
  // Creates a List object.
  var list = [1, 2, 3, 4];
  // Converts the List into a Sequence.
  var seq1 = sequence(list);
  // Check if seq1 is a Sequence.
  print(seq1 is Sequence);
  // Print the sequence.
  print(seq1);
  // Prints:
  // true
  // [1, 2, 3, 4]

  // Any Iterable, including another sequence, can be passed to the
  // sequence function.
  var seq2 = sequence(list.map((element) => element * 2));

  // Sequences can be added, subtracted, multiplied, and divided element
  // by element.
  var seq3 = seq1 + seq2;
  print(seq3);
  // Prints:
  // [3, 6, 9, 12]

  // Sequences can be made periodic:
  print(sequence(seq1, 4));
  // Prints:
  // [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]

  // A position sequence is a special kind of sequence to represent the
  // sample position of a sample sequence.  This kind of sequence can be
  // created two ways.
  // Arbitrary - place the zeroth element at position 2:
  print(position(13, 2));
  // Prints:
  // [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  // Or as a method of the Sequence class relative to a previously created
  // sequence:
  print(seq1.position(1));
  // Prints:
  //[-1, 0, 1, 2]

  // A position sequence can be shifted:
  var pos1 = seq1.position(1);
  var pos1shift = shiftseq(pos1, 8);
  print(pos1);
  print(pos1shift);
  // Prints:
  // [-1, 0, 1, 2]
  // [7, 8, 9, 10]

  // Or folded:
  print(foldseq(pos1));
  // Prints:
  // [2, 1, 0, -1]

  // or folded and negated:
  print(foldseq(pos1, negate:true));
  // Prints:
  // [-2, -1, 0, 1]

  // Given x(n), calculate x1(n) = 2x(n - 5) - 3x(n + 4)
  // x(n)
  Sequence x = sequence([1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1]);
  // n, zeroth position at element 2.
  Sequence n = x.position(2);
  // n - 5
  Sequence nm5 = shiftseq(n, 5);
  // n + 4
  Sequence np4 = shiftseq(n, -4);
  // x1(n) = 2x(n - 5) - 3x(n + 4)
  var x1 = addseqs(x * 2, x * -3, nm5, np4);
  print(x1.x);
  print(x1.n);
  // Prints:
  // [-3, -6, -9, -12, -15, -18, -21, -18, -15, -10, -5, 0, 5, 10, 12, 14, 12, 10, 8, 6, 4, 2]
  // [-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

  // shiftseq and foldseq are also methods of the Sequence class:
  var x2 = position(11, 5);
  print(x2);
  print(x2.shiftseq(2).foldseq(negate:true));
  // Prints:
  // [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
  // [-7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3]
}