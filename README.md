# ConvoLab #

## A signal processing library in Dart ##

Very preliminary and very much a work in progress.  In other words, we're just getting started.  

----------

## Library Methodology ##
The library methodology is based on several principles: 

1.  access to the library is through function calls rather than constructor methods
2.  calls return multiple values which are accessed using object methods
3.  If input data is an array, it can be accessed via a List in memory or with a pathname to an external file
4.  function call returns null on failure

The intent is to be somewhat familiar to users of Matlab and Matlab clones.

----------  
## Example Usage: ##
To perform an fft on a finite length sequence, for example, one could do the following:

    List<int> samples = [0, 1, 2, 3];
    var y = fft(samples);
    y.show();

Or, if you prefer, you can use a type for y as follows:

    List<int> samples = [0, 1, 2, 3];
    FFTResults y = fft(samples);
    y.show();

The variable y is actually an object with several return values.  In addition, there is a method show() associated with the FFTResults class that will produce the following output for either of these examples:

    6.00
    -2.00 + 2.00j
    -2.00
    -2.00 - 2.00j

You can use the export methods of the base results class to either save this data to an external file:

    y.exportToFile('pathName/filename.txt');

or send to a client using a websocket:

    y.exportToWeb('local', 8080);

To perform an inverse fft to recover the original sequence, one can pass the data field of y to ifft():

    var x = ifft(y.data);
    x.show();

Prints:

    0.00
    1.00
    2.00
    3.00

Be aware that the although the original sequence was real, the returned sequence is now of type Complex.

----------

## Brief Overview of Some of the Functionality: ##

**FFT:**  The fft function accepts two arguments, the second of which is optional and represents the number of points of the transform to compute, more commonly referred to as N.  If N is not specified, it is set to the length of the sampled data that is passed as the first parameter.  The first parameter may be either a list (of type num or Complex) or a path to a file containing data.

If the user specifies an N that is different than the length of the sampled data, the data is either truncated to the specified N of padded with zeros as necessary to make the length equal to N.

The fft algorithm is actually comprised of 2 algorithms - an O(nlogn) radix2 fast fourier transform for cases when N is a power of 2 and an O(n*n) discrete fourier transform for all other cases.  Time permitting and need arising, we may investigate a mixed radix fft to provide computational effiency between these two algorithms for the case when N can be decomposed into prime factors.

    var y = fft(listOrFile, [N]);

returns

    y.data (Complex): list of the transformed output data.
    y.value (int): represents the computational effort performed by the algorithm.
    y.input (Complex): list of the input data (this is useful for the case when the data is read from an external file).  

Note that y.input returns a complex version of the original input data regardless of the form it was originally in.  If the original list was of type int or double, you can recover the input in its original form as follows:

    List<int> origInput = toReal(y.input);

or, similarly:

    List<double> origInput = toReal(y.input);

To display the transformed data (usually an array of complex numbers) as String, you can simply type:

    y.show();

as in the example above.  You can also save the calculated data (ie, y.data) in tab delimited format to an external file as follows:

    y.exportToFile('myPath/myExternalFile.txt');

This format allows you to import your data to Matlab, Scilab or other similar tools for plotting, post processing, etc.  You can also arrange to send the data to a client over a websocket:

    y.exportToWeb('local', 8080);    

**IFFT:**  Performs an inverse FFT and is similar in performance and requirements as the FFT.

    var x = ifft(listOrFile, [N]);

returns

    x.data (Complex): list of the inverse transformed output data.
    x.value (int): represents the computational effort performed by the algorithm.
    x.input (Complex): list of the input data (this is useful for the case when the data is read from an external file). 

In the case of the inverse FFT, the input data is likely to be complex.  However, note that the transformed data is returned as complex regardless of the form the original data was in.  As with the FFT, you can convert the inverse transformed output data to a real list as follows:

    List<int> outputData = toReal(x.data);

or, similarly:

    List<double> outputData = toReal(x.data);

To just display the output data as String you can also simply write:

    x.show();

You can also save the calculated data (ie, x.data) in tab delimited format to an external file as follows:

    x.exportToFile('myPath/myExternalFile.txt');

This format allows you to import your data to Matlab, Scilab or other similar tools for plotting, post processing, etc.  You can also arrange to send the data to a client over a websocket:

    y.exportToWeb('local', 8080);  

**RandomizedSelection:**  Performs a linear time selection for a certain order statistic from a list of unsorted data.  A thorough description of the algorithm can be found at [the blog entry at scribegriff.com](http://http://www.scribegriff.com/studios/index.php?post/2012/05/31/A-Linear-Time-Randomized-Selection-Algorithm-in-Dart "Linear Time Randomized Selection Algorithm").  A simple example is as follows:

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

To be continued...






