// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Computes the Inverse Fourier Transform of an input array.
 *
 * Usage model:
 *     FftResults x, y;
 *     List<int> samples = [0, 1, 2, 3];
 *     y = fft(samples);
 *     x = ifft(y.data, [N]);
 *
 * where data can be a real or complex list.
 *
 * Optional positional parameter N specifies the number of points of the
 * ifft to calculate.  N values that are powers of 2 use the O(nlogn)
 * radix 2 fft algorithm to compute the inverse transform, otherwise the much
 * slower O(n^2) idft is performed.
 *
 * Returns an object of FftResults if successful and null otherwise.
 * The object contains a complex array of the transformed input as well as
 * an integer value of relative computational effort.
 *
 * FftResults contains method show() to allow a more readable format for the
 * complex results.  Example usage:
 *
 *     x.show("The ifft is:");
 *     //prints:
 *     //The ifft is:
 *     //0.00
 *     //1.00
 *     //2.00
 *     //3.00
 *
 * The header string is optional.
 *
 * Dependencies:
 * * fft()
 * * complex()
 *
 * Reference: Sedgewick and Wayne's IFFT.java
 *
 */

/// The top level function ifft() returns the object FftResults.
FftResults ifft(List samples, [int N]) {
  List<Complex> _inList = toComplex(samples);
  if (_inList != null) {
    if (N == null) {
      /// If N is not specified, set N equal to length of data.
      N = _inList.length;
    } else {
      // N is specified by user.
      if (_inList.length > N) {
        // Truncate list to length = N.
        _inList.removeRange(N, _inList.length - N);
      } else if (_inList.length < N) {
        // Pad with zeros to length = N.
        _inList.insertRange(_inList.length, N - _inList.length, complex(0, 0));
      }
    }
    /// Check to see if N is a power of 2.
    ///The case where N = 0 is not checked.
    if ((N & -N) == N) {
      // If true, use O(nlogn) algorithm,
      return new _IFFT().iradix2(_inList);
    } else {
      // else use O(n^2) algorithm.
      return new _IFFT().idft(_inList, N);
    }
  } else {
    return(null);
  }
}

/// The private class _FFT.
class _IFFT {
  int count;
  List<Complex> inCopy;

  _IFFT()
      : count = 0;

  /// Method 1: O(nlogn) radix-2 IFFT
  FftResults iradix2(List<Complex> input) {
    inCopy = new List.from(input);
    List<Complex> ifftSoln = ifftnlogn(input);
    return new FftResults(ifftSoln, count, inCopy);
  }
  /// The ifftnlogn() is accomplished in 3 steps.  First, the input data
  /// is conjugated, then a radix-2 fft is performed and finally the
  /// data is conjugated again and scaled by 1/N.
  List<Complex> ifftnlogn(List<Complex> input) {
    var N = input.length;
    List<Complex> y = new List(N);

    // Take the conjugate of the input data.
    for (var i = 0; i < N; i++) {
      y[i] = input[i].conj;
      count++;
    }

    // Compute an FFT of the conjugated data.
    var yp = fft(y);
    y = yp.data;
    count += yp.value;

    // Take the conjugate again of the transformed data and scale by 1/N.
    for (int i = 0; i < N; i++) {
      y[i] = (y[i].conj).scale(1/N);
      count++;
    }
    return y;
  }

  /// Method 2: O(n^2) IDFT
  FftResults idft(List<Complex> input, int N) {
    inCopy = new List.from(input);
    List<Complex> idftSoln = idftnxn(input, N);
    return new FftResults(idftSoln, count, inCopy);
  }

  /// idftnxn() performs a "brute force" discrete fourier
  /// transform of the input data as given by the expression:
  /// x(n) = 1/N * sum(k)[X(k) * WN(-nk)]
  List<Complex> idftnxn(List<Complex> input, int N) {
    List<Complex> y = new List(N);
    for (var k = 0; k < N; k++) {
      var q = complex(0, 0);
      for (var j = 0; j < N; j++) {
        var kth = 2 * k * j * PI / N;
        var wk = complex(cos(kth), sin(kth));
        q = q + (wk * input[j]);
        count++;
      }
      y[k] = q.scale(1/N);
    }
    return y;
  }
}
