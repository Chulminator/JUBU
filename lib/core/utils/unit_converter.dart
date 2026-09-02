/// Metric/Imperial converters for recipe amounts. Spoon units stay unchanged.
class UnitConverter {
  UnitConverter._();

  static const double gramsPerOunce = 28.3495;
  static const double millilitersPerCup = 240.0;

  static double gramsToOunces(double amount) => amount / gramsPerOunce;

  static double ouncesToGrams(double amount) => amount * gramsPerOunce;

  /// US legal cup (240 ml), not the 236.588 ml customary cup.
  static double millilitersToCups(double amount) => amount / millilitersPerCup;

  static double cupsToMilliliters(double amount) => amount * millilitersPerCup;

  /// Converts [amount] between g/oz or ml/cup. tbsp/tsp are returned as-is.
  static double convert({
    required double amount,
    required String fromUnit,
    required String toUnit,
  }) {
    final from = fromUnit.toLowerCase();
    final to = toUnit.toLowerCase();
    if (from == to) {
      return amount;
    }
    if (from == 'g' && to == 'oz') {
      return gramsToOunces(amount);
    }
    if (from == 'oz' && to == 'g') {
      return ouncesToGrams(amount);
    }
    if (from == 'ml' && to == 'cup') {
      return millilitersToCups(amount);
    }
    if (from == 'cup' && to == 'ml') {
      return cupsToMilliliters(amount);
    }
    // Keep tbsp/tsp (and any unknown pair) as the original amount.
    return amount;
  }

  /// Drops trailing zeros and keeps at most two decimal places (1.50 -> "1.5").
  static String formatAmount(double amount) {
    final rounded = (amount * 100).round() / 100;
    if (rounded == rounded.truncateToDouble()) {
      return rounded.toInt().toString();
    }
    var text = rounded.toStringAsFixed(2);
    text = text.replaceFirst(RegExp(r'0+$'), '');
    return text;
  }
}
