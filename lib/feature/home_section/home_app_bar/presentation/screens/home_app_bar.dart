import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';

import '../../../split_calculator/prensentation/screen/split_calculator.dart';
import '../riverpod/home_controller.dart';

class HomeNavBarScreen extends ConsumerWidget {
  const HomeNavBarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentIndex = ref.watch(bottomNavProvider);

    final pages = [
      const StopwatchPage(),
      const StopwatchPage(),
      const StopwatchPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          ref.read(bottomNavProvider.notifier).state = index;
        },

        items: [

          BottomNavigationBarItem(
            icon: SvgPicture.asset(currentIndex ==  0? IconPath.calculatorActiveIcon:IconPath.calculatorInActiveIcon),
            label: "Calculator",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: "Stopwatch",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: "Converter",
          ),
        ],
      ),
    );
  }
}