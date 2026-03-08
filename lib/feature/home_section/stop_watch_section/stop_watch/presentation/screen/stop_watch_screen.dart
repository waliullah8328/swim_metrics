import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../riverpod/stop_watch_controller.dart';
import '../widget/controll_button_widget.dart';
import '../widget/lap_table_widget.dart';
import '../widget/time_display_widget.dart';

class StopwatchScreen extends ConsumerStatefulWidget {
  const StopwatchScreen({super.key});

  @override
  ConsumerState<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends ConsumerState<StopwatchScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  final List<String> items = ["Normal", "Converter", "Predictor"];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stopwatchProvider);
    final controller = ref.read(stopwatchProvider.notifier);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: CustomText(
          text: "Stop Watch",
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
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

        /// Divider below AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
        ),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Top Buttons
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: Offset(0,4),
                        color: Colors.black12
                    )
                  ]
              ),
              child: Row(
                children: List.generate(items.length * 2 - 1, (index) {

                  if(index.isOdd){
                    return const SizedBox(width:6);
                  }

                  final itemIndex = index ~/ 2;
                  final isActive = selectedIndex == itemIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedIndex = itemIndex;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFC9A84C)
                              : const Color(0xFFEAEDF1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          items[itemIndex],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.black
                                : const Color(0xFF82888E),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),


            SizedBox(height: 20.h),

            /// Main Content
            selectedIndex == 0
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        TimerDisplay(duration: state.time),

                        const SizedBox(height: 20),

                        ControlButtons(
                          running: state.isRunning,
                          onStart: controller.start,
                          onPause: controller.pause,
                          onReset: controller.reset,
                          onLap: controller.lap,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : const Center(child: Text("Nothing")),
            Expanded(child: LapTable(laps: state.laps)),
          ],
        ),
      ),
    );
  }
}
