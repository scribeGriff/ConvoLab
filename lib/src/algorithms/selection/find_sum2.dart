// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Finds two values in a list that sum to a specified value.
 *
 * Example usage:
 *     List<int> dataList = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
 *     List<List<int>> auData = [[6, 10], [7, 9]];
 *     var sum = 16;
 *     var findSum = fsum2(dataList, sum);
 *     print(findSum.results);
 *
 * Prints:
 *     [[6, 10], [7, 9]];
 *
 * If sum is an integer, returns all matches if duplicates are found.
 * For example:
 *     List<int> dataList = [1, 1, 1, 1, 1, 1, 1];
 *     int sum = 2;
 *     var findSum = fsum2(dataList, sum);
 *     print(findSum.results);
 *
 * Prints:
 *     [[1, 1], [1, 1], [1, 1]];
 *
 * But a list of sums to find can also be supplied.  In this case, only
 * the first match, if any, for each sum in the list is returned.  If no
 * match is found, then the result is returned as null.
 *
 * If any match is found, a boolean variable is returned as true.  If no
 * match is found, the value of this variable is false.  For example, you
 * can just poll if a match was made rather than checking its value if
 * a large number of iterations is required.
 *
 * For example:
 *     if (findSum.match) {
 *       print('Found a match');
 *     }
 *
 * Returns an object of type Fsum2Results.  Throws a data format exception
 * if any of the data is not of type int.  Returns null if data is empty of
 * undefined.
 *
 */

/// The top level function fsum2 returns an object of type Fsum2Results.
Fsum2Results fsum2(List<int> addendList, var sum2find) {
  if (addendList != null) {
    Fsum2Results fsum2Data = new _FindSum2().findMatch(addendList, sum2find);
    return new Fsum2Results(addendList, fsum2Data.value, fsum2Data.results,
        fsum2Data.match);
  } else {
    return(null);
  }
}

/// The private class _FindSum2 called by fsum2().
class _FindSum2 {
  int addend, sumValue;
  bool match;

  _FindSum2()
      : match = false;

  Fsum2Results findMatch(List<int> sumArray, var sum2find) {
    HashMap sumHashMap = new HashMap();
    List<List<int>> sumResults = [];
    bool found;
    /// Build a hash table of input array.
    for(int i = 0; i < sumArray.length; i++) {
      if (sumHashMap.containsKey(sumArray[i])) {
        sumHashMap[sumArray[i]] = ++sumHashMap[sumArray[i]];
      } else {
        sumHashMap[sumArray[i]] = 1;
      }
    }
    sumValue = sumHashMap.length;
    /// If sum2find is a list, then only return first
    /// pair of matched addends for each element in the hash.
    if (sum2find is List) {
      if (sum2find.every((item) => item is num)) {
        sum2find.forEach((element) {
          found = false;
          for (int i = 0; i < sumArray.length; i++) {
            addend = element - sumArray[i];
            if (sumHashMap.containsKey(addend)) {
              match = found = true;
              if (addend == sumArray[i]) {
                if (sumHashMap[addend] > 1) {
                  sumResults.add([addend, sumArray[i]]);
                }
              } else {
                sumResults.add([addend, sumArray[i]]);
              }
              break;
            }
          }
          if (!found) sumResults.add([null, null]);
        });
      } else {
        /// sum2find is not of type num.
        throw new DataFormatException();
      }
    } else if (sum2find is num) {
      /// If sum2find is a num, return all matches.
      for (int i = 0; i < sumArray.length; i++) {
        addend = sum2find - sumArray[i];
        if (sumHashMap.containsKey(addend) && sumHashMap[addend] > 0) {
          match = true;
          if (addend == sumArray[i]) {
            //found duplicate
            if (sumHashMap[addend] > 1) {
              sumResults.add([addend, sumArray[i]]);
              sumHashMap[addend] -= 2;
            }
          } else {
            sumResults.add([addend, sumArray[i]]);
            sumHashMap[sumArray[i]] -= 1;
          }
        }
      }
      if (!match) sumResults.add([null, null]);
    } else {
      /// sum2find is not a num.
      throw new DataFormatException();
    }

    /// The null value is the input array and is included by the
    /// static function call fsum2().
    return new Fsum2Results(null, sumValue, sumResults, match);
  }
}

/**
 *   Fsum2Results extends standard results class.
 *
 *   Returns the results of the function call fsum2().  Returns the
 *   original data, the length of the internal hash map, the results
 *   of the search in a list, and a boolean variable indicating if a
 *   match was made.
 */

class Fsum2Results extends ConvoLabResults {
  final List<List<int>> results;
  final bool match;

  Fsum2Results(List<int> data, int value, this.results, this.match) :
      super(data, value);
}