# ConvoLab #

## A signal processing library for Dart ##

This library has neither dart:io or dart:html dependecy so that it can be used by the client or the server.  Two related libraries that make use of the ConvoLab library are:

1.  ConvoWeb (client side)
2.  ConvoHio (server side)

Very preliminary and very much a work in progress.

----------


## Library Methodology ##
The library methodology is based on several principles: 

1.  access to the library is through function calls rather than constructor methods
2.  calls return multiple values which are accessed using object methods
3.  function call returns null on failure

The intent is to be somewhat familiar to users of Matlab and Matlab clones.

----------  
## Library Usage: ##

Add the following to your pubspec.yaml:

    convolab:
      git: git://github.com/scribeGriff/ConvoLab.git

Then import the library to your app:

    import 'package:convolab/convolab.dart';

The library currently supports the following algorithms (more are in development):

1.  Fourier transfrom - `fft()`
2.  inverser Fourier transform - `ifft()`
3.  partial sums of Fourier series - `fsps()`
4.  convolution - `conv()`
5.  deconvolution - `deconv()`
6.  Prim's minimum spanning tree - `primst()`
7.  Kruskal's minimum spanning tree - `kmst()`
8.  2-sat problem with Kosaraju's algorithm - `twosat()`
9.  Strongly connected components with Kosaraju's algorithm - `scc()`
10.  2D convolution - `conv2d()` => *in development*
11.  block convolution - `blconv()` => *in development*
12.  correlation and autocorrelation - `corr()` => *in development*
13.  randomized selection - `rsel()`
14.  minimum in unsorted array - `findMin()`
15.  maximum in unsorted array - `findMax()`
16.  create a row vectory - `vec()`
17.  find sum of two elements in an array - `fsum2()`
18.  mergesort - `msort()`
19.  quicksort - `qsort()`

The library also supports a simple waveform generator, hyperbolic functions (ie, sinh, cosh, etc), complex numbers, as well as log2(num x) and log10(num x) logarithms.

----------

## A Simple Example ##

To perform an fft on a finite length sequence, for example, one could do the following:

    List<int> samples = [0, 1, 2, 3];
    var y = fft(samples);
    y.show();

Or, if you prefer, you can use a type for y as follows:

    List<int> samples = [0, 1, 2, 3];
    FftResults y = fft(samples);
    y.show();

The variable y is actually an object with several return values.  In addition, there is a method show() associated with the FftResults class that will produce the following output for either of these examples:

    6.00
    -2.00 + 2.00j
    -2.00
    -2.00 - 2.00j

To perform an inverse fft to recover the original sequence, one can pass the data field of y to ifft() and an optional string for the print heading:

    var x = ifft(y.data);
    x.show("The inverse fourier transform of y is:");

Prints:

    The inverse fourier transform of y is:
    0.00
    1.00
    2.00
    3.00

Be aware that the although the original sequence was real, the returned sequence is now of type Complex.

----------

## Brief Overview of Some of the Functionality: ##

**FFT:**  The fft function accepts two arguments, the second of which is optional and represents the number of points of the transform to compute, more commonly referred to as N.  If N is not specified, it is set to the length of the sampled data that is passed as the first parameter.  The first parameter is a list (of type num or Complex).

If the user specifies an N that is different than the length of the sampled data, the data is either truncated to the specified N of padded with zeros as necessary to make the length equal to N.

The fft algorithm is actually comprised of 2 algorithms - an O(nlogn) radix2 fast fourier transform for cases when N is a power of 2 and an O(n*n) discrete fourier transform for all other cases.

    var y = fft(samples, [N]);

returns

    y.data (Complex): list of the transformed output data.
    y.value (int): represents the computational effort performed by the algorithm.
    y.input (Complex): list of the input data.  

Note that y.input returns a complex version of the original input data regardless of the form it was originally in.  If the original list was of type int or double, you can recover the input in its original form as follows:

    List<int> origInput = toReal(y.input);

or, similarly:

    List<double> origInput = toReal(y.input);

To display the transformed data (usually an array of complex numbers) as String, you can simply type:

    y.show();

as in the example above.    

**IFFT:**  Performs an inverse FFT and is similar in performance and requirements as the FFT.

    var x = ifft(list, [N]);

returns

    x.data (Complex): list of the inverse transformed output data.
    x.value (int): represents the computational effort performed by the algorithm.
    x.input (Complex): list of the input data. 

In the case of the inverse FFT, the input data is likely to be complex.  However, note that the transformed data is returned as complex regardless of the form the original data was in.  As with the FFT, you can convert the inverse transformed output data to a real list as follows:

    List<int> outputData = toReal(x.data);

or, similarly:

    List<double> outputData = toReal(x.data);

To just display the output data as String you can also simply write (along with an optional string to display a header for the data):

    x.show("Here is the data:");


**Randomized Selection:**  Performs a linear time selection for a certain order statistic from a list of unsorted data.  A simple example is as follows:

    List<int> dataList = [75, 22, 84, 121, 16, 3, 67, 42, 17, 91];
    int order = 5;
    var topFive = rsel(dataList, order, true);
    if (topFive != null) {
      print("The ${order}th order statistic of the input is: ${topFive.value}");
      print("The return list is: ${topFive.data}");
      print("The number of comparisons is: ${topFive.count}");
    }

Prints:

    The 5th order statistic of the input is: 67
    The return list is: [67, 75, 91, 84, 121]
    The number of comparisons is: 14

A detailed description of this algorithm can be found at: [A Linear Time Randomized Selection Algorithm in Dart](http://www.scribegriff.com/studios/index.php?post/2012/05/31/A-Linear-Time-Randomized-Selection-Algorithm-in-Dart "Linear Time Selection")





