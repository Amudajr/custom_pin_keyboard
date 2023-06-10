part of '../custom_pin_keyboard.dart';

/// The constant values for Pinput
class CustomPinKeyboardConstants {
  const CustomPinKeyboardConstants._();

  /// The default value [CustomPinKeyboard.length].
  static const _defaultLength = 4;

  /// The default value [PinIndicator.size].
  static const _defaultIndicatorSize = 14.0;

  /// The default value [PinIndicator.backgroundColor].
  static const _defaultIndicatorBackground = Colors.grey;

  /// The default value [PinIndicator.progressColor].
  static const _defaultIndicatorProgressColor = Colors.blue;

  /// The default value [PinIndicator.progressColor].
  static const _defaultButtonBackground = Colors.black12;

  /// The default value [PinIndicator.buttonShape].
  static const _defaultButtonShape = CircleBorder();

  /// The default value [CustomPinKeyboard.verticalSeparator].
  static const _defaultVerticalSeparator = SizedBox(height: 14);

  /// The default value [CustomPinKeyboard.horizontalSeparator].
  static const _defaultHorizontalSeparator = SizedBox(width: 14);

  /// The default value [CustomPinKeyboard.indicatorSeparator] and
  /// [PinIndicator.separator].
  static const _defaultIndicatorSeparator = SizedBox(width: 14);

  /// The default value [CustomPinKeyboard.keyboardIndicatorSeparator].
  static const _defaultKeyboardIndicatorSeparator = SizedBox(height: 40);

  /// The default value [CustomPinKeyboard.indicatorSeparator].
  static const _defaultTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    fontSize: 24,
  );
}
