import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/blocs/auth/auth_bloc.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:dripzy/widgets/custom_button_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/custom_icon_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          CustomAlert.show(context, message: state.message);
          context.goNamed(AppRoutes.homeName);
        } else if (state is AuthFailure) {
          CustomAlert.show(context, message: state.message);
        }
      },
      child: Scaffold(
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
                  image: AssetImage('assets/login_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        Text(
                          "Welcome to Dripzy",
                          style: TextStyle(
                            color: color.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 27,
                          ),
                        ),
                        //subtitle
                        Text(
                          "Find your perfect outfit today.",
                          style: TextStyle(
                            color: color.primary,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
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

                    const SizedBox(height: 4),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return CustomButton1(
                          bgColor: color.primary,
                          text: isLoading ? "Logging in..." : "Login",
                          onTap: isLoading ? () {} : () => onLoginTap(),
                        );
                      },
                    ),

                    Row(
                      children: [
                        Expanded(child: Divider(color: color.primary.withValues(alpha: 0.1))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: color.primary.withValues(alpha: 0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: color.primary.withValues(alpha: 0.1))),
                      ],
                    ),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () => context
                                  .read<AuthBloc>()
                                  .add(GoogleSignInRequested()),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 52,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: color.primary.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color.primary.withValues(alpha: 0.05),
                                  ),
                                  child: Text(
                                    "G",
                                    style: TextStyle(
                                      color: color.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Continue with Google",
                                  style: TextStyle(
                                    color: color.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onLoginTap() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final errors = <String>[];

    if (email.isEmpty) errors.add("Email");
    if (password.isEmpty) errors.add("Password");

    if (errors.isNotEmpty) {
      CustomAlert.show(
        context,
        message: "${errors.join(', ')} cannot be empty",
      );
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(email: email, password: password),
    );
  }
}
