import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Custom formatting logic
    String formattedText = newValue.text;

    if (formattedText.length > 3) {
      formattedText = formattedText.replaceAllMapped(
          RegExp(r'(\d{3})(?=\d)'), (Match match) => '${match.group(1)},');
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
