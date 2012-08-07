/* *************************************************************** *
 *   Top level functions to implement hyperbolic functions         *
 *   Library: ConvoLab (c) 2012 scribeGriff                        *
 * *************************************************************** */

// hyperbolic sine
num sinh(num x) => (exp(2*x) - 1) / (2 * exp(x));

// hyperbolic cosine
num cosh(num x) => (exp(2*x) + 1) / (2 * exp(x));

// hyperbolic tangent
num tanh(num x) => sinh(x)/cosh(x);

// hyperbolic cotangent
num coth(num x) => cosh(x)/sinh(x);

// hyperbolic secant = 1/cosh(x)
num sech(num x) => ((2 * exp(x) / exp(2*x) + 1));

// hyperbolic cosecant = 1/sinh(x)
num csch(num x) => ((2 * exp(x) / exp(2*x) - 1));