import 'package:drip_talk/core/common/constants/app_sizes.dart';
import 'package:drip_talk/core/common/widgets/app_gap.dart';
import 'package:flutter/material.dart';

import 'app_text.dart';

class ErrorRetryWidget extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({super.key, this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: AppSizes.s48, color: Colors.grey),
            const AppGap(AppSizes.s12),
            AppText(
              text: message ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const AppGap(AppSizes.s16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
