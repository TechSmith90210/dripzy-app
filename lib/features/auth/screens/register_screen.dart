import 'package:dripzy/core/routes/routes.dart';
import 'package:dripzy/features/auth/bloc/auth_state.dart';
import 'package:dripzy/widgets/customIconTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/custom_alert.dart';
import '../../../widgets/custom_button_1.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;

  void onRegisterTap(BuildContext context) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final errors = <String>[];

    if (name.isEmpty) errors.add("Name");
    if (email.isEmpty) errors.add("Email");
    if (password.isEmpty) errors.add("Password");

    if (errors.isNotEmpty) {
      CustomAlert.show(
        context,
        message: "${errors.join(', ')} cannot be empty",
        type: ToastificationType.error,
      );
      return;
    }

    if (password.length < 6) {
      CustomAlert.show(
        context,
        message: "Password must be at least 6 characters",
        type: ToastificationType.error,
      );
      return;
    }
    if (password != confirmPassword) {
      CustomAlert.show(
        context,
        message: "Passwords do not match",
        type: ToastificationType.error,
      );
      return;
    }

    print("Name : $name");
    print("Email : $email");
    print("Password : $password");

    context.read<AuthBloc>().add(
      RegisterRequested(name: name, email: email, password: password),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final height = MediaQuery.of(context).size.height;
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
            height: height / 1,
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
              height: height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(
                        "Register",
                        style: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 27,
                        ),
                      ),
                      //subtitle
                      Text(
                        "Create Your Account",
                        style: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  //text fields
                  //name text field
                  CustomIconTextField(
                    color: color,
                    controller: nameController,
                    icon: IconsaxPlusLinear.profile,
                    hintText: "Enter your name",
                  ),

                  // email text field
                  CustomIconTextField(
                    color: color,
                    controller: emailController,
                    icon: Icons.email_outlined,
                    hintText: "Enter your email",
                    isEmail: true,
                  ),

                  // password field
                  CustomIconTextField(
                    color: color,
                    controller: passwordController,
                    icon: Icons.password_outlined,
                    hintText: "Enter your password",
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onToggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    showSuffixIcon: true,
                  ),

                  //confirm password field
                  CustomIconTextField(
                    color: color,
                    controller: confirmPasswordController,
                    icon: Icons.lock_outline,
                    hintText: "Confirm Password",
                    isPassword: true,
                    obscureText: true,
                  ),

                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFailure) {
                        CustomAlert.show(
                          context,
                          message: state.message,
                          type: ToastificationType.error,
                        );
                      } else if (state is AuthSuccess) {
                        CustomAlert.show(
                          context,
                          message: state.message,
                          type: ToastificationType.success,
                        );
                        //navigate to home screen
                        context.goNamed(AppRoutes.homeName);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return CustomButton1(
                        bgColor: color.primary,
                        text: isLoading ? "Registering..." : "Register",
                        onTap: () => isLoading ? null : onRegisterTap(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
