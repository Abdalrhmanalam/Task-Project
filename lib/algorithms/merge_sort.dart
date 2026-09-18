class MergeSort {
  static void sort<T>(
    List<T> list,
    int Function(T a, T b) compare,
  ) {
    if (list.length <= 1) {
      return;
    }

    int middle = list.length ~/ 2;

    List<T> left = list.sublist(0, middle);
    List<T> right = list.sublist(middle);

    sort(left, compare);
    sort(right, compare);

    merge(list, left, right, compare);
  }

  static void merge<T>(
    List<T> list,
    List<T> left,
    List<T> right,
    int Function(T a, T b) compare,
  ) {
    int i = 0;
    int j = 0;
    int k = 0;

    while (i < left.length && j < right.length) {
      if (compare(left[i], right[j]) <= 0) {
        list[k] = left[i];
        i++;
      } else {
        list[k] = right[j];
        j++;
      }

      k++;
    }

    while (i < left.length) {
      list[k] = left[i];
      i++;
      k++;
    }

    while (j < right.length) {
      list[k] = right[j];
      j++;
      k++;
    }
  }
}