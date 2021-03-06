// Copyright (c) 2013, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 *   Top level functions to implement a number of computations
 *   involving lists, including:
 *   toReal() complex --> real list conversion
 *   toComplex() real --> complex list conversion
 *   sum() sums all elements of a real list
 */

// Sum all the elements in a List.
num sum(List<num> inputList) {
  var result = 0;
  for (final element in inputList) {
    if (element != null) result += element;
  }
  return result;
}

// Convert a list from complex to real.
List<num> toReal(List<Complex> complexList, [bool toint = false]) {
  if (complexList.every((element) => element is Complex)) {
    List _realList = [];
    for (var i = 0; i < complexList.length; i++) {
      if (toint) {
        _realList.add(complexList[i].cround2.real.toInt());
      } else {
      _realList.add(complexList[i].real);
      }
    }
    return _realList;
  } else {
    throw new FormatException('This sequence is not of type Complex');
  }
}

// Convert a list from real to complex.
List<Complex> toComplex(List realList) {
  if (realList.every((element) => element is num)) {
    List _complexList = [];
    for (var i = 0; i < realList.length; i++) {
      _complexList.add(complex(realList[i], 0));
    }
    return _complexList;
  } else if (realList.every((element) => element is Complex)) {
    // List is already complex so just return the list.
    return realList;
  } else {
    throw new FormatException('This sequence is not of type num');
  }
}
