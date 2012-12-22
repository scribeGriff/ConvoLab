// Copyright (c) 2012, scribeGriff (Richard Griffith)
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
ConvResults conv(List xdata, List hdata, [int xindex = 0, int hindex = 0])
    => new _Convolution(xdata, hdata).convolve(xindex, hindex);

/// The private class _Convolution.
class _Convolution {
  final xdata;
  final hdata;

  _Convolution(this.xdata, this.hdata);

  ConvResults convolve(int xindex, int hindex) {
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
    xdata.insertRange(xLength, hLength - 1, 0);
    hdata.insertRange(hLength, xLength - 1, 0);

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
 *     var y = conv(x1, x2);
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

  ConvResults(List data, this.index, this.time) : super(data);

  /// Returns the result of the convolution as a formatted string.
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

    formatExponent(time[0]);

    if (isTex) sb.add(r'$$');
    sb.add('$fname($baseVar) = ');
    if (data[0] != 0) {
      data[0] = data[0] > 0 ? data[0] : data[0].abs();
      coeff = data[0] == 1 ? '' : data[0];
      sb.add('$coeff$variable$exponent');
    }

    for (var i = 1; i < time.length; i++) {
      variable = baseVar;

      formatExponent(time[i]);

      if (data[i] != 0) {
        if (data[i] > 0) {
          coeff = data[i] == 1 ? '' : data[i];
          sb.add(' + $coeff$variable$exponent');
        } else if (data[i] < 0){
          coeff = data[i] == -1 ? '' : data[i].abs();
          sb.add(' - $coeff$variable$exponent');
        }
      }
    }
    if (isTex) sb.add(r'$$');

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