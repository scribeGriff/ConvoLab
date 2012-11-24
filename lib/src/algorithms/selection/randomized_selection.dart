part of convolab;

/* ****************************************************** *
 *   Randomized Selection algorithm                       *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

RselResults rsel(List<int> inList, int orderStat, [bool highOrder = false]) {
  if (orderStat == 0) {
    print("Can not evaluate a zero order statistic.");
    return(null);
  }
  if (inList != null) {
    // Make a copy of the input list to return with the results.
    List<int> input = new List.from(inList);
    orderStat.abs() > inList.length ? orderStat = inList.length :
        orderStat = orderStat.abs();
    if (highOrder) orderStat = inList.length + 1 - orderStat;
    RselResults selectData =
        new _RandomizedSelection().sel(inList, orderStat, highOrder);
    return new RselResults
        (selectData.data, selectData.value, selectData.count, input);
  } else {
    return(null);
  }
}

class _RandomizedSelection {
  var randNum;
  int count;
  bool ho;

  _RandomizedSelection()
      : randNum = new Random(),
        count = 0;

  RselResults sel(List<int> inList, int orderStat, bool highOrder) {
    ho = highOrder;

    int selected = rselect(inList, 0, inList.length - 1, orderStat);
    return new RselResults(inList, selected, count);
  }

  int rselect(List<int> inList, int lo, int hi, int order) {
    count += (hi - lo);
    if (lo == hi) {
      if (ho) {
        inList.removeRange(0, lo);
        return inList[0];
      } else {
        inList.removeRange(lo + 1, inList.length - lo - 1);
        return inList[lo];
      }
    }
    int j = partition(inList, lo, hi);
    int length = j - lo + 1;
    if (length == order) {
      if (ho) {
        inList.removeRange(0, j);
        return inList[0];
      } else {
        inList.removeRange(j + 1, inList.length - j - 1);
        return inList[j];
      }
    }
    else if (order < length) { return rselect(inList, lo, j - 1, order);
    } else { return rselect(inList, j + 1, hi, order - length);
    }
  }

  int partition(List<int> array, int lo, int hi) {
    int pindex = lo + (randNum.nextDouble()*(hi - lo + 1)).floor().toInt();
    int pivot = array[pindex];
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

  void swap (List<int> array, int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}

/* ****************************************************** *
 *   RselResults extends standard results class           *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class RselResults extends ConvoLabResults {
  final List<int> input;
  final int count;

  RselResults(List<int> data, int value, this.count, [this.input]) :
      super(data, value);
}
