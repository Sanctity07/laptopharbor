import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currency = NumberFormat.currency(symbol: r'$');

  static String price(double value) => _currency.format(value);

  static String date(DateTime date) => DateFormat('MMM d, yyyy').format(date);
}
