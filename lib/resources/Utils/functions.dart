import 'package:intl/intl.dart';

String formatPrice(double price) {
  NumberFormat formatter = NumberFormat("#,###");
  return formatter.format(price);
}

String formatDate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

String chartFormatPrice(double price) {
  String formattedPrice = (price / 1000000).toStringAsFixed(2);

  // Remove trailing zeros and decimal point if necessary
  formattedPrice = formattedPrice.replaceAll(RegExp(r'0*$'), '');
  formattedPrice = formattedPrice.replaceAll(RegExp(r'\.$'), '');

  return formattedPrice;
}
