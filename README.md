![](http://www.scribegriff.com/dartlang/github/Convolab/convolab-library.png)

# Convolab #

## A signal processing library for Dart ##
[![Build Status](https://drone.io/github.com/scribeGriff/ConvoLab/status.png)](https://drone.io/github.com/scribeGriff/ConvoLab/latest)

[![endorse](https://api.coderwall.com/scribegriff/endorsecount.png)](https://coderwall.com/scribegriff)

## Overview ##
 
The ability to create 2-dimensional, canvas based plots of signal waveforms is available through the [simplot](https://github.com/scribeGriff/simplot "simplot library") library.

The graph-centric algorithms (ie, scc, 2-sat, Prim's MST, Kruskal's MST, all pairs shortest path and the knapsack algorithm) have been moved to the [graphlab](https://github.com/scribeGriff/graphlab "graphlab library") library.

The library is currently moving its 1-dimensional data structure from `List` to `Sequence`, which extends the `ListBase` class and adds a number of methods and capabilities.

This library is being actively developed and breaking changes are to be expected.

Some features of the library include:

- Flexible data structures:   
Sequences: generate and easily manipulate impulse, step, position or arbitrary sequences  
Complex numbers: create complex numbers and handle complex calculations
- Hyperbolic and logarithmic functions: `sinh()`, `cosh()`, `log2()`, `log10()` etc. 
- Simple waveform generator: square, pulse, triangular, etc.
- Polynomial string construction in text, HTML or latex format
- Common signal processing algorithms including (more are in development):   
`fft()`: fast and discrete Fourier transform   
`ifft()`: fast and discrete inverse Fourier transform  
`fsps()`: partial sums of Fourier series   
`conv()`: convolution   
`deconv()`: deconvolution  
`corr()`: cross and auto correlation   
`filter()`: a 1D transposed direct form II digital filter structure 

Most library access is through top level function calls.
  
## Library Usage: ##

Add the following to your pubspec.yaml:

````dart
convolab:
  git: git://github.com/scribeGriff/ConvoLab.git
````

Then import the library to your app:

````dart
import 'package:convolab/convolab.dart';
````

### Sequences ###

The library is currently moving to using Sequences as the main data structure.  A sequence extends from the `ListBase` class and therefore shares many of the same methods of the List data type.  Some examples of using a Sequence data structure:

````dart
// Creates a List object.
var list = [1, 2, 3, 4];
// Converts the List into a Sequence.
var seq1 = sequence(list);
// Check if seq1 is a Sequence.
print(seq1 is Sequence);
// Print the sequence.
print(seq1);
// Prints:
// true
// [1, 2, 3, 4]

// Any Iterable, including another sequence, can be passed to the
// sequence function.
var seq2 = sequence(list.map((element) => element * 2));

// Sequences can be added, subtracted, multiplied, and divided element
// by element:
var seq3 = seq1 + seq2;
print(seq3);
// Prints:
// [3, 6, 9, 12]

// and element by number:
var seq4 = seq3 * 2;
print(seq4);
// Prints: 
// [6, 12, 18, 24]

// Sequences can be made periodic:
print(sequence(seq1, 4));
// Prints:
// [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]
````

Sequences allow us to perform a variety of tasks on sampled data.  For example, suppose we had a sample sequence, x(n), and we wanted to know what x1(n) = 2x(n - 5) - 3x(n + 4) was.

````dart
// x(n)
Sequence x = sequence([1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1]);
// n, zeroth position at element 2.
Sequence n = x.position(2);
// n - 5
Sequence nm5 = shiftseq(n, 5);
// n + 4
Sequence np4 = shiftseq(n, -4);
// x1(n) = 2x(n - 5) - 3x(n + 4)
var x1 = addseqs(x * 2, x * -3, nm5, np4);
print(x1.x);
print(x1.n);
// Prints:
// [-3, -6, -9, -12, -15, -18, -21, -18, -15, -10, -5, 0, 5, 10, 12, 14, 12, 10, 8, 6, 4, 2]
// [-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
````

The function, `addseqs()`, allows us to add sequences that have position information.  In this example, the n = 0 sample point was the 3rd element in the sequence x(n).  The function `shiftseq()` (as well as `foldseq()`), are also methods of the Sequence class.  Therefore, we could do the following:

````dart
var x2 = position(11, 5);
print(x2);
print(x2.shiftseq(2).foldseq(negate:true));
// Prints:
// [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
// [-7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3] 
````

The `position()` function creates a sample position sequence 11 samples long and places the 0 position at the 6th position in the sequence (sequences, like all `Iterables` in the Dart programming language, are based on the first element being element 0).

To convert a sequence to a list, simply use the `toList()` method of the `ListBase` class.

#### Sequence methods (other than those inherited from `ListBase`)
- `+` operator - adds a sequence to another sequence of the same length or to a number
- `-` operator - subtracts a sequence from another sequence of the same length or from a number
- `*` operator - multiplies a sequence by another sequence of the same length or by a number
- `/` operator - divides a sequence by another sequence of the same length or by a number
- `position()` - creates a position sequence
- `shiftseq()` - shifts a sequence
- `foldseq()` - folds(ie, reverses) a sequence
- `toReal()` - converts a complex sequence to a real valued sequence
- `toComplex()` - converts a real sequence to a complex valued sequence
- `equals()` - returns a boolean indicating element by element equivalence between two sequences
- `abs()` - returns a sequence with the absolute value of each element
- `min()` - returns the minimum of a sequence
- `max()` - returns the maximum of a sequence
- `sum()` - returns the sum of a sequence
- `prod()` - returns the product of a sequence
- `energy()` - returns the energy of a sequence
- `power()` - returns the power of a sequence
- `iterator` - returns an iterator to the sequence (allows `for` `in` and `forEach`)
- `middle` - returns the index of the middle element of the sequence (truncates)

#### Sequence functions
- `sequence()` - create a new sequence from an Iterable
- `position()` - creates a position sequence
- `zeros()` - creates a sequence of zeros
- `ones()` - creates a sequence of ones
- `impseq()` - creates an impulse sequence
- `stepseq()` - creates a step sequence
- `shiftseq()` - shifts a sequence
- `foldseq()` - folds (ie, reverses) a sequence
- `addseqs()` - adds sequences that are of differing lengths and/or have position information
- `multseqs()` - multiplies sequences that are of differing lengths and/or have position information
- `evenodd()` - decompose a sequence into its even and odd components.

----------

### Complex Numbers ###

The library contains support for complex numbers.  A complex number can be defined as follows:

````dart
var c = complex(1, 2);
print(c.string);
// Prints:
// 1.00 + 2.00j
````

The complex class implements the following methods:

- `string` - returns the complex number as a string
- `magnitude` - returns the magnitude of a complex number
- `phase` - returns the phase of a complex number
- `croud2` - rounds fractional part of complex number to two significant digits
- `conj` - returns the complex conjugate of the complex number
- `recip` - returns the reciprocal of the complex number
- `cexp` - returns the complex exponential of the complex number
- `csin` - returns the complex sine of the complex number
- `ccos` - returns the complex cosine of the complex number
- `ctan` - returns the complex tangent of the complex number
- `scale()` - scales the complex number by a number of type int or double
- `+` operator adds a complex number to another complex number
- `-` operator subtracts a complex number from another complex number
- `*` operator multiplies a complex number by another complex number
- `/` operator divides a complex number by another complex number
- `==` operator checks if two complex numbers are equal (`hashCode` is implemented)

----------

### Poly Strings ###

To convert a sequence to a readable polynomial string, the library contains a function called `pstring()`.  The function can generate strings in text, HTML, or Latex format.  In its simplest form, `pstring()` requires only a sequence of polynomial coefficients:

````dart
// Simple case - defaults
Sequence coefficients = sequence([2, 5, -3, 7]);
String polyString = pstring(coefficients);
print(polyString);
// prints:
// $$f(x) = 2 + 5x^{-1} - 3x^{-2} + 7x^{-3}$$
````

The Latex format, for use with MathJax in a browser, is the default.  The `pstring()` function also accepts several named optional parameters:

- `index`: for causal signals, this is the n = 0 position index (default = 0)
- `type`: String representing desired format text, html, latex (default = 'latex')
- `variable`: String representing the variable name (default = 'x')
- `name`: String representing the function name (default = 'f')

Some additional examples:

````dart
// Setting options - html format.
polyString = pstring(coefficients, type: 'html', name: 'y', variable: 'n');
print(polyString);
// prints:
// y(n) = 2 + 5n<sup>-1</sup> - 3n<sup>-2</sup> + 7n<sup>-3</sup>

// Send the output to element on a webpage
query("#myDiv").appendHtml(pstring(test, type:'html'));

// Working with causal signals.
zeroIndex = 2;
polyString = pstring(coefficients, index: zeroIndex, type: 'html', name: 'y', variable: 'n');
print(polyString);
// prints:
// y(n) = 2n<sup>2</sup> + 5n - 3 + 7n<sup>-1</sup>

// Another example working with causal signals.
coefficients = sequence([1, 1, 1, 1, 1, 1]);
polyString = pstring(coefficients, index: zeroIndex, type: 'text');
print(polyString);
// prints:
// f(x) = x^2 + x + 1 + x^-1 + x^-2 + x^-3
````

The library functions `conv()` and `deconv()` both implement the `PolyString` class as a `format()` method to the function results.  In the case of `deconv()`, the `format()` method handles remainders.

----------
 
 




