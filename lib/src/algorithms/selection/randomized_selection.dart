// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Searches a list of data in linear time and returns the desired
 * order statistic.
 *
 * Example usage:
 *
 *     List<int> dataList = [75, 22, 84, 121, 16, 3, 67, 42, 17, 91];
 *     int order = 5;
 *     var topFive = rsel(dataList, order, true);
 *     if (topFive != null) {
 *       print("The ${order}th order statistic of the input is: "
 *           "${topFive.value}");
 *       print("The return list is: ${topFive.data}");
 *       print("The number of comparisons is: ${topFive.count}");
 *     }
 *
 *     // prints:
 *     The 5th order statistic of the input is: 67
 *     The return list is: [67, 75, 91, 84, 121]
 *     The number of comparisons is: 14
 *
 * where we have passed an optional boolean value true to indicate that we
 * want the highest order statistic.  By default, the algorithm would return
 * the lowest order statistic.
 *
 * Returns an object of type RselResults if successful, null if not.  To return
 * the 12th lowest order statistic in an unordered list of 10,000 unique
 * entries, one could do the following:
 *
 *     // List bigList read from file.
 *     Stopwatch watch = new Stopwatch..start();
 *     int order = 12;
 *     RselResults ostat = rsel(bigList, order);
 *     watch.stop();
 *     if (ostat != null) {
 *       print("The input data has ${ostat.input.length} entries.");
 *       print("The ${order}th order statistic of the input is ${ostat.value}.");
 *       print("The number of comparisons performed was ${ostat.count}.");
 *       print("The time required to perform the selection was "
 *           "${watch.elapsedMilliseconds} msecs.");
 *     } else {
 *       print("Can not complete the selection.");
 *     }
 *
 *     // prints:
 *     The input data has 10000 entries.
 *     The 12th order statistic of the input is 12.
 *     The number of comparisons performed was 24067.
 *     The time required to perform the selection was 163 msecs.
 *
 * Note that the returned list is not in sorted order.
 *
 */

/// The top level function rsel returns the object RselResults.
RselResults rsel(List<int> inList, int orderStat, [bool highOrder = false]) {
  if (orderStat == 0) {
    print("Can not evaluate a zero order statistic.");
    return(null);
  }
  if (inList != null) {
    /// Make a copy of the input list to return with the results.
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

/// The private class _RandomizedSelection.
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

  /// Perform the recursion.
  int rselect(List<int> inList, int lo, int hi, int order) {
    /// Count keeps track of the number of comparisions.
    count += (hi - lo);
    /// The base case.
    if (lo == hi) {
      if (ho) {
        inList.removeRange(0, lo);
        return inList[0];
      } else {
        inList.removeRange(lo + 1, inList.length - lo - 1);
        return inList[lo];
      }
    }
    /// Not base case, so partition array around a new
    /// pivot chosen uniformly at random.
    int j = partition(inList, lo, hi);
    int length = j - lo + 1;
    /// Next case, selected pivot is desired order statistic.
    if (length == order) {
      if (ho) {
        inList.removeRange(0, j);
        return inList[0];
      } else {
        inList.removeRange(j + 1, inList.length - j - 1);
        return inList[j];
      }
    }
    /// Final two cases - continue to recurse on correct portion
    /// of input array.
    else if (order < length) {
      return rselect(inList, lo, j - 1, order);
    } else {
      return rselect(inList, j + 1, hi, order - length);
    }
  }

  /// The partition subroutine is similar to Quicksort.
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

/**
 * RselResults extends standard results class.
 *
 * Returns a list of selected data, the original array,  the requested order
 * statistic and a numeric value indicating how much work was performed to
 * complete the selection.
 *
 */

class RselResults extends ConvoLabResults {
  final List<int> input;
  final int count;

  RselResults(List<int> data, int value, this.count, [this.input]) :
      super(data, value);
}
