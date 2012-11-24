part of convolab;

/* ****************************************************** *
 *   FindSum2 finds two values that sum to a result       *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

/*********************  Sum of Two Search ***************************/

Fsum2Results fsum2(List<int> addendList, var sum2find) {
  if (addendList != null) {
    Fsum2Results fsum2Data = new _FindSum2().findMatch(addendList, sum2find);
    return new Fsum2Results(addendList, fsum2Data.value, fsum2Data.results,
        fsum2Data.match);
  } else {
    return(null);
  }
}

class _FindSum2 {
  int addend, sumValue;
  bool match;

  _FindSum2()
      : match = false;

  Fsum2Results findMatch(List<int> sumArray, var sum2find) {
    HashMap sumHashMap = new HashMap();
    List<List<int>> sumResults = [];
    bool found;
    //Build a hash table of input array
    for(int i = 0; i < sumArray.length; i++) {
      if (sumHashMap.containsKey(sumArray[i])) {
        sumHashMap[sumArray[i]] = ++sumHashMap[sumArray[i]];
      } else {
        sumHashMap[sumArray[i]] = 1;
      }
    }
    sumValue = sumHashMap.length;
    //If sum2find is a list, then only return first
    //pair of matched addends for each element in the hash.
    if (sum2find is List) {
      if (sum2find.every(f(item) => item is int)) {
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
        //TODO, not sure I want to handle this with an exception.
        throw new DataFormatException();
      }
    } else if (sum2find is int) {
      //If sum2find is an integer, return all matches.
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
      //sum2find is not an integer.
      //TODO, not sure I want to handle this with an exception.
      throw new DataFormatException();
    }

    // The null value is the input array and is handled by the
    // static function call fsum2().
    return new Fsum2Results(null, sumValue, sumResults, match);
  }
}

/* ****************************************************** *
 *   Fsum2Results extends standard results class          *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class Fsum2Results extends ConvoLabResults {
  final List<List<int>> results;
  final bool match;

  Fsum2Results(List<int> data, int value, this.results, this.match) :
      super(data, value);
}