part of convolab;

/* ****************************************************** *
 *   Standard exception class implements Exception        *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class ConvoLabException implements Exception {
  const ConvoLabException([String msg]);
  String toString() => "Algorithm exception encountered.";
}
