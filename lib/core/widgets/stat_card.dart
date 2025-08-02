import 'package:flutter/material.dart';

import 'custom_gap.dart';

class StatCard extends StatelessWidget {
  final String title;
  final Future<int> futureValue;

  const StatCard({super.key, required this.title, required this.futureValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
              const Gap(12),
              FutureBuilder<int>(
                future: futureValue,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.connectionState == ConnectionState.waiting
                        ? 'Loading...'
                        : snapshot.data?.toString() ?? 'N/A',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
