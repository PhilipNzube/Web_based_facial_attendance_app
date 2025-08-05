import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_gap.dart';
import '../../../controllers/auth_controller.dart';
import '../../../../core/widgets/custom_background.dart';
import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.76,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Gap(MediaQuery.of(context).size.height * 0.05,
                          useMediaQuery: false),
                      // Image.asset(
                      //   "images/portal-landing-logo.png",
                      //   fit: BoxFit.contain,
                      //   width: 120,
                      // ),
                      // Gap(MediaQuery.of(context).size.height * 0.03,
                      //     useMediaQuery: false),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(MediaQuery.of(context).size.height * 0.04,
                          useMediaQuery: false),
                      LoginForm(
                        emailController: authController.emailController,
                        passcodeController: authController.passcodeController,
                        emailFocusNode: authController.emailFocusNode,
                        isLoading: authController.isLoading,
                        showFingerprint: false,
                        //showFingerprint: authController.showFingerprint,
                        onSubmit: () => authController.login(
                          authController.emailController.text.trim(),
                          authController.passcodeController.text.trim(),
                          context,
                        ),
                        onFingerprintLogin: () =>
                            authController.biometricLogin(context),
                      ),
                      Gap(MediaQuery.of(context).size.height * 0.03,
                          useMediaQuery: false),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
