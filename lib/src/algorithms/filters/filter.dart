// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Implements a 1D transposed direct form II digital filter structure.
 *
 * Supports FIR and IIR filters and inital and final conditions.
 *
 * Example usage - Calculate the impulse response of the following filter:
 *     var x = impseq(141, 20);
 *     var n = x.position(20);
 *     var b = sequence([1]);
 *     var a = sequence([1, -1, 0.9]);
 *     var h = filter(b, a, x);
 *     print(h.x);
 *
 */

FilterResults filter(Sequence b, Sequence a, Sequence x, [Sequence z]) {
  var n = math.max(a.length, b.length);
  // TODO Pad a or b with 0s as necessary to make a.length = b.length.
  if (z == null) z = zeros(n);
  Sequence y = zeros(x.length);
  for (var i = 0; i < y.length; i++) {
    y[i] = b[0] * x[i] + z[0];
    for (var j = 1; j < n; j++) {
      z[j - 1] = b[j] * x[i] + z[j] - a[j] * y[i];
    }
  }
  return new FilterResults(y, z);
}

//n    = length(a);
//z(n) = 0;
//Y    = zeros(size(X));
//for m = 1:length(Y)
//   Y(m) = b(1) * X(m) + z(1);
//   for i = 2:n
//      z(i - 1) = b(i) * X(m) + z(i) - a(i) * Y(m);
//   end
//end
//z = z(1:n - 1);

/// Returns a sample sequence as x and a sample position
/// sequence as n.
class FilterResults extends ConvoLabResults {
  final Sequence x;
  final Sequence n;

  FilterResults(this.x, this.n);
}