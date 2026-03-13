import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ProfileCardShimmer extends StatelessWidget {
  final bool isDark;
  const ProfileCardShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? const Color(0xff0F3253) : const Color(0xffEAEDF1),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          highlightColor: isDark ? Colors.grey.shade500 : Colors.grey.shade100,
          child: Row(
            children: [
              // Avatar shimmer
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
              ),

              const SizedBox(width: 12),

              // Name + subtitle shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18,
                      width: 140,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 14,
                      width: 100,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Button shimmer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BorderRadius.circular(8) != null
                    ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                )
                    : null,
                child: const SizedBox(
                  width: 70,
                  height: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}