part of convolab;

/* ************************************************************************ *
 *   Top level functions to implement a number of computations              *
 *   involving lists, including:                                            *
 *   toReal() complex --> real list conversion                              *
 *   toComplex() real --> complex list conversion                           *
 *   sum() sums all elements of a real list                                 *
 *   Library: ConvoLab (c) 2012 scribeGriff                                 *
 * ************************************************************************ */

// Sum all the elements in a List.
num sum(List<num> inputList) {
  var result = 0;
  for (final element in inputList) result += element;
  return result;
}

// Convert a list from complex to real.
List<num> toReal(List<Complex> complexList) {
  if (complexList.every(f(element) => element is Complex)) {
    List _realList = [];
    for (var i = 0; i < complexList.length; i++) {
      _realList.add(complexList[i].real);
    }
    return _realList;
  } else {
    print("The input data is not formatted correctly.");
    print("Elements must be type complex.");
    return(null);
  }
}

// Convert a list from real to complex.
List<Complex> toComplex(List realList) {
  if (realList.every(f(element) => element is num)) {
    List _complexList = [];
    for (var i = 0; i < realList.length; i++) {
      _complexList.add(complex(realList[i], 0));
    }
    return _complexList;
  } else {
    print("The input data is not formatted correctly.");
    print("Elements must be type num.");
    return(null);
  }
}
