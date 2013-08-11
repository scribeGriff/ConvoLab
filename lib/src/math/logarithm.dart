// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Logarithmic functions to calculate log base 2 and log base 10 of x.
 */

/// Returns log base 2 of x.
num log2(num x) => math.log(x) / math.log(2);
/// Returns log base 10 of x.
num log10(num x) => math.log(x) / math.log(10);
