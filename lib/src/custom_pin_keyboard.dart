import 'package:flutter/material.dart';

part 'pin_indicator.dart';
part 'util/custom_pin_keyboard_constants.dart';

typedef PinEnteredCallback = Future<void> Function(String passcode);

class CustomPinKeyboard extends StatefulWidget {
  const CustomPinKeyboard({
    Key? key,
    this.onCompleted,
    this.length = CustomPinKeyboardConstants._defaultLength,
    this.controller,
    this.restorationId,
    this.onChanged,
    this.indicatorSize = CustomPinKeyboardConstants._defaultIndicatorSize,
    this.indicatorBackground =
        CustomPinKeyboardConstants._defaultIndicatorBackground,
    this.indicatorProgressColor =
        CustomPinKeyboardConstants._defaultIndicatorProgressColor,
    this.indicatorBorder,
    this.verticalSeparator =
        CustomPinKeyboardConstants._defaultVerticalSeparator,
    this.horizontalSeparator =
        CustomPinKeyboardConstants._defaultHorizontalSeparator,
    this.indicatorSeparator =
        CustomPinKeyboardConstants._defaultIndicatorSeparator,
    this.textStyle = CustomPinKeyboardConstants._defaultTextStyle,
    this.keyboardIndicatorSeparator =
        CustomPinKeyboardConstants._defaultKeyboardIndicatorSeparator,
    this.buttonBackground = CustomPinKeyboardConstants._defaultButtonBackground,
    this.buttonShape = CustomPinKeyboardConstants._defaultButtonShape,
  }) : super(key: key);

  /// Fires when user completes pin input.
  final PinEnteredCallback? onCompleted;

  /// Used to get, modify CustomPinKeyboard value and more.
  /// Don't forget to dispose controller!
  /// ``` dart
  ///   @override
  ///   void dispose() {
  ///     controller.dispose();
  ///     super.dispose();
  ///   }
  /// ```
  final TextEditingController? controller;

  /// See [TextField.restorationId].
  final String? restorationId;

  /// Called every time input value changes.
  final ValueChanged<String>? onChanged;

  /// PIN code length.
  final int length;

  /// Size of indicator dots.
  final double indicatorSize;

  /// Background color of indicator dots.
  final Color indicatorBackground;

  /// Color of filled indicator dots.
  final Color indicatorProgressColor;

  /// Border of indicator dots.
  final Border? indicatorBorder;

  /// Builds a vertical separator between keyboard buttons.
  final Widget verticalSeparator;

  /// Builds a horizontal separator between keyboard buttons.
  final Widget horizontalSeparator;

  /// Builds a separator between indicator dots.
  final Widget indicatorSeparator;

  /// Builds a separator between keyboard and indicator.
  final Widget keyboardIndicatorSeparator;

  /// Text style of numbers.
  final TextStyle textStyle;

  /// Color of keyboard buttons.
  final Color buttonBackground;

  /// Shape of keyboard buttons.
  final OutlinedBorder buttonShape;

  @override
  State<CustomPinKeyboard> createState() => _CustomPinKeyboardState();
}

class _CustomPinKeyboardState extends State<CustomPinKeyboard>
    with RestorationMixin {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  String get pin => _effectiveController.text;

  bool get _completed => pin.length == widget.length;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController();
    } else {
      widget.controller!.addListener(_handleTextEditingControllerChanges);
    }
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    _controller!.addListener(_handleTextEditingControllerChanges);
    if (!restorePending) {
      _registerController();
    }
  }

  void _handleTextEditingControllerChanges() => _onChanged(pin);

  void _onChanged(String pin) {
    widget.onChanged?.call(pin);
    if (_completed) {
      if (widget.onCompleted != null) {
        widget.onCompleted!
            .call(pin)
            .then((value) => _effectiveController.text = '');
      } else {
        _effectiveController.text = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PinIndicator(
          passcodeController: _effectiveController,
          length: widget.length,
          size: widget.indicatorSize,
          backgroundColor: widget.indicatorBackground,
          progressColor: widget.indicatorProgressColor,
          separator: widget.indicatorSeparator,
          border: widget.indicatorBorder,
        ),
        widget.keyboardIndicatorSeparator,
        Expanded(
          child: _PinKeyboard(
            passcodeController: _effectiveController,
            horizontalSeparator: widget.horizontalSeparator,
            verticalSeparator: widget.verticalSeparator,
            textStyle: widget.textStyle,
            buttonBackground: widget.buttonBackground,
            buttonShape: widget.buttonShape,
          ),
        ),
      ],
    );
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }
}

class _PinKeyboard extends StatelessWidget {
  const _PinKeyboard({
    Key? key,
    required this.passcodeController,
    required this.horizontalSeparator,
    required this.verticalSeparator,
    required this.textStyle,
    required this.buttonBackground,
    required this.buttonShape,
  }) : super(key: key);

  final TextEditingController passcodeController;
  final Widget horizontalSeparator;
  final Widget verticalSeparator;
  final TextStyle textStyle;
  final Color buttonBackground;
  final OutlinedBorder buttonShape;

  @override
  Widget build(BuildContext context) {
    /// Show buttons.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              _KeyboardButton(
                value: '1',
                onPressed: () => passcodeController.text += '1',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              _KeyboardButton(
                value: '2',
                onPressed: () => passcodeController.text += '2',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              _KeyboardButton(
                value: '3',
                onPressed: () => passcodeController.text += '3',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
            ],
          ),
        ),
        verticalSeparator,
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              _KeyboardButton(
                value: '4',
                onPressed: () => passcodeController.text += '4',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              _KeyboardButton(
                value: '5',
                onPressed: () => passcodeController.text += '5',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              _KeyboardButton(
                value: '6',
                onPressed: () => passcodeController.text += '6',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
            ],
          ),
        ),
        verticalSeparator,
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              _KeyboardButton(
                value: '7',
                onPressed: () => passcodeController.text += '7',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              _KeyboardButton(
                value: '8',
                onPressed: () => passcodeController.text += '8',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              _KeyboardButton(
                value: '9',
                onPressed: () => passcodeController.text += '9',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
            ],
          ),
        ),
        verticalSeparator,
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              const Spacer(),
              // _BiometricAuthorizationIcon(
              //   method: biometricAuthMethod,
              //   onBiometricAuth: onBiometricAuth,
              // ),
              horizontalSeparator,
              _KeyboardButton(
                value: '0',
                onPressed: () => passcodeController.text += '0',
                background: buttonBackground,
                shape: buttonShape,
                style: textStyle,
              ),
              horizontalSeparator,
              // TODO Implement delete button
              // _DeleteButton(passcodeController: passcodeController),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton({
    Key? key,
    required this.value,
    required this.style,
    required this.background,
    required this.shape,
    required this.onPressed,
  }) : super(key: key);

  final String value;
  final TextStyle style;
  final Color background;
  final OutlinedBorder shape;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(shape),
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor:
                MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
            backgroundColor: MaterialStateProperty.all(background),
          ),
          onPressed: onPressed,
          child: Text(
            value,
            style: style,
          ),
        ),
      ),
    );
  }
}
