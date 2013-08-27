// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Implements a 1D transposed direct form II digital filter structure.
 *
 * Supports FIR and IIR filters and inital and final conditions.
 *
 * A frequency domain description of this filter is as follows:
 *
 *              b(0) + b(1)z^-1 + ... + b(nb)z^-nb
 *     Y(z) = ______________________________________ * X(z)
 *                1 + a(1)z^-1 + ... +a(na)z^-na
 *
 * Throws range error if a(0) = 0 or if initial condition sequence z
 * is not equal to the larger of either length of a or the length of b.
 *
 * Example usage - Calculate the impulse response of the following filter:
 *
 *     var x = impseq(141, 20);
 *     var n = x.position(20);
 *     var b = sequence([1]);
 *     var a = sequence([1, -1, 0.9]);
 *     var h = filter(b, a, x);
 *     print(h.x);  // The filter response.
 *     print(h.z);  // The final conditions of the filter.
 *     print(h.x.abs().sum());  // The magnitude of the response.
 *
 * TODO: Normalize all coefficients if a[0] not equal to 1.
 *
 */

FilterResults filter(Sequence b, Sequence a, Sequence x, [Sequence z]) {
  if (a[0] == 0) {
    throw new RangeError("The coefficient a[0] can not be 0.");
  }
  var n = math.max(a.length, b.length);
  if (z == null) {
    z = zeros(n);
  } else if (z.length != n) {
    throw new RangeError("The intial condition sequence z is the wrong size.");
  }
  Sequence ai = sequence(a);
  Sequence bi = sequence(b);
  if (ai.length > bi.length) {
    bi.addAll(new List.filled(ai.length - bi.length, 0));
  } else if (bi.length > ai.length) {
    ai.addAll(new List.filled(bi.length - ai.length, 0));
  }
  if (z == null) z = zeros(n);
  Sequence y = zeros(x.length);
  for (var i = 0; i < y.length; i++) {
    y[i] = bi[0] * x[i] + z[0];
    for (var j = 1; j < n; j++) {
      z[j - 1] = bi[j] * x[i] + z[j] - ai[j] * y[i];
    }
  }
  return new FilterResults(y, z);
}

/// Returns the filtered results as sample sequence as x and a sequence
/// of final conditions of the filter.
class FilterResults extends ConvoLabResults {
  final Sequence x;
  final Sequence z;

  FilterResults(this.x, this.z);
}