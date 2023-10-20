class IntHelper {
  static int getCountOfCardByWorkingHours(
    DateTime from,
    DateTime to,
  ) {
    final result = from.difference(to).inHours;
    return result * -1 ;
  }
}
