// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Converts a list of numbers into a polynomial string.
 *
 * Available in one of three formats: text, html or latex.
 *
 * Example:
 *     List test = [2, 5, -3, 7];
 *     String stest = pstring(test, index: 0, type: 'html',
 *         name: 'y', variable: 'n');
 *     print(stest);
 * prints:
 *     y(n) = 2 + 5n<sup>-1</sup> - 3n<sup>-2</sup> + 7n<sup>-3</sup>
 *
 * If no named optional parameters are provided, the string defaults
 * to the following (default format is latex for MathJax display):
 *     print(pstring(test));
 * prints:
 *     $$f(x) = 2 + 5x^{-1} - 3x^{-2} + 7x^{-3}$$
 *
 * To add to an element on a webpage:
 *     query("#myDiv").appendHtml(pstring(test, index:0, type:'html'));
 *
 * Works for casual as well as non-causal signals.  For non-causal signals,
 * provide a value for the index of the zero time element of the list.
 *
 * Example:
 *     List test = [2, 5, -3, 7];
 *     var index = 2;
 *     String stest = pstring(test, index: index, type: 'html',
 *         name: 'y', variable: 'n');
 *     print(stest);
 * prints:
 *     y(n) = 2n<sup>2</sup> + 5n - 3 + 7n<sup>-1</sup>
 *
 */

/// The top level function pstring() returns the formatted string.
String pstring (List coeffs, {int index, String type, String variable,
    String name}) {
  if (coeffs == null || coeffs.length == 0) {
    throw new ArgumentError("invalid list of coefficients");
  } else {
    if (index == null) index = 0;
    final exponents = vec(-index, coeffs.length - 1 - index);
    return new _PolyString(coeffs, exponents).format(type, variable, name);
  }
}

/// The private class _PolyString.
class _PolyString {
  List<num> coeffs;
  List<int> exponents;
  bool isText = false,
      isHtml = false,
      isTex = false;

  String exponent;
  var coeff, variable;
  var sb = new StringBuffer();

  _PolyString (this.coeffs, this.exponents);

  /// The _PolyString method format accepts the format type,
  /// base variable name, and function name.
  String format([var formatType, var baseVar, var fname]) {
    var firstIndex = 0;
    String polystring;

    if (formatType == 'text') {
      isText = true;
    } else if (formatType == 'html') {
      isHtml = true;
    } else {
      isTex = true;
    }

    if (baseVar == null) {
      variable = baseVar = 'x';
    } else {
      variable = baseVar;
    }

    if (fname == null) fname = 'f';

    // Add prefix for latex.
    if (isTex) sb.write(r'$$');

    // Add the function name and equal sign.
    sb.write('$fname($baseVar) = ');

    // Format the string.
    _formatString(firstIndex, baseVar, coeffs, exponents);

    // Add suffix for latex.
    if (isTex) sb.write(r'$$');

    // Return the final string.
    return polystring = sb.toString();
  }

  /// The formatString() function queries each element of the
  /// coefficients array and decides on the appropriate formatting
  /// depending on a number of factors.
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

  /// The formatExponent() takes an element of the exponents array
  /// and formats it as text, html, or latex.
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
