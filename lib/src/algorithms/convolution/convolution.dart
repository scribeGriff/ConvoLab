part of convolab;

/* **************************************************************** *
 *   Perform the linear convolution of two signals using            *
 *   an N point circular convolution.                               *
 *   Basic usage: var ydata = conv(xdata, hdata);                   *
 *   Accepts two optional parameters:                               *
 *     xindex is the t = 0 point for the xdata                      *
 *     hindex is the t = 0 point for the hdata                      *
 *   Both indices assume the first element in a list is at i = 0    *
 *   By default, both indices are set to 0, and the sequences are   *
 *     assumed to be causal.                                        *
 *   Example optional usage: ydata = conv(xdata, hdata, 3, 7);      *
 *   The sequences do not need to be the same length as we are      *
 *     computing the circular convolution of two sequences and the  *
 *     lists are padded to length one less than the sum of their    *
 *     lengths.                                                     *
 *   Returns ConvResults:                                           *
 *     y: List                                                      *
 *     yindex: int                                                  *
 *     ytime: List<int>                                             *                                                 *
 *   Library: ConvoLab (c) 2012 scribeGriff                         *
 * **************************************************************** */

ConvResults conv(List xdata, List hdata, [int xindex = 0, int hindex = 0])
    => new _Convolution(xdata, hdata).convolve(xindex, hindex);

class _Convolution {
  final List xdata;
  final List hdata;

  _Convolution(this.xdata, this.hdata);

  ConvResults convolve(int xindex, int hindex) {
    bool isInt = false;
    final xLength = xdata.length;
    final hLength = hdata.length;
    final yindex = xindex + hindex;
    final ytime = vec(-yindex, xLength - 1 + hLength - 1 - yindex);
    // Pad data with zeros to length required to compute circular convolution.
    xdata.insertRange(xLength, hLength - 1, 0);
    hdata.insertRange(hLength, xLength - 1, 0);

    final yfft = new List(xdata.length);

    // Take the fft of x(n) and h(n)
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
      if (yifft.data.every(f(element)
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

/* ****************************************************** *
 *   ConvResults extends standard results class           *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class ConvResults extends ConvoLabResults {
  final List y;
  final int yindex;
  final List<int> ytime;

  ConvResults(this.y, this.yindex, this.ytime) : super();
}