# Custom pin keyboard

[![pub package](https://img.shields.io/pub/v/custom_pin_keyboard.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/custom_pin_keyboard)
[![Last Commits](https://img.shields.io/github/last-commit/arrrtem22/custom_pin_keyboard?logo=git&logoColor=white)](https://github.com/arrrtem22/custom_pin_keyboard/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/arrrtem22/custom_pin_keyboard?logo=github&logoColor=white)](https://github.com/arrrtem22/custom_pin_keyboard/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/arrrtem22/custom_pin_keyboard?logo=github&logoColor=white)](https://github.com/arrrtem22/custom_pin_keyboard)
[![License](https://img.shields.io/github/license/arrrtem22/custom_pin_keyboard?logo=open-source-initiative&logoColor=green)](https://github.com/arrrtem22/custom_pin_keyboard/blob/master/LICENSE)

<p align="center">
  <img src="https://github.com/arrrtem22/custom_pin_keyboard/blob/master/screnshoot/showcase.gif?raw=true" height="600px">
</p>

The best flutter package that gives you a custom keyboard for one time password widgets, transaction pin widgets and simple login widgets.<br>
All shortcomings of other packages were taken into account!!

**Show some ❤️ and star the repo to support the project**

### Resources:
- [Pub Package](https://pub.dev/packages/custom_pin_keyboard)
- [GitHub Repository](https://github.com/arrrtem22/custom_pin_keyboard)

## Getting Started

### Simple pin keyboard with indicator

```dart
CustomPinKeyboard(
  onCompleted: (pin) async {
    // some action
  },
  indicatorBackground: Colors.black12,
  buttonBackground: Colors.transparent,
  textStyle: const TextStyle(
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    fontSize: 24,
    color: Colors.blue,
  ),
  additionalButton: const Icon(Icons.ac_unit, color: Colors.blue),
  onAdditionalButtonPressed: () {
    // some additional action
  },
)
```

Feel free to open pull requests.

# Acknowledgments

This package was originally created by [Artemii Oliinyk](https://github.com/arrrtem22).