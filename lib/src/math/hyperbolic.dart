// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 *   Hyperbolic functions to calculate sinh, cosh, tanh, coth, sech and csch.
 */

/// Returns the hyperbolic sine of x.
num sinh(num x) => (math.exp(2*x) - 1) / (2 * math.exp(x));

/// Returns hyperbolic cosine of x.
num cosh(num x) => (math.exp(2*x) + 1) / (2 * math.exp(x));

/// Returns hyperbolic tangent of x.
num tanh(num x) => sinh(x) / cosh(x);

/// Returns hyperbolic cotangent of x.
num coth(num x) => cosh(x) / sinh(x);

/// Returns hyperbolic secant (1 / cosh(x)) of x.
num sech(num x) => ((2 * math.exp(x) / math.exp(2 * x) + 1));

/// Returns hyperbolic cosecant (1 / sinh(x)) of x
num csch(num x) => ((2 * math.exp(x) / math.exp(2 * x) - 1));