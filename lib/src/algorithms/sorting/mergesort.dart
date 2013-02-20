// Copyright (c) 2012, scribeGriff (Richard Griffith)
// https://github.com/scribeGriff/ConvoLab
// All rights reserved.  Please see the LICENSE.md file.

part of convolab;

/**
 * Sorts a list of integers using the Mergesort algorithm.
 *
 * This is a classic implementation of the Mergesort divide and
 * conquer algorithm.
 *
 * Example usage:
 *
 *     List<int> dataList = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
 *     var msResults = msort(dataList);
 *     print(msResults.data);
 *     print(msResults.value);
 *
 * Returns an object of type MsortResults where the data field is
 * the sorted list and value is the number of inversions performed
 * to sort the input list.  Returns null if input list is null.
 */

/// The top level function msort returns the object MsortResults.
MsortResults msort(List<int> unsortedList) {
  if (unsortedList != null) {
    MsortResults sortedData = new _MergeSort().sort(unsortedList);
    return new MsortResults(sortedData.data, sortedData.value);
  } else {
    return(null);
  }
}

/// The private class _MergeSort.
class _MergeSort {
  int count;

  _MergeSort()
      : count = 0;

  MsortResults sort(List<int> myArray) {
    mergesort(myArray, 0, myArray.length-1);
    return new MsortResults(myArray, count);
  }

  void mergesort(List<int> inArray, int lo, int hi){
    if(hi <= lo) return;
    int mid = lo + ((hi - lo) >> 1);
    mergesort(inArray, lo, mid);
    mergesort(inArray, mid+1, hi);
    count += merge(inArray, lo, mid, hi);
  }

  int merge(List<int> array, int lo, int mid, int hi) {
    int counter = 0;
    List<int> tmpArray = new List<int>.fixedLength(hi-lo+1);
    int size = mid-lo+1;
    int i = lo;
    int j = mid+1;
    int k;
    /// Compare "left" side with the "right" side and keep
    /// track of # of inversions using size variable.
    for(k = 0; i <= mid && j <= hi; k++){
      /// "left" side smaller than "right" side - no inversion.
      if(array[i] <= array[j]) {
        tmpArray[k] = array[i++];
        size--;
      } else {
        /// "left" side larger - inversion.
        tmpArray[k] = array[j++];
        counter += size;
      }
    }

    if (size > 0) {
      while (i <= mid) tmpArray[k++] = array[i++];
    } else {
      while (j <= hi) tmpArray[k++] = array[j++];
    }
    /// Build the sorted array.
    k = 0;
    for (i = lo; i <= hi; i++) {
      array[i] = tmpArray[k];
      k++;
    }
    return counter;
  }

}

/**
 * MsortResults extends standard results class.
 *
 * Returns the sorted array and a value for the number of inversions
 * that were performed during the sort.
 */

class MsortResults extends ConvoLabResults {
  MsortResults(List<int> data, int value) : super(data, value);
}
