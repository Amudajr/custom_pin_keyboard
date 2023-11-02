// ignore_for_file: unused_element

part of 'custom_pin_keyboard.dart';

class PinIndicator extends StatelessWidget {
  const PinIndicator({
    Key? key,
    required this.passcodeController,
    this.length = CustomPinKeyboardConstants._defaultLength,
    this.size = CustomPinKeyboardConstants._defaultIndicatorSize,
    this.backgroundColor =
        CustomPinKeyboardConstants._defaultIndicatorBackground,
    this.progressColor =
        CustomPinKeyboardConstants._defaultIndicatorProgressColor,
    this.separator = CustomPinKeyboardConstants._defaultIndicatorSeparator,
    this.border,
    this.pinContainerBorderRadius,
    this.pinContainerColor,
    this.pinContainerPadding,
    this.pinContainerBorder,
    this.pinContainerWidth,
  }) : super(key: key);

  final TextEditingController passcodeController;
  final int length;
  final double size;
  final Color backgroundColor;
  final Color progressColor;
  final Widget separator;
  final Border? border;
  final Color? pinContainerColor;
  final BorderRadiusGeometry? pinContainerBorderRadius;
  final EdgeInsetsGeometry? pinContainerPadding;
  final BoxBorder? pinContainerBorder;
  final double? pinContainerWidth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: passcodeController,
      builder: (BuildContext context, TextEditingValue value, Widget? child) {
        return Container(
          width: pinContainerWidth,
          padding: pinContainerPadding,
          decoration: BoxDecoration(
            color: pinContainerColor,
            borderRadius: pinContainerBorderRadius,
            border: pinContainerBorder,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _generateSeparatedList(
              length,
              itemBuilder: (index) => _CircleBox(
                size: size,
                color:
                    value.text.length > index ? progressColor : backgroundColor,
                border: border,
              ),
              separatorBuilder: (_) => separator,
            ),
          ),
        );
      },
      child: separator,
    );
  }
}

class _CircleBox extends StatelessWidget {
  const _CircleBox({
    Key? key,
    required this.size,
    required this.color,
    this.border,
  }) : super(key: key);

  final double size;
  final Color color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border,
        ),
      ),
    );
  }
}

typedef ListItemBuilder<T> = T Function(int index);

List<E> _generateSeparatedList<E>(
  int itemCount, {
  required ListItemBuilder<E> itemBuilder,
  required ListItemBuilder<E> separatorBuilder,
}) {
  if (itemCount == 0) return <E>[];
  return List.generate(itemCount * 2 - 1, (index) {
    final itemIndex = index ~/ 2;
    return index % 2 == 1
        ? separatorBuilder(itemIndex)
        : itemBuilder(itemIndex);
  });
}
