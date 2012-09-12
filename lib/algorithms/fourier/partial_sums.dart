/* **************************************************************** *
 *   Computing the Partial Sums of Fourier Series                   *
 *   usage: var psums = fsps(signal, kArray);                       *
 *   Returns Map<k, list>                                           *
 *   Library: ConvoLab (c) 2012 scribeGriff                         *
 * **************************************************************** */

// Wrapper to illiminate need for using new keyword.
FSPSResults fsps(List waveform, List kArray, [num fraction = 1])
    => new _PartialSums(waveform, kArray).sum(fraction);

// Computes the partial sums of Fourier series on waveform.
// The number of sums to compute is defined in each element of list kArray.
class _PartialSums {
  final List waveform;
  final List kArray;

  _PartialSums(this.waveform, this.kArray);

  FSPSResults sum(num fraction) {
    var N = waveform.length;
    var period = (N / fraction).toInt();
    var coeff = fft(waveform.getRange(0, period));
    var psums = new Map();

    for (var i = 0; i < kArray.length; i++) {
      List<Complex> y = new List(N);
      for (var j = 0; j < N; j++) {
        var q = complex(0, 0);
        for (var k = 1; k < kArray[i]; k++) {
          var kth = 2 * j * k * PI / period;
          var wk = complex(cos(kth), sin(kth));
          q = q + (wk * coeff.data[k]);
        }
        y[j] = coeff.data[0].scale(1/period) + q.scale(2/period);
      }
      psums[kArray[i].toString()] = y;
    }
    return new FSPSResults(waveform, psums);
  }

}
