// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Perform linear convolution of two signals using N point circular convolution.
 *
 * Basic usage:
 *     var xdata = [3, 11, 7, 0, -1, 4, 2];
 *     var hdata = [2, 3, 0, -5, 2, 1];
 *     var y = conv(xdata, hdata);
 *
 * Accepts two optional parameters:
 * * xindex is the t = 0 point for the xdata
 * * hindex is the t = 0 point for the hdata
 *
 * Both indices assume the first element in a list is at i = 0
 * By default, both indices are set to 0, and the sequences are
 * assumed to be causal.
 *
 * Example optional usage:
 *     var xindex = 3;
 *     var hindex = 1;
 *     var y = conv(xdata, hdata, xindex, hindex);
 *
 * The sequences do not need to be the same length as we are
 * computing the circular convolution of two sequences and the
 * lists are padded to length one less than the sum of their
 * lengths.
 *
 * Returns an object of type ConvResults if successful:
 *     print(y.data);
 *     print(y.time);
 *     print('The time zero index for the results is ${y.index}.');
 *
 * Throws ArgumentError if either xdata or hdata are null or empty.
 *
 * Returns null on failure of fft to compute complex coefficients.
 *
 * ConvResults implements _PolyString so that it is also possible to
 * format the result:
 *
 *     print(y.format());
 *
 * See documentation for the ConvResults class below.
 *
 * Dependencies
 * * fft()
 * * class ConvResults
 */

/// The top level function conv() returns the object ConvResults.
ConvResults conv(List xdata, List hdata, [int xindex, int hindex])
    => new _Convolution(xdata, hdata).convolve(xindex, hindex);

// TODO convert to sequences:
////// The top level function conv() returns the object ConvResults.
//ConvResults conv(Sequence x, Sequence h, [Sequence xn = sequence(new List.generate(x.length, (var index) => index)),
//                                          Sequence hn = sequence(new List.generate(h.length, (var index) => index))])
//    => new _Convolution(x, h).convolve(xn, hn);

/// The private class _Convolution.
class _Convolution {
  final xdata;
  final hdata;

  _Convolution(this.xdata, this.hdata);

  ConvResults convolve(int xindex, int hindex) {
    if (xdata == null || hdata == null || xdata.isEmpty ||
        hdata.isEmpty) {
      throw new ArgumentError("invalid data");
    } else {
      if (xindex == null) xindex = 0;
      if (hindex == null) hindex = 0;
      // Create a local copy of each list.  This is necessary
      // in case xdata and hdata are the same object.
      List xdata = new List.from(this.xdata);
      List hdata = new List.from(this.hdata);
      bool isInt = false;
      final xLength = xdata.length;
      final hLength = hdata.length;
      final yindex = xindex + hindex;
      final ytime = vec(-yindex, xLength - 1 + hLength - 1 - yindex);
      // Pad data with zeros to length required to compute circular convolution.
      xdata.addAll(new List.filled(hLength - 1, 0));
      hdata.addAll(new List.filled(xLength - 1, 0));

      final yfft = new List(xdata.length);

      // Take the fft of x(n) and h(n).
      var xfft = fft(xdata);
      var hfft = fft(hdata);

      // Multiply x(n) and h(n) in the frequency domain.
      if (xfft != null && hfft != null) {
        for (var i = 0; i < xdata.length; i++) {
          yfft[i] = xfft.data[i] * hfft.data[i];
        }
      } else {
        return null;
      }

      // Take the inverse fft to find y(n).
      var yifft = ifft(yfft);

      if (yifft != null) {
        // Check if solution is int by rounding.
        if (yifft.data.every((element)
            => element.cround2.real == element.cround2.real.toInt())) {
          isInt = true;
        }
        // Convert complex list to real and format results
        var y = toReal(yifft.data, isInt);
        return new ConvResults(y, yindex, ytime);
      } else {
        return null;
      }
    }
  }
}

/**
 * ConvResults extends standard results class and implements private
 * class PolyString.
 *
 * PolyString converts a list of numbers into a polynomial string in
 * one of three formats: text, html or latex.
 *
 * Example:
 *     List x = [2, 3, 4];
 *     List h = [3, 4, 5, 6];
 *     var y = conv(x, h);
 *     print(y.format());
 *
 * prints:
 *     $$y(n) = 6 + 17n^{-1} + 34n^{-2} + 43n^{-3} + 38n^{-4} + 24n^{-5}$$
 *
 * Accepts optional positional parameters formatType ('text', 'html',
 * 'latex'), baseVar and fname.
 *
 * Example from above but with optional parameters defined:
 *     print(y.format('html', 'z', 'f'));
 *
 * prints:
 *     f(z) = 6 + 17z<sup>-1</sup> + 34z<sup>-2</sup> +
 *         43z<sup>-3</sup> + 38z<sup>-4</sup> + 24z<sup>-5</sup>
 *
 * To add to an element on a webpage:
 *     query("#myDiv").addHtml(y.format());                                                                   *
 */

class ConvResults extends ConvoLabResults implements _PolyString {
  final int index;
  final List<int> time;

  List<num> coeffs;
  List<int> exponents;
  bool isText = false,
       isHtml = false,
       isTex = false;
  String variable;

  var exponent;
  var coeff;
  var sb = new StringBuffer();

  ConvResults(List data, this.index, this.time) : super(data);

  /// Returns the result of the convolution as a formatted string.
  String format([var formatType, var baseVar, var fname]) {
    var firstIndex = 0;
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

    // Add prefix for latex.
    if (isTex) sb.write(r'$$');

    // Add the function name and equal sign.
    sb.write('$fname($baseVar) = ');

    // Format the string.
    formatString(firstIndex, baseVar, data, time);

    if (isTex) sb.write(r'$$');

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
      sb.write('$coeff$variable$exponent');
    }

    // Now take care of remaining elements.
    firstIndex++;

    for (var i = firstIndex; i < exponents.length; i++) {
      variable = baseVar;

      // Format the exponent.
      formatExponent(exponents[i]);

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