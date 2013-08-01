// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the Fourier Transform of an input array.
 *
 * Usage model:
 *     FftResults y;
 *     List<int> samples = [0, 1, 2, 3];
 *     y = fft(samples, [N]);
 *
 * where the data is a List of samples.  N specifies the number of points
 * of the fft to calculate.  If N is not specified, it is set to the
 * length of data.  N values that are powers of 2 use the O(nlogn)
 * radix 2 algorithm, otherwise the much slower O(n^2) dft is
 * performed.
 *
 * Returns an object of FftResults if successful and null otherwise.
 * The object contains a complex array of the transformed input as well as
 * an integer value of relative computational effort.
 *
 * FftResults contains method show() to allow a more readable format for the
 * complex results.  Example usage:
 *
 *     y.show("The fft is:");
 *     // prints:
 *     //The fft is:
 *     //6.00
 *     //-2.00 + 2.00j
 *     //-2.00
 *     //-2.00 - 2.00j
 *
 * The header string is optional.
 *
 * Reference: Sedgewick and Wayne's FFT.java
 */

/// The top level function fft() returns the object FftResults.
FftResults fft(List samples, [int N]) {
  List<Complex> _inList = toComplex(samples);
  if (_inList != null) {
    if (N == null) {
      /// If N is not specified, set N equal to length of data.
      N = _inList.length;
    } else {
      // N is specified by user.
      if (_inList.length > N) {
        // Truncate list to length = N.
        _inList.removeRange(N, _inList.length);
      } else if (_inList.length < N) {
        // Pad with complex zeros to length = N.
        _inList.addAll(new List.filled(N - _inList.length, complex(0, 0)));
      }
    }
    /// Check to see if N is a power of 2.
    /// The case where N = 0 is not checked.
    if ((N & -N) == N) {
      // If true, use O(nlogn) algorithm,
      return new _FFT().radix2(_inList);
    } else {
      // else use O(n^2) algorithm.
      return new _FFT().dft(_inList, N);
    }
  } else {
    return(null);
  }
}

/// The private class _FFT.
class _FFT {
  int count;
  List<Complex> inCopy;

  _FFT()
      : count = 0;

  /// Method 1: O(nlogn) radix-2 FFT
  FftResults radix2(List<Complex> input) {
    inCopy = new List.from(input);
    List<Complex> fftSoln = fftnlogn(input);
    return new FftResults(fftSoln, count, inCopy);
  }
  /// fftnlogn() is a radix-2 algorithm that divides the input into 2
  /// N/2 point sequences of even ordered and odd ordered sequences.
  List<Complex> fftnlogn(List<Complex> input) {
    var N = input.length;
    // Base case at N = 1.
    if (N == 1) return new List<Complex>.from(input);

    // Perform fft of even terms recursively.
    List<Complex> even = new List(N >> 1);
    for (var k = 0; k < N/2; k++) {
      even[k] = input[2*k];
      count++;
    }
    List<Complex> q = fftnlogn(even);

    // Perform fft of odd terms recursively.
    List<Complex> odd = new List(N >> 1);
    for (var k = 0; k < N/2; k++) {
      odd[k] = input[2*k + 1];
      count++;
    }
    List<Complex> r = fftnlogn(odd);

    // Merging formula for combining 2 N/2-point DFTs
    // into one N-point DFT.
    List<Complex> y = new List(N);
    for (var k = 0; k < N/2; k++) {
      var kth = -2 * k * math.PI / N;
      var wk = complex(math.cos(kth), math.sin(kth));
      y[k] = q[k] + (wk * r[k]);
      y[k + (N >> 1)] = q[k] - (wk * r[k]);
      count++;
    }
    return y;
  }

  /// Method 2: O(n^2) DFT
  FftResults dft(List<Complex> input, int N) {
    inCopy = new List.from(input);
    List<Complex> dftSoln = dftnxn(input, N);
    return new FftResults(dftSoln, count, inCopy);
  }
  /// dftnxn() performs a "brute force" discrete fourier
  /// transform of the input data as given by the expression:
  /// X(k) = sumN [x(n) * WN(nk)]
  List<Complex> dftnxn(List<Complex> input, int N) {
    List<Complex> y = new List(N);
    for (var k = 0; k < N; k++) {
      var q = complex(0, 0);
      for (var j = 0; j < N; j++) {
        var kth = -2 * k * j * math.PI / N;
        var wk = complex(math.cos(kth), math.sin(kth));
        q = q + (wk * input[j]);
        count++;
      }
      y[k] = q;
    }
    return y;
  }
}

/**
 * FftResults extends standard results class.
 *
 * Returns the complex results for either the fft() or ifft() function.
 * Also returns a complex version of the input data as well as a
 * relative value for computational effort.
 *
 * Method show() allows printing of the complex result in a readable
 * format.
 */

class FftResults extends ConvoLabResults {
  /// Returns input as Complex list.
  final List<Complex> input;

  FftResults(List<Complex> data, int value, this.input) : super(data, value);

  /// Shows the complex data in a readable format.
  void show([String header]) {
    if(header != null) {
      print("$header");
    }
    this.data.forEach((element) => print(element.string));
  }
}
