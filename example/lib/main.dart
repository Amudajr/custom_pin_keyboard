import 'package:custom_pin_keyboard/custom_pin_keyboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLocked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 130),
        child: Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: isLocked
                      ? const Icon(
                          Icons.lock_outline,
                          key: ValueKey('icon1'),
                          color: Colors.white,
                          size: 36,
                        )
                      : const Icon(
                          Icons.lock_open_outlined,
                          key: ValueKey('icon2'),
                          color: Colors.white,
                          size: 36,
                        ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 6,
              child: CustomPinKeyboard(
                onCompleted: (pin) async {
                  isLocked = !isLocked;
                  setState(() {});
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Additional button pressed"),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
