import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A row of [length] boxes that display the digits of [code] from left to
/// right. Boxes without a digit yet stay empty.
class CodeInputBoxes extends StatelessWidget {
  const CodeInputBoxes({super.key, required this.code, required this.length});

  final String code;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < length; i++)
          _CodeBox(digit: i < code.length ? code[i] : ''),
      ],
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.digit});

  final String digit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.codeBox,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black26),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
