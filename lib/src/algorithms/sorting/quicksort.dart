part of convolab;

/* ****************************************************** *
 *   QuickSort class returns sorted list and number of    *
 *   computations.                                        *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

/************************** QuickSort *****************************/

QsortResults qsort(List<int> unsortedList, [String pivotType = 'median']) {
  if (unsortedList != null) {
    QsortResults sortedData = new _QuickSort().sort(unsortedList, pivotType);
    return new QsortResults(sortedData.data, sortedData.value);
  } else {
    return(null);
  }
}

class _QuickSort {
  String pt;
  int count;

  _QuickSort()
      : count = 0;

  // Calls recursive algorithm quicksort() and passes array, size and
  // pivot method.
  QsortResults sort(List<int> myArray, String pivotType) {
    pt = pivotType;
    quicksort(myArray, 0, myArray.length-1);
    return new QsortResults(myArray, count);
  }

  //Recursive calls through quicksort keep track of # of comparisons.
  void quicksort(List<int> inArray, int lo, int hi) {
    if (hi <= lo) return;
    count += (hi - lo);
    int pivot = partition(inArray, lo, hi);
    quicksort(inArray, lo, pivot-1);  //Sort left part a[lo .. i-1].
    quicksort(inArray, pivot+1, hi);  //Sort right part a[i+1 .. hi].
  }

  int partition(List<int> array, int lo, int hi) {
    //Preprocess pivot depending on method
    //using a switch list (if 'first' => no need to swap).
    //Need to add random pivot.
    switch (pt) {
      case 'last':
        swap(array, lo, hi);
        break;
      case 'median':
        median3(array, lo, hi);
        break;
      case 'median1':
        median3Alt1(array, lo, hi);
        break;
      case 'median2':
        median3Alt2(array, lo, hi);
        break;
    }

    //Always set pivot to first element after preprocessing.
    int pivot = array[lo];
    int i = lo+1;
    int j;
    //Scan subarray and sort according to <, > pivot.
    for (j = lo+1; j <= hi; j++) {
      if (array[j] < pivot) {
        swap(array, i, j);
        i++;
      }
    }
    //Set up new pivot point.
    swap(array, lo, i-1);
    return i-1;
  }

  //Swap two entries in an array:
  void swap(List<int> array, int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }

  //The following are several median of 3 methods, the
  //first uses a different number of comparisons than
  //the second two.
  void median3(List<int> array, int lo, int hi) {
    int mid = ((lo + hi) >> 1);
    int small, median, large;
    if (array[lo] > array[mid]) {
      large = lo;
      small = mid;
    } else {
      large = mid;
      small = lo;
    }
    if (array[hi] > array[large]) {
      median = large;
    } else if (array[hi] < array[small]) {
      median = small;
    } else {
      median = hi;
    }
    swap(array, lo, median);
  }

  //The more common approach but one that will provide a different
  //number of comparisons than the median3().
  void median3Alt1(List<int> array, int lo, int hi) {
    int mid = ((lo + hi) >> 1);
    if (array[mid].compareTo(array[lo]) < 0 ) {
      swap(array, lo, mid);
    }
    if (array[hi].compareTo(array[lo]) < 0 ) {
      swap(array,lo, hi);
    }
    if (array[hi].compareTo(array[mid]) < 0 ) {
      swap(array, mid, hi);
    }
    swap(array, lo, mid);
  }
  //Or if you prefer, you can write Alt1 as follows:
  void median3Alt2(List<int> array, int lo, int hi) {
    int mid = ((lo + hi) >> 1);
    if (array[mid] < array[lo]) swap(array, lo, mid);
    if (array[hi] < array[lo]) swap(array,lo, hi);
    if (array[hi] < array[mid]) swap(array, mid, hi);
    swap(array, mid, lo);
  }
}

/* ****************************************************** *
 *   QsortResults extends standard results class          *
 *   Library: ConvoLab (c) 2012 scribeGriff               *
 * ****************************************************** */

class QsortResults extends ConvoLabResults {
  QsortResults(List<int> data, int value) : super(data, value);
}
