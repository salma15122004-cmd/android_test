import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// On-screen keypad with the digits 0-9 and a delete key.
///
/// Digit keys have the key `Key('keypad_<digit>')` and the delete key has
/// `Key('keypad_delete')`.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
  });

  final ValueChanged<String> onDigitPressed;
  final VoidCallback onDeletePressed;

  static const List<List<String>> _digitRows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in _digitRows)
          _KeypadRow(
            children: [for (final digit in row) _buildDigitButton(digit)],
          ),
        _KeypadRow(
          children: [
            const SizedBox(width: _KeypadButton.width),
            _buildDigitButton('0'),
            _KeypadButton(
              key: const Key('keypad_delete'),
              onPressed: onDeletePressed,
              child: const Icon(
                Icons.close,
                size: 26,
                color: AppColors.deepBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDigitButton(String digit) {
    return _KeypadButton(
      key: Key('keypad_$digit'),
      onPressed: () => onDigitPressed(digit),
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.softBlue,
        ),
      ),
    );
  }
}

class _KeypadRow extends StatelessWidget {
  const _KeypadRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  static const double width = 64;
  static const double height = 44;

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black38,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(child: child),
        ),
      ),
    );
  }
}
