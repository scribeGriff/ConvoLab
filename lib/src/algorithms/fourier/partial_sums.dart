// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the partial sums of Fourier Series.
 * usage:
 *     var waveform = square(1);
 *     var kvals = [1, 16, 80];
 *     var fourier = fsps(waveform, kArray, [fraction]);
 *
 * Computes the partial sums of Fourier series on the waveform for each
 * value of k given by the elements of list kArray.  The optional parameter
 * fraction, determines over what period to compute the series.  The default
 * value is to treat the entire waveform as the period.
 *
 * Returns FspsResults object which includes two differently formatted
 * HashMap<k, list>.  For example:
 *     print('We have computed ${fourier.psums.length} Fourier series.');
 *     // We have computed 3 Fourier series.
 *     if (fourier.psums[kvals[0]].every((element) => element is Complex)) {
 *       print('The computed Fourier series is of type Complex.');
 *     }
 *     // The computed Fourier series is of type Complex.
 *
 * Dependencies:
 * * waveform()
 * * complex()
 * * fft()
 *
 */

/// The top level function fsps() returns the object FspsResults.
FspsResults fsps(List waveform, List kArray, [num fraction = 1])
    => new _PartialSums(waveform, kArray).sum(fraction);

/// The private class _PartialSums.
class _PartialSums {
  final List waveform;
  final List kArray;

  _PartialSums(this.waveform, this.kArray);

  FspsResults sum(num fraction) {
    //Store results as a map with k value as the key K
    //and the partial sum list as the value V.
    var psums = new HashMap();
    //Create a map for sending as a json string.
    var jsonData = new HashMap();
    //Add the waveform to the jsonData.
    jsonData["Waveform"] = {"real": waveform, "imag": null};
    var L = waveform.length;
    //User may define a period less than the length of the waveform.
    var N = (L * fraction).toInt();
    //The Fourier series coefficients are computed using a FFT.
    var coeff = fft(waveform.sublist(0, N));
    //If the fft returns the complex coefficients, calculate the partial sums.
    if (coeff != null) {
      for (var i = 0; i < kArray.length; i++) {
        List<Complex> y = new List(L);
        List real = new List(L);
        List imag = new List(L);
        for (var n = 0; n < L; n++) {
          var q = complex(0, 0);
          for (var k = 1; k <= kArray[i]; k++) {
            var kth = 2 * n * k * math.PI / N;
            var wk = complex(math.cos(kth), math.sin(kth));
            q = q + (wk * coeff.data[k]);
          }
          y[n] = coeff.data[0].scale(1 / N) + q.scale(2 / N);
          real[n] = y[n].real;
          imag[n] = y[n].imag;
        }
        psums[kArray[i]] = y;
        jsonData["kval ${i + 1} = ${kArray[i]}"] = {"real": real, "imag": imag};
      }
      /// return the FspsResults object.
      return new FspsResults(waveform, psums, jsonData);
    } else {
      return null;
    }
  }
}

/**
 * FspsResults extends standard results class.
 *
 * Returns two Map objects, psums and jsonData where the value of k
 * in the kArray is the key and the complex list is the value.  Since json
 * cannot handle complex arrays, the data is formatted into real and imag
 * arrays.  Also returns the input data as the results field 'data'.
 *
 */

class FspsResults extends ConvoLabResults {
  final HashMap psums, jsonData;

  //Return a list of the input waveform and also a Map of the
  //partial sums indexed to the value for k.
  FspsResults(List data, this.psums, this.jsonData) : super(data);
}

