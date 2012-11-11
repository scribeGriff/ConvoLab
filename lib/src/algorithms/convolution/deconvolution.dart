part of convolab;

/* **************************************************************** *
 *   Perform the deconvolution of two signals using polynomial      *
 *     long division.  Returns the quotient and remainder as lists. *
 *   Basic usage: var qrem = deconv(num, den);                      *
 *   num and den are the polynomial coefficients.                   *
 *   First coefficient assumed to be associated with highest        *
 *     power (ie, 2x^2 + 3x + 2).                                   *
 *   Accepts two optional parameters:                               *
 *     nindex is the t = 0 point for the numerator                  *
 *     dindex is the t = 0 point for the denominator                *
 *   Both indices assume the first element in a list is at i = 0    *
 *   By default, both indices are set to 0, and the sequences are   *
 *     assumed to be causal.                                        *
 *   Example optional usage: qrem = deconv(num, den, 2, 1);         *
 *   The sequences do not need to be the same length.               *
 *   Returns DeconvResults:                                         *
 *     q: List                                                      *
 *     qindex: int                                                  *
 *     qtime: List                                                  *
 *     r: List                                                      *
 *     rindex: int                                                  *
 *     rtime: List                                                  *
 *   Library: ConvoLab (c) 2012 scribeGriff                         *
 * **************************************************************** */

// Wrapper to illiminate need for using new keyword.
DeconvResults deconv(List num, List den, [int nindex = 0, int dindex = 0])
    => new _Deconvolution(num, den).deconvolve(nindex, dindex);

// Compute the deconvolution of two signals using polynomial division.
class _Deconvolution {
  final List num;
  final List den;

  _Deconvolution(this.num, this.den);

  DeconvResults deconvolve(int nindex, int dindex) {
    if (num != null && den != null) {
      final dLength = den.length;
      final nLength = num.length;
      final dDegree = dLength - 1;
      final nDegree = nLength - 1;
      final qindex = nindex - dindex;
      final rindex = nindex;
      final rtime = vec(-rindex, nDegree - dDegree);
      var qtime;

      var r = new List.from(num);

      // Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        var q = [0];
        qtime = vec(-qindex, q.length - 1 - qindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime);
      } else {
        var d = new List.from(den);
        var q = new List(nDegree - dDegree + 1);

        // Perform the long division.
        for (var k = 0; k <= nDegree - dDegree; k++) {
          q[k] = r[k] / den[0];
          if (q[k] == q[k].toInt()) q[k] = q[k].toInt();
          for (var j = k + 1; j <= dDegree + k; j++) {
            r[j] -= q[k] * den[j - k];
          }
        }

        for (var j = 0; j <= nDegree - dDegree; j++) {
          r[j] = 0;
        }
        qtime = vec(-qindex, q.length - 1 - qindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime);
      }
    } else {
      return null;
    }
  }

  // Not used but this algorithm accepts coefficients in the opposite
  // order as used by some implementations.
  DeconvResults deconvolve_alternate(int nindex, int dindex) {
    if (num != null && den != null) {
      final dLength = den.length;
      final nLength = num.length;
      final dDegree = dLength - 1;
      final nDegree = nLength - 1;
      final qindex = nindex - dindex;
      final rindex = nindex;
      final rtime = vec(-rindex, nLength - 1);
      var qtime;

      var r = new List.from(num);

      // Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        var q = [0];
        qtime = vec(-qindex, q.length - 1 - qindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime);
      } else {
        var d = new List.from(den);
        var q = new List(nDegree - dDegree + 1);

        // Perform the long division.
        for (var k = nDegree - dDegree; k >= 0; k--) {
          q[k] = r[dDegree + k] / den[dDegree];
            if (q[k] == q[k].toInt()) q[k] = q[k].toInt();
          for (var j = dDegree + k - 1; j >= k; j--) {
            r[j] -= q[k] * den[j - k];
          }
        }

        for (var j = dDegree; j <= nDegree; j++) {
          r[j] = 0;
        }
        qtime = vec(-qindex, q.length - 1 - qindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime);
      }
    } else {
      return null;
    }
  }
}

/* ****************************************************** *
 *   DeconvResults extends standard results class           *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class DeconvResults extends ConvoLabResults {
  final List q;
  final List r;
  final List<int> qtime;
  final List<int> rtime;
  final int qindex;
  final int rindex;


  DeconvResults(this.q, this.qindex, this.r, this.rindex, this.qtime, this.rtime) :
      super();
}