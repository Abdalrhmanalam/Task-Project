class QuickSort {
  static void sort<T>(
    List<T> list,
    int Function(T a, T b) compare,
  ) {
    if (list.length <= 1) {
      return;
    }

    quickSort(list, 0, list.length - 1, compare);
  }

  static void quickSort<T>(
    List<T> list,
    int low,
    int high,
    int Function(T a, T b) compare,
  ) {
    if (low < high) {
      int pivotIndex = partition(
        list,
        low,
        high,
        compare,
      );

      quickSort(
        list,
        low,
        pivotIndex - 1,
        compare,
      );

      quickSort(
        list,
        pivotIndex + 1,
        high,
        compare,
      );
    }
  }

  static int partition<T>(
    List<T> list,
    int low,
    int high,
    int Function(T a, T b) compare,
  ) {
    T pivot = list[high];

    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (compare(list[j], pivot) <= 0) {
        i++;

        T temp = list[i];
        list[i] = list[j];
        list[j] = temp;
      }
    }

    T temp = list[i + 1];
    list[i + 1] = list[high];
    list[high] = temp;

    return i + 1;
  }
}