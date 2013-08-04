// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Decompose a sequence into its even and odd components.
 *
 * Example:
 *     var step1 = stepseq(11, 0);
 *     var step2 = stepseq(11, 10);
 *     var x = step1 - step2;
 *     var n = x.position(0);
 *     print(x);
 *     print(n);
 *     var eo = evenodd(x, n);
 *     print(eo.even);
 *     print(eo.odd);
 *     print(eo.n);
 *
 */

EvenOddSeqResults evenodd(Sequence x, Sequence n) {
  var m = foldseq(n, negate:true);
  var m1 = math.min(m.min(), n.min());
  var m2 = math.max(m.max(), n.max());
  m = sequence(vec(m1, m2));
  var nm = n.first - m.first;
  var x1 = zeros(m.length);
  x1.setAll(nm, x);
  var xe = (x1 + foldseq(x1)) * 0.5;
  var xo = (x1 - foldseq(x1)) * 0.5;

  return new EvenOddSeqResults(xe, xo, m);
}


/// Returns a sample sequence as even and odd components
/// and a sample position sequence as n.
class EvenOddSeqResults extends ConvoLabResults {
  final Sequence even;
  final Sequence odd;
  final Sequence n;

  EvenOddSeqResults(this.even, this.odd, this.n);
}