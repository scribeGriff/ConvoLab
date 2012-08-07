/* **************************************************************** *
 *   Fast Fourier Transform algorithm                               *
 *   Partially derived from Sedgewick and Wayne's FFT.java          *
 *   This algorithm may change.                                     *
 *   Library: ConvoLab (c) 2012 scribeGriff                         *
 * **************************************************************** */

/* **************************************************************** *
 * Static function fft() preprocesses the input data.               *
 * Usage model: var y = fft(data, [N]) where data can be a real     *
 * list, complex list or the file path to a list of real numbers.   *
 * N specifies the number of points of the fft to calculate.  N     *
 * values that are powers of 2 use the O(nlogn) radix 2 algorithm,  *
 * otherwise the much slower O(n^2) dft is performed.               *
 * **************************************************************** */
FFTResults fft(var fileOrList, [int N]) {
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
      return new _FFT().radix2(inList);
    } else {
      // else use O(n^2) algorithm.
      return new _FFT().dft(inList, N);
    }
  } else {
    return(null);
  }
}

/* **************************************************************** *
 * Private class FFT contains the methods to implement the two      *
 * algorithms.  Returns a complex array of the transformed input    *
 * as well as a numerical value of relative computational effort.   *
 * **************************************************************** */
class _FFT {
  int count = 0;
  List<Complex> inCopy;
  // Method 1: O(nlogn) radix-2 FFT
  FFTResults radix2(List<Complex> input) {
    inCopy = new List.from(input);
    List<Complex> fftResults = fftnlogn(input);
    return new FFTResults(fftResults, count, inCopy);
  }
  // fftnlogn() is a radix-2 algorithm that divides the input into 2
  // N/2 point sequences of even ordered and odd ordered sequences.
  List<Complex> fftnlogn(List<Complex> input) {
    var N = input.length;
    // Base case at N = 1.
    if (N == 1) return new List<Complex>.from(input);

    // Perform fft of even terms recursively
    List<Complex> even = new List(N >> 1);
    for (var k = 0; k < N/2; k++) {
      even[k] = input[2*k];
      count++;
    }
    List<Complex> q = fftnlogn(even);

    // Perform fft of odd terms recursively
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
      var kth = -2 * k * PI / N;
      var wk = complex(cos(kth), sin(kth));
      y[k] = q[k] + (wk * r[k]);
      y[k + (N >> 1)] = q[k] - (wk * r[k]);
      count++;
    }
    return y;
  }

  // Method 2: O(n^2) DFT
  FFTResults dft(List<Complex> input, int N) {
    inCopy = new List.from(input);
    List<Complex> dftResults = dftnxn(input, N);
    return new FFTResults(dftResults, count, inCopy);
  }
  // dftnxn() performs a "brute force" discrete fourier
  // transform of the input data as given by the expression:
  // X(k) = sumN [x(n) * WN(nk)]
  List<Complex> dftnxn(List<Complex> input, int N) {
    List<Complex> y = new List(N);
    for (var k = 0; k < N; k++) {
      var q = complex(0, 0);
      for (var j = 0; j < N; j++) {
        var kth = -2 * k * j * PI / N;
        var wk = complex(cos(kth), sin(kth));
        q = q + (wk * input[j]);
        count++;
      }
      y[k] = q;
    }
    return y;
  }
}
