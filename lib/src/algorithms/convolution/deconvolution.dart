// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Perform the deconvolution of two signals using polynomial long division.
 *
 * Returns the quotient and remainder as lists.
 * Basic usage:
 *     var num = [1, 1, 1, 1, 1, 1];
 *     var den = [1, 2, 1];
 *     var qrem = deconv(num, den);
 *
 * First coefficient assumed to be associated with highest power. For example,
 * if the numerator was given as 1 + 2z^-1 + 2z^-2, then:
 *     var num = [1, 2, 1];
 *
 * where, by default, the sequences are assumed to be causal. Both indices
 * assume the first element in a list is at i = 0;
 *
 * For non-causal sequences, the function accepts two optional parameters:
 * * nindex is the t = 0 point for the numerator
 * * dindex is the t = 0 point for the denominator
 *
 * Example optional usage:
 *     var nindex = 2;
 *     var dindex = 1;
 *     // num = z^2 + z + 1 + z^-1 + z^-2 +z^-3
 *     var num = [1, 1, 1, 1, 1, 1];
 *     // den = z + 2 + z^-1
 *     var den = [1, 2, 1];
 *     var qrem = deconv(num, den, nindex, dindex);
 *
 * Note that the sequences do not need to be the same length.
 *
 * Returns an object of type DeconvResults if successful:
 *     print('The quotient is ${qrem.q}');
 *     print('The remainder is ${qrem.r}');
 *     print(qrem.qtime);
 *     print(qrem.qindex);
 *     print(qrem.rtime);
 *     print(qrem.rindex);
 *
 * Returns null if either num or den are null.
 *
 * DeconvResults implements _PolyString so that it is also possible to
 * format the result:
 *
 *     print(y.format());
 *
 * This is not fully implemented for remainders.  See documentation for
 * the DeconvResults class below.
 *
 * Dependencies
 * * class DeconvResults
 */

/// The top level function deconv() returns the object DeconvResults.
DeconvResults deconv(List num, List den, [int nindex = 0, int dindex = 0])
    => new _Deconvolution(num, den).deconvolve(nindex, dindex);

/// The private class _Deconvolution.
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

      /// Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        var q = [0];
        qtime = vec(-qindex, q.length - 1 - qindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime,
            den, dindex);
      } else {
        var q = new List(nDegree - dDegree + 1);

        /// Perform the long division.
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

        /// Return DeconvResults object.
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime,
            den, dindex);
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
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime,
            den, dindex);
      } else {
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
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime,
            den, dindex);
      }
    } else {
      return null;
    }
  }
}

/**
 * DeconvResults extends standard results class and implements private
 * class PolyString.
 *
 * PolyString converts a list of numbers into a polynomial string in
 * one of three formats: text, html or latex.
 *
 * PolyString not fully implemented yet for deconvolution.
 * TODO - implement PolyString for remainders.
 */

class DeconvResults extends ConvoLabResults implements _PolyString {
  final List q;
  final List r;
  final List<int> qtime;
  final List<int> rtime;
  final int qindex;
  final int rindex;

  List<num> coeffs;
  List<int> exponents;
  bool isText = false,
      isHtml = false,
      isTex = false;
  String variable;

  var exponent;
  var coeff;

  DeconvResults(this.q, this.qindex, this.r, this.rindex, this.qtime,
      this.rtime, List data, int val) :
      super(data);

  /// Returns the result of the deconvolution as a formatted string.
  String format([var formatType, var baseVar, var fname]) {
    var sb = new StringBuffer();
    String polystring;

    /// Format available as text, html or latex.
    if (formatType == 'text') {
      isText = true;
    } else if (formatType == 'html') {
      isHtml = true;
    } else {
      isTex = true;
    }

    if (baseVar == null) {
      variable = baseVar = 'n';
    } else {
      variable = baseVar;
    }

    if (fname == null) fname = 'y';

    formatExponent(qtime[0]);

    if (isTex) sb.add(r'$$');
    sb.add('$fname($baseVar) = ');
    if (q[0] != 0) {
      q[0] = q[0] > 0 ? q[0] : q[0].abs();
      coeff = q[0] == 1 ? '' : q[0];
      sb.add('$coeff$variable$exponent');
    }

    for (var i = 1; i < qtime.length; i++) {
      variable = baseVar;

      formatExponent(qtime[i]);

      if (q[i] != 0) {
        if (q[i] > 0) {
          coeff = q[i] == 1 ? '' : q[i];
          sb.add(' + $coeff$variable$exponent');
        } else if (q[i] < 0){
          coeff = q[i] == -1 ? '' : q[i].abs();
          sb.add(' - $coeff$variable$exponent');
        }
      }
    }
    if (isTex) sb.add(r'$$');

    // TODO: Now, need to check for remainder and add
    // to buffer, including denominator.
    // den = data and dindex = value

    // TODO: Time to handle remainder:
    final dtime = vec(-value, data.length - value);


    return polystring = sb.toString();
  }

  /// Formats the exponent for each element.
  void formatExponent(var element) {
    if (element == 0) {
      exponent = '';
      variable = '';
    } else if (element == -1) {
      exponent = '';
    } else {
      if (isTex) {
        exponent = '^{${-1 * element}}';
      } else if (isText) {
        exponent = '^${-1 * element}';
      } else if (isHtml) {
        exponent = '<sup>${-1 * element}</sup>';
      }
    }
  }
}