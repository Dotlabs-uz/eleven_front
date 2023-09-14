class StringHelper {
  static String monthName({required int index}) {
    final Map<int, String> map = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };

    return map[index] ?? "";
  }

  static String getCardNumberForCard(String cardNumber) {
    return cardNumber.substring(cardNumber.length - 4);
  }
}
