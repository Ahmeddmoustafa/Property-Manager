import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Custom formatting logic
    String formattedText =
        newValue.text.replaceAll(',', ''); // Remove existing commas

    int number = int.tryParse(formattedText) ?? 0;
    List<String> parts = [];

    while (number >= 1000) {
      parts.insert(0, (number % 1000).toString().padLeft(3, '0'));
      number ~/= 1000;
    }

    parts.insert(0, number.toString());

    formattedText = parts.join(',');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
