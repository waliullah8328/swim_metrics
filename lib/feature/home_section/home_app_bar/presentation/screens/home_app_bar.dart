import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/home_section/home_app_bar/presentation/screens/widgets/custom_active_container_image_widget.dart';

import '../../../calculator_section/calculator/presentation/screen/calculator_page.dart';

import '../../../converter_section/presentation/screen/converter_screen.dart';
import '../../../stop_watch_section/stop_watch/presentation/screen/stop_watch_screen.dart';
import '../riverpod/home_controller.dart';

class HomeNavBarScreen extends ConsumerWidget {
  const HomeNavBarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final pages = [
      SplitCalculatorPage(),
      StopwatchScreen(),
      ConverterScreen(),
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
            icon: currentIndex == 0
                ? CustomActiveContainerImage(imagePath: IconPath.calculatorActiveIcon,)
                : SvgPicture.asset(IconPath.calculatorInActiveIcon),
            label: "Calculator",
          ),

          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? CustomActiveContainerImage(imagePath: IconPath.stopSwitchActiveIcon,)
                : SvgPicture.asset(IconPath.stopSwitchInActiveIcon),
            label: "Stopwatch",
          ),

          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? CustomActiveContainerImage(imagePath: IconPath.converterActiveIcon,)
                : SvgPicture.asset(IconPath.converterInActiveIcon),
            label: "Converter",
          ),
        ],
      ),
    );
  }
}


