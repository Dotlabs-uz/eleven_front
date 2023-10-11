class IntHelper {
  static int getCountOfCardByWorkingHours(
    DateTime from,
    DateTime to,
  ) {
    final result = from.difference(to).inHours;
    print("Result ${result * -1}");
    return result * -1 ;
  }
}
