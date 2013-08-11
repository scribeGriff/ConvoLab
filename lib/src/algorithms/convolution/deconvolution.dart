// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Perform the deconvolution of two signals using polynomial long division.
 *
 * Returns the quotient and remainder as sequences.
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
 * * nn is the position sequence for the numerator
 * * dn is the position sequence for the denominator
 *
 * Example optional usage:
 *     // num = z^2 + z + 1 + z^-1 + z^-2 +z^-3
 *     var num = [1, 1, 1, 1, 1, 1];
 *     var nn = num.position(2); // The zero index is at position 2 in num.
 *     // den = z + 2 + z^-1
 *     var den = [1, 2, 1];
 *     var dn = den.position(1);  // The zero index is at position 1 in den.
 *     var qrem = deconv(num, den, nn, dn);
 *
 * Note that the sequences do not need to be the same length.
 *
 * Returns an object of type DeconvResults if successful:
 *     print('The quotient is ${qrem.q}');
 *     print('The remainder is ${qrem.r}');
 *     print(qrem.qn);
 *     print(qrem.rn);
 *
 * Throws ArgumentError if either num or den are null or empty.
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

/// Performs a deconvolution (polynomial long division) of numerator and
/// denominator.  Accepts position information.  Returns quotient, remainder,
/// and position information for each.
DeconvResults deconv(Sequence _numerator, Sequence _denominator,
                     [Sequence _nn, Sequence _dn])
=> new _Deconvolution(_numerator, _denominator).deconvolve(_nn, _dn);

// The private class _Deconvolution.
class _Deconvolution {
  final numerator;
  final denominator;

  _Deconvolution(this.numerator, this.denominator);

  DeconvResults deconvolve(Sequence nn, Sequence dn) {
    if (numerator == null || denominator == null || numerator.length == 0 ||
        denominator.length == 0) {
      throw new ArgumentError("invalid data");
    } else {
      if (nn == null) nn = sequence(new List.generate(numerator.length,
          (var index) => index));
      if (dn == null) dn = sequence(new List.generate(denominator.length,
          (var index) => index));
      final dLength = denominator.length;
      final nLength = numerator.length;
      final dDegree = dLength - 1;
      final nDegree = nLength - 1;
      final qindex = nn.indexOf(0) - dn.indexOf(0);
      var q, qtime, rtime;

      var r = sequence(numerator);

      // Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        q = sequence([]);
        qtime = sequence([]);
        rtime = sequence(vec(-nn.indexOf(0), nDegree - nn.indexOf(0)));
        return new DeconvResults(q, r, qtime, rtime, denominator, dn);
      } else {
        q = sequence(new List(nDegree - dDegree + 1));
        rtime = sequence(vec(-nn.indexOf(0), nDegree - dDegree));

        /// Perform the long division.
        for (var k = 0; k <= nDegree - dDegree; k++) {
          q[k] = r[k] / denominator[0];
          if (q[k] == q[k].toInt()) q[k] = q[k].toInt();
          for (var j = k + 1; j <= dDegree + k; j++) {
            r[j] -= q[k] * denominator[j - k];
          }
        }
        for (var j = 0; j <= nDegree - dDegree; j++) {
          r[j] = 0;
        }
        qtime = sequence(vec(-qindex, q.length - 1 - qindex));
        /// Return DeconvResults object.
        return new DeconvResults(q, r, qtime, rtime, denominator, dn);
      }
    }
  }

  // Not used but this algorithm accepts coefficients in the opposite
  // order as used by some implementations.
  DeconvResults deconvolve_alternate(Sequence nn, Sequence dn) {
    if (numerator == null || denominator == null || numerator.length == 0 ||
        denominator.length == 0) {
      throw new ArgumentError("invalid data");
    } else {
      if (nn == null) nn = sequence(new List.generate(numerator.length,
          (var index) => index));
      if (dn == null) dn = sequence(new List.generate(denominator.length,
          (var index) => index));
      final dLength = denominator.length;
      final nLength = numerator.length;
      final dDegree = dLength - 1;
      final nDegree = nLength - 1;
      final qindex = nn.indexOf(0) - dn.indexOf(0);
      var q, qtime, rtime;

      var r = sequence(numerator);

      // Trivial solution q = 0 and remainder = num.
      if (nDegree < dDegree) {
        q = sequence([]);
        qtime = sequence([]);
        rtime = sequence(vec(-nn.indexOf(0), nDegree - nn.indexOf(0)));
        return new DeconvResults(q, r, qtime, rtime, denominator, dn);
      } else {
        q = sequence(new List(nDegree - dDegree + 1));
        rtime = sequence(vec(-nn.indexOf(0), nDegree - dDegree));

        // Perform the long division.
        for (var k = nDegree - dDegree; k >= 0; k--) {
          q[k] = r[dDegree + k] / denominator[dDegree];
            if (q[k] == q[k].toInt()) q[k] = q[k].toInt();
          for (var j = dDegree + k - 1; j >= k; j--) {
            r[j] -= q[k] * denominator[j - k];
          }
        }
        for (var j = dDegree; j <= nDegree; j++) {
          r[j] = 0;
        }
        qtime = sequence(vec(-qindex, q.length - 1 - qindex));
        /// Return DeconvResults object.
        return new DeconvResults(q, r, qtime, rtime, denominator, dn);
      }
    }
  }
}

