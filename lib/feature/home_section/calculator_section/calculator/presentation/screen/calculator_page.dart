import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/constants/icon_path.dart';
import 'package:swim_metrics/feature/home_section/calculator_section/calculator/presentation/screen/splict_custom_widget.dart';

import '../../../../../on_boarding/presentation/screens/widget/wheel_selector_widget.dart';
import '../../riverpod/calculator_split_state.dart';

class SplitCalculatorPage extends ConsumerWidget {
  SplitCalculatorPage({super.key});

  final TextEditingController timeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splitProvider);
    final notifier = ref.read(splitProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text("Menu")),
            ListTile(title: Text("Calculator")),
            ListTile(title: Text("Stopwatch")),
            ListTile(title: Text("Converter")),
          ],
        ),
      ),
      appBar: AppBar(
        title: CustomText(text: "Split Calculator",fontSize: 24.sp,fontWeight: FontWeight.w600,),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.lightModeDrawerIcon,
              height: 48.h,
              width: 48.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// COURSE CARD
            Card(
              color: AppColors.textWhite,

              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [

                    /// GENDER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: SplitCalculatorSelector(
                            items: const ["Men", "Women"],
                            onChanged: (value) {
                              ref.read(splitProvider.notifier).setGender(value);
                            },
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: SplitCalculatorSelector(
                            items: const ["Fly", "Back"],
                            onChanged: (value) {
                              ref.read(splitProvider.notifier).setStroke(value);
                            },
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Expanded(
                        //   child: LanguageWheelSelector(
                        //     items: [50, 100],
                        //     onChanged: (value) {
                        //       ref.read(splitProvider.notifier).setDistance(value!);
                        //     },
                        //   ),
                        // ),
                      ],
                    ),





                    const SizedBox(height: 20),

                    /// GOAL TIME
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "ENTER TIME HERE",
                        filled: true,
                        fillColor: const Color(0xff0D446F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// CALCULATE BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD1A548),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        notifier.setGoalTime(
                          double.parse(timeController.text),
                        );

                        notifier.calculateSplits();
                      },
                      child: const Text("Calculate Split"),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// RESULT TABLE
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff0B3A60),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: state.splits.isEmpty
                    ? const Center(
                  child: Text(
                    "No splits yet",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ListView.builder(
                  itemCount: state.splits.length,
                  itemBuilder: (context, index) {
                    final split = state.splits[index];

                    return ListTile(
                      title: Text(
                        "${split.distance}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        split.splitTime.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        split.total.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      notifier.clear();
                    },
                    child: const Text("Clear"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {},
                    child: const Text("Export"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget genderButton(WidgetRef ref,String value) {
  final state = ref.watch(splitProvider);
  final notifier = ref.read(splitProvider.notifier);

  return GestureDetector(
    onTap: () => notifier.setGender(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: state.gender == value
            ? const Color(0xff1B6AA5)
            : const Color(0xff0D446F),
      ),
      child: Text(value,style: const TextStyle(color: Colors.white)),
    ),
  );
}
Widget strokeButton(WidgetRef ref,String value) {
  final state = ref.watch(splitProvider);
  final notifier = ref.read(splitProvider.notifier);

  return GestureDetector(
    onTap: () => notifier.setGender(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: state.gender == value
            ? const Color(0xff1B6AA5)
            : const Color(0xff0D446F),
      ),
      child: Text(value,style: const TextStyle(color: Colors.white)),
    ),
  );
}
Widget distButton(WidgetRef ref,String value) {
  final state = ref.watch(splitProvider);
  final notifier = ref.read(splitProvider.notifier);

  return GestureDetector(
    onTap: () => notifier.setGender(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: state.gender == value
            ? const Color(0xff1B6AA5)
            : const Color(0xff0D446F),
      ),
      child: Text(value,style: const TextStyle(color: Colors.white)),
    ),
  );
}