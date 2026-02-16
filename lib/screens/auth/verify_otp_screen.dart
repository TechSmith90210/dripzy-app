import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:pinput/pinput.dart';

import '../../widgets/custom_button_1.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({
    super.key,
    required this.onBack,
    required this.phoneNumber,
  });
  final VoidCallback onBack;
  final String phoneNumber;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  /// Create Controller for otp
  final pinController = TextEditingController();

  /// Create FocusNode
  final pinputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    /// Focus pinput
    pinputFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      margin: EdgeInsets.symmetric(horizontal: 14),
      textStyle: TextStyle(
        fontSize: 20,
        color: color.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(15),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: widget.onBack,
          child: Icon(IconsaxPlusBroken.arrow_left_1, color: color.primary),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/verify_otp_img.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                spacing: 7,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Enter OTP",
                    style: TextStyle(
                      color: color.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 27,
                    ),
                  ),
                  Text(
                    "Check your SMS! We’ve sent a one-time code to ${widget.phoneNumber}",
                    style: TextStyle(
                      color: color.primary,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 18),

                  //OTP FILLING WIDGET
                  _buildOTPWidget(defaultPinTheme),

                  SizedBox(height: 20),

                  CustomButton1(
                    bgColor: color.primary,
                    text: "Verify OTP",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOTPWidget(PinTheme theme) {
    return Pinput(
      defaultPinTheme: theme,
      focusNode: pinputFocusNode,
      controller: pinController,
      onCompleted: (pin) => print("your pin is $pin"),
      closeKeyboardWhenCompleted: true,
    );
  }
}
