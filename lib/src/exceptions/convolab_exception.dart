// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 *   Standard library exception.
*/

class ConvoLabException implements Exception {
  const ConvoLabException([String msg]);
  String toString() => "Algorithm exception encountered.";
}
