library cash_text_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CashSymbolField extends StatefulWidget {
  CashSymbolField(
      {super.key,
      required this.fieldController,
      required this.focusNode,
      required this.validator,
      required this.enabled,
      required this.isDark,
      this.decoration,
      this.hasFoucs,
      this.noFoucs,
      this.formatLocale,
      this.onChanged,
      this.onEditingComplete,
      this.onFieldSubmitted});

  TextEditingController fieldController;
  FocusNode focusNode;
  Function(String? value) validator;
  bool enabled;
  bool isDark;
  Function? hasFoucs;
  Function? noFoucs;
  InputDecoration? decoration;
  String? formatLocale;

  Function(String? value)? onChanged;
  Function(String? value)? onFieldSubmitted;
  Function? onEditingComplete;
  @override
  State<CashSymbolField> createState() => _CashSymbolFieldState();
}

class _CashSymbolFieldState extends State<CashSymbolField> {
  final currencyFormatter = NumberFormat("#,##0.00", "en_US");

  bool hasCurrencySymbolAtFront(String text) {
    return text.startsWith("₹");
  }

  String numToCurrencyFormat(int text, String format) {
    var currencyFormatter = NumberFormat.simpleCurrency(locale: format);

    return currencyFormatter.format(text);
  }

  late String localFormat;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializer();
    });

    widget.focusNode.addListener(triggerMethod);

    super.initState();
  }

  void initializer() {
    String localeString = Intl.getCurrentLocale();
    setState(() {
      localFormat = widget.formatLocale ?? localeString;
    });
    try {
      if (widget.fieldController.text.isNotEmpty) {
        final value = cleaninputCurrency(widget.fieldController.text);
        final formattedValue = numToCurrencyFormat(value, localFormat);
        widget.fieldController.text = formattedValue;
      }
    } catch (e) {
      print(79);
      print("error at the initial value");
    }
  }

  bool isValidCurrency(String input, String localeInput) {
    try {
      // Define the currency format (assuming US dollars)
      final format = NumberFormat.simpleCurrency(locale: localeInput);

      // Remove currency symbol and try parsing
      final cleanedInput = input.replaceAll(RegExp(r'[^\d.,]'), '');
      final number = format.parse(cleanedInput);

      // Check if the number is not null and matches the original formatted string
      final formattedNumber = format.format(number);
      return formattedNumber == input;
    } catch (e) {
      return false;
    }
  }

  int cleaninputCurrency(String input) {
    try {
      final cleanedInput = input.replaceAll(RegExp(r'[^\d.,]'), '');
      final value = int.parse(cleanedInput);
      return value;
    } catch (e) {
      return 0;
    }
  }

  void triggerMethod() {
    if (widget.focusNode.hasFocus == false) {
      if (widget.fieldController.text.isNotEmpty) {
        final value = cleaninputCurrency(widget.fieldController.text);
        final formattedValue = numToCurrencyFormat(value, localFormat);
        widget.fieldController.text = formattedValue;
      } else {
        print("Empty");
      }
      widget.noFoucs != null ? widget.noFoucs!() : () {};
    } else {
      widget.hasFoucs ?? () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      controller: widget.fieldController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: widget.decoration,
      onChanged: (value) {
        widget.onChanged != null ? widget.onChanged!(value) : () {};
      },
      onFieldSubmitted: (value) {
        widget.onFieldSubmitted != null
            ? widget.onFieldSubmitted!(value)
            : () {};
        widget.focusNode.unfocus();
      },
      validator: (value) {
        return widget.validator(value);
      },
      onEditingComplete: () {
        widget.onEditingComplete != null ? widget.onEditingComplete!() : () {};
        widget.focusNode.unfocus();
      },
    );
  }
}
