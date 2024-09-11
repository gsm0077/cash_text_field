library cash_text_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CashTextField extends StatefulWidget {
  CashTextField(
      {super.key,
      required this.fieldController,
      required this.focusNode,
      required this.validator,
      required this.enabled,
      this.decoration,
      this.hasFoucs,
      this.noFoucs,
      this.formatLocale,
      this.onChanged,
      this.onEditingComplete,
      this.onFieldSubmitted});

  final TextEditingController fieldController;
  final FocusNode focusNode;
  final Function(String? value) validator;
  final bool enabled;
  Function? hasFoucs;
  Function? noFoucs;
  InputDecoration? decoration;
  String? formatLocale;
  Function(String? value)? onChanged;
  Function(String? value)? onFieldSubmitted;
  Function? onEditingComplete;

  @override
  State<CashTextField> createState() => _CashTextFieldState();
}

class _CashTextFieldState extends State<CashTextField> {
  final currencyFormatter = NumberFormat("#,##0.00", "en_US");
  late String localFormat;
  TextEditingController controller = TextEditingController();

  bool hasCurrencySymbolAtFront(String text) {
    return text.startsWith("₹");
  }

  String numToCurrencyFormat(double text, String format) {
    var currencyFormatter = NumberFormat.simpleCurrency(locale: format);

    return currencyFormatter.format(text);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializer();
    });

    widget.focusNode.addListener(triggerMethod);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    widget.fieldController.dispose();
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
        controller.text = formattedValue;
      }
    } catch (e) {
      // controller.text = "";
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

  double cleaninputCurrency(String input) {
    try {
      final cleanedInput = input.replaceAll(RegExp(r'[^\d.]'), '');
      final value = double.parse(cleanedInput);
      return value;
    } catch (e) {
      return 0;
    }
  }

  void triggerMethod() {
    if (widget.focusNode.hasFocus == false) {
      if (controller.text.isNotEmpty) {
        final value = cleaninputCurrency(controller.text);
        final formattedValue = numToCurrencyFormat(value, localFormat);
        controller.text = formattedValue;
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
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: widget.decoration,
      onChanged: (value) {
        widget.fieldController.text = value;
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
