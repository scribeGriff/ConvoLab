// Copyright (c) 2013, scribeGriff (Richard Griffith)
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
 * See documentation for the DeconvResults class below.
 *
 * Dependencies
 * * class DeconvResults
 */

/// The top level function deconv() returns the object DeconvResults.
DeconvResults deconv(List num, List den, [int nindex, int dindex])
    => new _Deconvolution(num, den).deconvolve(nindex, dindex);

/// The private class _Deconvolution.
class _Deconvolution {
  final List num;
  final List den;

  _Deconvolution(this.num, this.den);

  DeconvResults deconvolve(int nindex, int dindex) {
    if (num == null || den == null || num.length == 0 || den.length == 0) {
      print("invalid data");
      return null;
    } else {
      if (nindex == null) nindex = 0;
      if (dindex == null) dindex = 0;
      final dLength = den.length;
      final nLength = num.length;
      final dDegree = dLength - 1;
      final nDegree = nLength - 1;
      final qindex = nindex - dindex;
      final rindex = nindex;
      var q, qtime, rtime;

      var r = new List.from(num);

      /// Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        q = [];
        qtime = [];
        rtime = vec(-nindex, nDegree - nindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime,
            den, dindex);
      } else {
        q = new List(nDegree - dDegree + 1);
        rtime = vec(-rindex, nDegree - dDegree);

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
    }
  }

  // Not used but this algorithm accepts coefficients in the opposite
  // order as used by some implementations.
  DeconvResults deconvolve_alternate(int nindex, int dindex) {
    if (num == null || den == null || num.length == 0 || den.length == 0) {
      print("invalid data");
      return null;
    } else {
      if (nindex == null) nindex = 0;
      if (dindex == null) dindex = 0;
      final dLength = den.length;
      final nLength = num.length;
      final dDegree = dLength - 1;
      final nDegree = nLength - 1;
      final qindex = nindex - dindex;
      final rindex = nindex;
      var q, qtime, rtime;

      var r = new List.from(num);

      // Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        q = [];
        qtime = [];
        rtime = vec(-nindex, nDegree - nindex);
        return new DeconvResults(q, qindex, r, rindex, qtime, rtime,
            den, dindex);
      } else {
        var q = new List(nDegree - dDegree + 1);
        rtime = vec(-rindex, nDegree - dDegree);

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
  var sb = new StringBuffer();

  DeconvResults(this.q, this.qindex, this.r, this.rindex, this.qtime,
      this.rtime, List data, int value) :
      super(data, value);

  /// Returns the result of the deconvolution as a formatted string.
  String format([var formatType, var baseVar, var fname]) {
    final dtime = vec(-value, data.length -1 - value);
    String polystring;
    bool quotient = false;
    var firstIndex = 0;

    // Format available as text, html or latex.
    if (formatType == 'text') {
      isText = true;
    } else if (formatType == 'html') {
      isHtml = true;
    } else {
      isTex = true;
    }
    // Define the variable name.  Default variable is n.
    if (baseVar == null) {
      variable = baseVar = 'n';
    } else {
      variable = baseVar;
    }
    // Add the function name.  Default function name is 'y'.
    if (fname == null) fname = 'y';
    // Add prefix for latex, if necessary.
    if (isTex) sb.add(r'$$');
    // Add the function name and equal sign.
    sb.add('$fname($baseVar) = ');
    // Format the quotient.  Check first if a quotient exists.
    if (!q.isEmpty) {
      quotient = true;
      formatString(firstIndex, baseVar, q, qtime);
    }
    // Now handle the remainder.  Check first if a reminder exists.
    if (r.any((element) => element != 0)) {
      if (quotient) sb.add(' + ');
      if (isTex) {
        sb.add(r'\frac{');
      } else {
        sb.add('(');
      }
      // This is the numerator of the remainder.
      formatString(firstIndex, baseVar, r, rtime);
      if (isTex) {
        sb.add(r'}{');
      } else {
        sb.add(' / ');
      }
      // This is the denominator of the remainder.
      formatString(firstIndex, baseVar, data, dtime);
    }
    // Done forming the string, just need to terminate it.
    if (isTex) {
      sb.add(r'}$$');
    } else {
      sb.add(')');
    }
    return polystring = sb.toString();
  }

  /// The formatString() function queries each element of the
  /// coefficients array and decides on the appropriate formatting
  /// depending on a number of factors.
  void formatString(var firstIndex, var baseVar, var coefficients,
                    var exponents) {
    // The first element in the solution is treated slightly
    // different than the remaining elements, so take
    // care of this element first.
    // Find the first non-zero element.
    while (coefficients[firstIndex] == 0) {
      firstIndex++;
    }
    // Format the exponent.
    formatExponent(exponents[firstIndex]);
    // Format the first element.
    if (coefficients[firstIndex] != 0) {
      if ('$variable' == '') {
        coeff = coefficients[firstIndex];
      } else {
        coeff = coefficients[firstIndex].abs() == 1 ? '' :
          coefficients[firstIndex];
      }
      sb.add('$coeff$variable$exponent');
    }

    // Now take care of remaining elements.
    firstIndex++;
    for (var i = firstIndex; i < exponents.length; i++) {
      variable = baseVar;
      // Format the exponent.
      formatExponent(exponents[i]);
      // Now add them to the string buffer
      if (coefficients[i] != 0) {
        if (coefficients[i] > 0) {
          if ('$variable' == '') {
            coeff = coefficients[i];
          } else {
            coeff = coefficients[i] == 1 ? '' : coefficients[i];
          }
          sb.add(' + $coeff$variable$exponent');
        } else if (coefficients[i] < 0) {
          if ('$variable' == '') {
            coeff = coefficients[i].abs();
          } else {
            coeff = coefficients[i] == -1 ? '' : coefficients[i].abs();
          }
          sb.add(' - $coeff$variable$exponent');
        }
      }
    }
  }

  /// The formatExponent() takes an element of the exponents array
  /// and formats it as text, html, or latex.
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