# cash_text_field

A Flutter widget for entering numbers, automatically formatting them as localized currency values based on the provided locale or system default. This package uses the intl package to handle number and currency formatting.

## Getting Started 🚀

1. Add cash_text_field package to your dependencies in pubspec.yaml.
   ```yaml
   dependencies:
     ...
     cash_text_field: ^0.0.1
   ```
2. Run `flutter pub get` to install the package.
3. Import the package in your Dart code.
   ```dart
   import 'package:cash_text_field/cash_text_field.dart';
   ```
4. Use the Widget. Example:

   ```dart
          CashTextField(
            fieldController: controller,
            focusNode: focusNodeController,
            validator: (value) {},
            enabled: true,
            // isDark: false,
            formatLocale: "en_IN",
          ),
   ```   