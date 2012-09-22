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
    //Store results as a map with k value as the key K
    //and the partial sum list as the value V.
    var psums = new Map();
    //Create a map for sending as a json string.
    var jsonData = new Map();
    //Add the waveform to the jsonData.
    jsonData["Waveform"] = {"real": waveform, "imag": null};
    var L = waveform.length;
    //User may define a period less than the length of the waveform.
    var N = (L / fraction).toInt();
    //The Fourier series coefficients are computed using a FFT.
    var coeff = fft(waveform.getRange(0, N));
    //If the fft returns the complex coefficients, calculate the partial sums.
    if (coeff != null) {
      for (var i = 0; i < kArray.length; i++) {
        List<Complex> y = new List(L);
        List real = new List(L);
        List imag = new List(L);
        for (var j = 0; j < L; j++) {
          var q = complex(0, 0);
          for (var k = 1; k <= kArray[i]; k++) {
            var kth = 2 * j * k * PI / N;
            var wk = complex(cos(kth), sin(kth));
            q = q + (wk * coeff.data[k].scale(1 / N));
          }
          y[j] = coeff.data[0].scale(1 / N) + q.scale(2);
          real[j] = y[j].real;
          imag[j] = y[j].imag;
        }
        psums[kArray[i]] = y;
        jsonData["kval ${i + 1} = ${kArray[i]}"] = {"real": real, "imag": imag};
      }
      return new FSPSResults(waveform, psums, jsonData);
    } else {
      return null;
    }
  }
}
