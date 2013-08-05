// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Returns a Gaussian random sequence with 0 mean and a variance of 1.
 *
 * If a uniform distribution is desired, set the optional named parameter to
 * false.
 *
 * Example:
 *     // Gaussian (normal) distribution.
 *     Sequence noise = rndseq(37);
 *     // Uniform distribution.
 *     Sequence uniform = rndseq(12, normal:false);
 *
 */

Sequence rndseq(int length, {normal: true}) {
  var randNum = new math.Random();
  if (normal) {
    // Generate a gaussian distributed random sequence.
    return sequence(new Iterable.generate(length, (i) =>
        math.cos(2 * math.PI * randNum.nextDouble()) *
        math.sqrt(-2 * math.log(randNum.nextDouble()))));
  } else {
    // Generate a uniformly distributed random sequence.
    return sequence(new Iterable.generate(length, (i) => randNum.nextDouble()));
  }
}