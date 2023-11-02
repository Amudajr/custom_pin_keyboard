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
    this.showIndicator = true,
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
    this.backspaceButton = CustomPinKeyboardConstants._defaultBackspace,
    this.additionalButton,
    this.onAdditionalButtonPressed,
    this.pinContainerBorder,
    this.pinContainerBorderRadius,
    this.pinContainerColor,
    this.pinContainerPadding,
    this.isSepratingWidget,
    required this.otherSeperatingWidget,
  }) : super(key: key);

  final Color? pinContainerColor;
  final BorderRadiusGeometry? pinContainerBorderRadius;
  final EdgeInsetsGeometry? pinContainerPadding;
  final BoxBorder? pinContainerBorder;

  /// Fires when user completes pin input.
  final PinEnteredCallback? onCompleted;
  final bool? isSepratingWidget;
  final Widget otherSeperatingWidget;

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

  /// Show indicator with keyboard.
  ///
  /// You can separately use [PinIndicator].
  final bool showIndicator;

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

  /// Backspace widget.
  final Widget backspaceButton;

  /// Button in bottom left corner.
  final Widget? additionalButton;

  /// Callback of button in bottom left corner.
  final VoidCallback? onAdditionalButtonPressed;

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
    final pinKeyboard = _PinKeyboard(
      passcodeController: _effectiveController,
      horizontalSeparator: widget.horizontalSeparator,
      verticalSeparator: widget.verticalSeparator,
      textStyle: widget.textStyle,
      buttonBackground: widget.buttonBackground,
      buttonShape: widget.buttonShape,
      backspace: widget.backspaceButton,
      additionalButton: widget.additionalButton,
      onAdditionalButtonPressed: widget.onAdditionalButtonPressed,
    );
    return widget.showIndicator
        ? Column(
            children: [
              PinIndicator(
                passcodeController: _effectiveController,
                length: widget.length,
                size: widget.indicatorSize,
                backgroundColor: widget.indicatorBackground,
                progressColor: widget.indicatorProgressColor,
                separator: widget.indicatorSeparator,
                border: widget.indicatorBorder,
                pinContainerBorder: widget.pinContainerBorder,
                pinContainerBorderRadius: widget.pinContainerBorderRadius,
                pinContainerColor: widget.pinContainerColor,
                pinContainerPadding: widget.pinContainerPadding,
              ),
              widget.keyboardIndicatorSeparator,
              widget.isSepratingWidget ?? false
                  ? widget.otherSeperatingWidget
                  : const SizedBox(),
              Expanded(
                child: pinKeyboard,
              ),
            ],
          )
        : pinKeyboard;
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
    required this.backspace,
    this.additionalButton,
    this.onAdditionalButtonPressed,
  }) : super(key: key);

  final TextEditingController passcodeController;
  final Widget horizontalSeparator;
  final Widget verticalSeparator;
  final TextStyle textStyle;
  final Color buttonBackground;
  final OutlinedBorder buttonShape;
  final Widget backspace;
  final Widget? additionalButton;
  final VoidCallback? onAdditionalButtonPressed;

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
                onPressed: () => passcodeController.text += '1',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('1', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '2',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('2', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '3',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('3', style: textStyle),
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
                onPressed: () => passcodeController.text += '4',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('4', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '5',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('5', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '6',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('6', style: textStyle),
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
                onPressed: () => passcodeController.text += '7',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('7', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '8',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('8', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '9',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('9', style: textStyle),
              ),
            ],
          ),
        ),
        verticalSeparator,
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              if (additionalButton != null)
                _KeyboardButton(
                  onPressed: onAdditionalButtonPressed,
                  background: buttonBackground,
                  shape: buttonShape,
                  child: additionalButton!,
                ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () => passcodeController.text += '0',
                background: buttonBackground,
                shape: buttonShape,
                child: Text('0', style: textStyle),
              ),
              horizontalSeparator,
              _KeyboardButton(
                onPressed: () {
                  if (passcodeController.text.isNotEmpty) {
                    passcodeController.text = passcodeController.text
                        .substring(0, passcodeController.text.length - 1);
                  }
                },
                background: buttonBackground,
                shape: buttonShape,
                child: const Icon(Icons.backspace_outlined, color: Colors.red),
              ),
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
    required this.child,
    required this.background,
    required this.shape,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
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
          child: child,
        ),
      ),
    );
  }
}