/**
 * DeconvResults extends standard results class and implements private
 * class PolyString.
 *
 * The format() method converts a sequence of numbers into a polynomial string
 * in one of three formats: text, html or latex.
 *
 */

class DeconvResults extends ConvoLabResults implements _PolyString {
  final Sequence q;
  final Sequence r;
  final Sequence qn;
  final Sequence rn;
  final Sequence denominator;
  final Sequence dn;

  List<num> coeffs;
  List<int> exponents;
  bool isText = false,
      isHtml = false,
      isTex = false;
  String variable;

  var exponent;
  var coeff;
  var sb = new StringBuffer();

  DeconvResults(this.q, this.r, this.qn, this.rn, this.denominator, this.dn);

  /// Returns the result of the deconvolution as a formatted string.
  String format([var formatType, var baseVar, var fname]) {
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
    if (isTex) sb.write(r'$$');
    // Add the function name and equal sign.
    sb.write('$fname($baseVar) = ');
    // Format the quotient.  Check first if a quotient exists.
    if (!q.isEmpty) {
      quotient = true;
      _formatString(firstIndex, baseVar, q, qn);
    }
    // Now handle the remainder.  Check first if a reminder exists.
    if (r.any((element) => element != 0)) {
      if (quotient) sb.write(' + ');
      if (isTex) {
        sb.write(r'\frac{');
      } else {
        sb.write('(');
      }
      // This is the numerator of the remainder.
      _formatString(firstIndex, baseVar, r, rn);
      if (isTex) {
        sb.write(r'}{');
      } else {
        sb.write(' / ');
      }
      // This is the denominator of the remainder.
      _formatString(firstIndex, baseVar, denominator, dn);
    }
    // Done forming the string, just need to terminate it.
    if (isTex) {
      sb.write(r'}$$');
    } else {
      sb.write(')');
    }
    return polystring = sb.toString();
  }

  // The formatString() function queries each element of the
  // coefficients array and decides on the appropriate formatting
  // depending on a number of factors.
  void _formatString(var firstIndex, var baseVar, var coefficients,
                    var exponents) {
    // The first element in the solution is treated slightly
    // different than the remaining elements, so take
    // care of this element first.
    // Find the first non-zero element.
    while (coefficients[firstIndex] == 0) {
      firstIndex++;
    }
    // Format the exponent.
    _formatExponent(exponents[firstIndex]);
    // Format the first element.
    if (coefficients[firstIndex] != 0) {
      if ('$variable' == '') {
        coeff = coefficients[firstIndex];
      } else {
        coeff = coefficients[firstIndex].abs() == 1 ? '' :
          coefficients[firstIndex];
      }
      sb.write('$coeff$variable$exponent');
    }

    // Now take care of remaining elements.
    firstIndex++;
    for (var i = firstIndex; i < exponents.length; i++) {
      variable = baseVar;
      // Format the exponent.
      _formatExponent(exponents[i]);
      // Now add them to the string buffer
      if (coefficients[i] != 0) {
        if (coefficients[i] > 0) {
          if ('$variable' == '') {
            coeff = coefficients[i];
          } else {
            coeff = coefficients[i] == 1 ? '' : coefficients[i];
          }
          sb.write(' + $coeff$variable$exponent');
        } else if (coefficients[i] < 0) {
          if ('$variable' == '') {
            coeff = coefficients[i].abs();
          } else {
            coeff = coefficients[i] == -1 ? '' : coefficients[i].abs();
          }
          sb.write(' - $coeff$variable$exponent');
        }
      }
    }
  }

  // The formatExponent() takes an element of the exponents array
  // and formats it as text, html, or latex.
  void _formatExponent(var element) {
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