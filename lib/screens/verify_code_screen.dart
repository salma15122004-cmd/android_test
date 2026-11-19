import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/service_locator.dart';
import '../utils/guarded_action.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/code_input_boxes.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/screen_text.dart';
import 'create_new_password_screen.dart';

/// Second step of the password reset flow: the user types the code that was
/// sent to [email] using the on-screen keypad.
class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with GuardedActionMixin {
  static const int _codeLength = 4;
  static const int _resendCooldownSeconds = 30;

  String _code = '';
  int _secondsUntilResend = 0;
  Timer? _cooldownTimer;

  bool get _canResend => _secondsUntilResend == 0 && !isBusy;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startResendCooldown() {
    _cooldownTimer?.cancel();
    _secondsUntilResend = _resendCooldownSeconds;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsUntilResend--);
      if (_secondsUntilResend <= 0) timer.cancel();
    });
  }

  void _onDigitPressed(String digit) {
    if (isBusy || _code.length >= _codeLength) return;
    setState(() => _code += digit);
  }

  void _onDeletePressed() {
    if (isBusy || _code.isEmpty) return;
    setState(() => _code = _code.substring(0, _code.length - 1));
  }

  Future<void> _verify() async {
    if (_code.length < _codeLength) {
      showAppSnackBar(context, 'Enter the $_codeLength-digit code.');
      return;
    }
    final code = _code;

    final verified = await runGuarded(
      () => authService.verifyResetCode(email: widget.email, code: code),
    );
    if (!mounted) return;
    if (!verified) {
      setState(() => _code = '');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateNewPasswordScreen(email: widget.email, code: code),
      ),
    );
  }

  Future<void> _resendCode() async {
    final sent = await runGuarded(
      () => authService.requestPasswordReset(email: widget.email),
    );
    if (!sent || !mounted) return;

    setState(() {
      _code = '';
      _startResendCooldown();
    });
    showAppSnackBar(context, 'A new code was sent to ${widget.email}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [_buildHeader(), const Spacer(), _buildKeypadPanel()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextLinkButton(
              label: 'Back',
              fontSize: 24,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Image.asset(AppAssets.verifyCodeFamily, height: 150),
          const SizedBox(height: 12),
          Text(
            'Please enter the $_codeLength-digit code\n'
            'sent to your email address.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.3,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 28),
          CodeInputBoxes(code: _code, length: _codeLength),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildKeypadPanel() {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 24, 24, 16 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.keypadPanel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          NumericKeypad(
            onDigitPressed: _onDigitPressed,
            onDeletePressed: _onDeletePressed,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Verify Code',
            color: AppColors.deepBlue,
            isLoading: isBusy,
            onPressed: _verify,
          ),
          const SizedBox(height: 4),
          TextLinkButton(
            label: _secondsUntilResend == 0
                ? 'Resend Code'
                : 'Resend code in ${_secondsUntilResend}s',
            color: _canResend ? AppColors.navy : Colors.black45,
            fontSize: 15,
            onPressed: _canResend ? _resendCode : null,
          ),
        ],
      ),
    );
  }
}
