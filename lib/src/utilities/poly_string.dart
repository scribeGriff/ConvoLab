part of convolab;

/* ******************************************************************** *
 *   Converts a list of numbers into a polynomial string in             *
 *   one of three formats: text, html or latex.                         *
 *   Examples:                                                          *
 *     List test = [2, 5, -3, 7];                                       *
 *     String stest = pstring(test, index: 0, type: 'html',             *
 *         name: 'y', variable: 'n');                                   *
 *     print(stest);                                                    *
 *   prints:                                                            *
 *     y(n) = 2 + 5n<sup>-1</sup> - 3n<sup>-2</sup> + 7n<sup>-3</sup>   *
 *   If no named optional parameters are provided, the string defaults  *
 *   to the following (default format is latex for MathJax display):    *
 *     print(pstring(test));                                            *
 *   prints:                                                            *
 *     $$f(x) = 2 + 5x^{-1} - 3x^{-2} + 7x^{-3}$$                       *
 *   To add to an element on a webpage:                                 *
 *     query("#myDiv").addHtml(pstring(test));                          *
 *   Works for casual as well as non-causal signals.  For non-causal,   *
 *   provide value for the index of the zero time element of the list.  *
 *   Library: ConvoLab (c) 2012 scribeGriff                             *
 * ******************************************************************** */

String pstring (List coeffs, {int index: 0, String type, String variable,
    String name}) {
  if (index < 0 || index > coeffs.length - 1) {
    print("invalid value for index");
    return null;
  } else {
    final exponents = vec(-index, coeffs.length - 1 - index);
    return new _PolyString(coeffs, exponents).format(type, variable, name);
  }
}

class _PolyString {
  List<num> coeffs;
  List<int> exponents;
  bool isText = false,
      isHtml = false,
      isTex = false;

  String exponent;
  var coeff, variable;

  _PolyString (this.coeffs, this.exponents);

  String format([var formatType, var baseVar, var fname]) {
    var sb = new StringBuffer();
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

    formatExponent(exponents[0]);

    if (isTex) sb.add(r'$$');
    sb.add('$fname($baseVar) = ');
    if (coeffs[0] != 0) {
      coeffs[0] = coeffs[0] > 0 ? coeffs[0] : coeffs[0].abs();
      coeff = coeffs[0] == 1 ? '' : coeffs[0];
      sb.add('$coeff$variable$exponent');
    }

    for (var i = 1; i < coeffs.length; i++) {
      variable = baseVar;

      formatExponent(exponents[i]);

      if (coeffs[i] != 0) {
        if (coeffs[i] > 0) {
          coeff = coeffs[i] == 1 ? '' : coeffs[i];
          sb.add(' + $coeff$variable$exponent');
        } else if (coeffs[i] < 0){
          coeff = coeffs[i] == -1 ? '' : coeffs[i].abs();
          sb.add(' - $coeff$variable$exponent');
        }
      }
    }
    if (isTex) sb.add(r'$$');

    return polystring = sb.toString();
  }

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
