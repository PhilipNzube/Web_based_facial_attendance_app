import 'package:flutter/material.dart';

class LoginFingerprint extends StatelessWidget {
  final bool showFingerprint;
  final VoidCallback onAuthenticate;

  const LoginFingerprint({
    super.key,
    required this.showFingerprint,
    required this.onAuthenticate,
  });

  @override
  Widget build(BuildContext context) {
    return showFingerprint
        ? Container(
            decoration: const BoxDecoration(
              color: Color(0xFF02AA03),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: IconButton(
              iconSize: 45,
              icon: const Icon(Icons.fingerprint, color: Colors.white),
              onPressed: onAuthenticate,
            ),
          )
        : const SizedBox();
  }
}
