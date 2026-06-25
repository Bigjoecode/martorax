import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const StepIndicator({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(total, (i) {
          final isActive = i <= current;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.emerald600 : AppColors.slate700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
