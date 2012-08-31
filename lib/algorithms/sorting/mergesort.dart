/* ****************************************************** *
 *   MergeSort class returns sorted list and number of    *
 *   computations.                                        *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

/************************  Mergesort *****************************/
MSortResults msort(var fileOrList) {
  List<int> unsortedList = new InputListHandler().prepareList(fileOrList);
  if (unsortedList != null) {
    MSortResults sortedData = new _MergeSort().sort(unsortedList);
    return new MSortResults(sortedData.data, sortedData.value);
  } else {
    return(null);
  }
}

class _MergeSort {
  int count;

  _MergeSort()
      : count = 0;

  MSortResults sort(List<int> myArray) {
    mergesort(myArray, 0, myArray.length-1);
    return new MSortResults(myArray, count);
  }

  void mergesort(List<int> inArray, int lo, int hi){
    if(hi <= lo) return;
    int mid = lo + ((hi - lo)/2).toInt();
    mergesort(inArray, lo, mid);
    mergesort(inArray, mid+1, hi);
    count += merge(inArray, lo, mid, hi);
  }

  int merge(List<int> array, int lo, int mid, int hi) {
    int counter = 0;
    List<int> tmpArray = new List<int>(hi-lo+1);
    int size = mid-lo+1;
    int i = lo;
    int j = mid+1;
    int k;
    //Compare "left" side with the "right" side and keep
    //track of # of inversions using size variable.
    for(k = 0; i <= mid && j <= hi; k++){
      //"left" side smaller than "right" side - no inversion.
      if(array[i] <= array[j]) {
        tmpArray[k] = array[i++];
        size--;
      } else {
        //"left" side larger - inversion.
        tmpArray[k] = array[j++];
        counter += size;
      }
    }

    if (size > 0) {
      while (i <= mid) tmpArray[k++] = array[i++];
    } else {
      while (j <= hi) tmpArray[k++] = array[j++];
    }
    //Build the sorted array.
    k = 0;
    for (i = lo; i <= hi; i++) {
      array[i] = tmpArray[k];
      k++;
    }
    return counter;
  }

}
