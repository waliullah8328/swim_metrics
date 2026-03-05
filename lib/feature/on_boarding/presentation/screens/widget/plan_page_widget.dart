import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/on_boarding_view_model.dart';

class PlanPage extends ConsumerWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Premium - \$4.99",
            style: TextStyle(color: Colors.amber, fontSize: 20)),

        const SizedBox(height: 20),

        CheckboxListTile(
          value: state.isPremiumSelected,
          onChanged: (value) =>
              notifier.selectPlan(value ?? true),
          title: const Text("Unlimited Usage",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}