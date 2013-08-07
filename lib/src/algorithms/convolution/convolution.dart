// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Perform linear convolution of two signals using N point circular convolution.
 *
 * Basic usage:
 *     var xdata = sequence([3, 11, 7, 0, -1, 4, 2]);
 *     var hdata = sequence([2, 3, 0, -5, 2, 1]);
 *     var y = conv(xdata, hdata);
 *
 * Accepts two optional parameters:
 * * A position sequence for the xdata.
 * * A position sequence for the hdata.
 *
 * If position sequences are not provided, the data sequence is assumed
 * to start at position n = 0.  If this is not the case, a position sequence
 * can be created using the position() method of the Sequence class
 * and providing an integer indicating the n = 0 position in the sequence.
 *
 * Example optional usage:
 *     var xpos = xdata.position(3);
 *     var hpos = hdata.position(1);
 *     var y = conv(xdata, hdata, xpos, hpos);
 *
 * The sequences do not need to be the same length as we are
 * computing the circular convolution of two sequences and the
 * lists are padded to length one less than the sum of their
 * lengths.
 *
 * Returns an object of type ConvResults if successful:
 *     print(y.x);
 *     print(y.n);
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

// TODO update after fft, ifft converted to sequences.
// The top level function conv() returns the object ConvResults.
ConvResults conv(Sequence x, Sequence h, [Sequence xn, Sequence hn])
    => new _Convolution(x, h).convolve(xn, hn);

/// The private class _Convolution.
class _Convolution {
  final xdata;
  final hdata;

  _Convolution(this.xdata, this.hdata);

  ConvResults convolve(Sequence xn, Sequence hn) {
    if (xdata == null || hdata == null || xdata.isEmpty ||
        hdata.isEmpty) {
      throw new ArgumentError("invalid data");
    } else {
      if (xn == null) xn = sequence(new List.generate(xdata.length,
          (var index) => index));
      if (hn == null) hn = sequence(new List.generate(hdata.length,
          (var index) => index));
      // Create a local copy of each list.  This is necessary
      // in case xdata and hdata are the same object.
      Sequence xdata = sequence(this.xdata);
      Sequence hdata = sequence(this.hdata);
      bool isInt = false;
      final xLength = xdata.length;
      final hLength = hdata.length;
      final yindex = xn.indexOf(0) + hn.indexOf(0);
      //final yindex = xindex + hindex;
      final ytime = vec(-yindex, xLength - 1 + hLength - 1 - yindex);
      // Pad data with zeros to length required to compute circular convolution.
      xdata.addAll(new List.filled(hLength - 1, 0));
      hdata.addAll(new List.filled(xLength - 1, 0));

      // TODO: fft() and ifft() need to be converted to sequences.  Until then
      // need to convert to List, compute fft, ifft, and then convert back to
      // sequences.
      final yfft = new List(xdata.length);

      // Take the fft of x(n) and h(n).
      var xfft = fft(xdata.toList());
      var hfft = fft(hdata.toList());

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
        return new ConvResults(sequence(y), sequence(ytime));
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
 *     query("#myDiv").addHtml(y.format());
 */

class ConvResults extends ConvoLabResults implements _PolyString {
   final Sequence x;
   final Sequence n;

  List<num> coeffs;
  List<int> exponents;
  bool isText = false,
       isHtml = false,
       isTex = false;
  String variable;

  var exponent;
  var coeff;
  var sb = new StringBuffer();

  ConvResults(this.x, this.n);

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
    //formatString(firstIndex, baseVar, data, time);
    _formatString(firstIndex, baseVar, x, n);

    if (isTex) sb.write(r'$$');

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