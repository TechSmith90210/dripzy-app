import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/blocs/auth/auth_bloc.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:dripzy/widgets/custom_button_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/customIconTextField.dart';

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
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
