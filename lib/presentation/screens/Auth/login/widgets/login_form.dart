import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_gap.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passcodeController;
  final FocusNode emailFocusNode;
  final VoidCallback onSubmit;
  final bool isLoading;
  final bool showFingerprint;
  final VoidCallback onFingerprintLogin;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passcodeController,
    required this.emailFocusNode,
    required this.onSubmit,
    required this.isLoading,
    required this.showFingerprint,
    required this.onFingerprintLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            style: const TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Inter',
                fontSize: 12.0,
                decoration: TextDecoration.none,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 3,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 3,
                  color: Color(0xFFF76800),
                ),
              ),
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ),
            cursorColor: const Color(0xFFF76800),
          ),
        ),
        Gap(MediaQuery.of(context).size.height * 0.05, useMediaQuery: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            controller: passcodeController,
            style: const TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              labelText: 'Passcode',
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Inter',
                fontSize: 12.0,
                decoration: TextDecoration.none,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 3,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 3,
                  color: Color(0xFFF76800),
                ),
              ),
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                onPressed: () {},
              ),
            ),
            cursorColor: const Color(0xFFF76800),
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
        ),
        Gap(MediaQuery.of(context).size.height * 0.05, useMediaQuery: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: showFingerprint ? 7 : 1,
                child: SizedBox(
                  height: (60 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height,
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white;
                          }
                          return const Color(0xFF02AA03);
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color(0xFF02AA03);
                          }
                          return Colors.white;
                        },
                      ),
                      elevation: WidgetStateProperty.all<double>(4.0),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          side: BorderSide(
                            width: 3,
                            color: Color(0xFF02AA03),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              showFingerprint
                  ? const Gap(10, isHorizontal: true)
                  : const SizedBox(),
              showFingerprint
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF02AA03),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: IconButton(
                        iconSize: 45,
                        icon:
                            const Icon(Icons.fingerprint, color: Colors.white),
                        onPressed: onFingerprintLogin,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
