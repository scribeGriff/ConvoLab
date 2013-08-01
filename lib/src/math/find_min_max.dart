part of convolab;

/* ****************************************************** *
 *   Class _FindMinMax returns min and max of a list.     *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

//Find minimum value in a list
num findMin(List input) => new _FindMinMax().search(input, false);

//Find maximum value in a list
num findMax(List input) => new _FindMinMax().search(input, true);

//Find min and max in an array based on the randomized selection algorithm.
class _FindMinMax {
  var randNum;

  _FindMinMax()
      : randNum = new math.Random();

  num search(List input, bool highOrder) {
    int orderStat;
    //Do not modify original list.
    List inList = new List.from(input);
    if (highOrder) {
      orderStat = inList.length;
    } else {
      orderStat = 1;
    }
    return rselect(inList, 0, inList.length - 1, orderStat);
  }

  num rselect(List inList, int lo, int hi, int order) {
    if (lo == hi) return inList[lo];
    int j = partition(inList, lo, hi);
    int length = j - lo + 1;
    if (length == order) { return inList[j];
    } else if (order < length) { return rselect(inList, lo, j - 1, order);
    } else { return rselect(inList, j + 1, hi, order - length);
    }
  }

  int partition(List array, int lo, int hi) {
    int pindex = lo + (randNum.nextDouble()*(hi - lo + 1)).floor().toInt();
    num pivot = array[pindex];
    swap(array, pindex, hi);
    pindex = hi;
    int i = lo - 1;
    for(int j = lo; j <= hi - 1; j++) {
      if(array[j] <= pivot) {
        i++;
        swap(array, i, j);
      }
    }
    swap(array, i + 1, pindex);
    return i + 1;
  }

  void swap (List array, int i, int j) {
    num temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}
