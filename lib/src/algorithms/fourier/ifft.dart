part of convolab;

/* **************************************************************** *
 *   Inverse Fast Fourier Transform algorithm                       *
 *   Partially derived from Sedgewick and Wayne's FFT.java          *
 *   Library: ConvoLab (c) 2012 scribeGriff                         *
 * **************************************************************** */

/* **************************************************************** *
 * Static function ifft() preprocesses the input data.              *
 * Usage model: var y = ifft(data, [N]) where data can be a real    *
 * list, complex list or the file path to a list of real numbers.   *
 * N specifies the number of points of the ifft to calculate.  N    *
 * values that are powers of 2 use the O(nlogn) radix 2 fft         *
 * algorithm to compute the inverse transform, otherwise the much   *
 * slower O(n^2) idft is performed.                                 *
 * **************************************************************** */
FFTResults ifft(var fileOrList, [int N]) {
  List<Complex> inList = new ComplexInputListHandler().prepareList(fileOrList);
  if (inList != null) {
    if (N == null) {
      // If N is not specified, set N equal to length of data.
      N = inList.length;
    } else {
      // N is specified by user.
      if (inList.length > N) {
        // Truncate list to length = N.
        inList.removeRange(N, inList.length - N);
      } else if (inList.length < N) {
        // Pad with zeros to length = N.
        inList.insertRange(inList.length, N - inList.length, complex(0, 0));
      }
    }
    // Now check to see if N is a power of 2.  The case where N = 0 is
    // not checked.
    if ((N & -N) == N) {
      // If true, use O(nlogn) algorithm,
      return new _IFFT().iradix2(inList);
    } else {
      // else use O(n^2) algorithm.
      return new _IFFT().idft(inList, N);
    }
  } else {
    return(null);
  }
}

/* **************************************************************** *
 * Private class IFFT contains the methods to implement the two     *
 * algorithms.  Returns a complex array of the transformed input    *
 * as well as a numerical value of relative computational effort.   *
 * **************************************************************** */
class _IFFT {
  int count;
  List<Complex> inCopy;

  _IFFT()
      : count = 0;

  // Method 1: O(nlogn) radix-2 IFFT
  FFTResults iradix2(List<Complex> input) {
    inCopy = new List.from(input);
    List<Complex> ifftResults = ifftnlogn(input);
    return new FFTResults(ifftResults, count, inCopy);
  }
  // The ifftnlogn() is accomplished in 3 steps.  First, the input data
  // is conjugated, then a radix-2 fft is performed and finally the
  // data is conjugated again and scaled by 1/N.
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

  // Method 2: O(n^2) IDFT
  FFTResults idft(List<Complex> input, int N) {
    inCopy = new List.from(input);
    List<Complex> idftResults = idftnxn(input, N);
    return new FFTResults(idftResults, count, inCopy);
  }

  // idftnxn() performs a "brute force" discrete fourier
  // transform of the input data as given by the expression:
  // x(n) = 1/N * sum(k)[X(k) * WN(-nk)]
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
