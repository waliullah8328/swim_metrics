import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/new_custon_widgets/split_calculator_selector_one.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';
import '../../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../../../calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../riverpod/stop_watch_controller_2.dart';

enum StopwatchStatus { initial, running, stopped }

class StopwatchController1 extends StateNotifier<StopwatchStatus> {
  StopwatchController1() : super(StopwatchStatus.initial);

  void start() {
    state = StopwatchStatus.running;
  }

  void stop() {
    state = StopwatchStatus.stopped;
  }

  void resume() {
    state = StopwatchStatus.running;
  }

  void clear() {
    state = StopwatchStatus.initial;
  }
}

final stopwatchProvider1 =
    StateNotifierProvider<StopwatchController1, StopwatchStatus>(
      (ref) => StopwatchController1(),
    );

final showCourseSectionStopWatchProvider = StateProvider<bool>((ref) => true);
final showCourseSectionStopWatchProvider2 = StateProvider<bool>((ref) => true);

class StopwatchScreen extends ConsumerStatefulWidget {
  const StopwatchScreen({super.key});

  @override
  ConsumerState<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends ConsumerState<StopwatchScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  double getAdjustedFontSize(double baseSize, FontSizeOption option) {
    switch (option) {
      case FontSizeOption.small:
        return baseSize - 2;
      case FontSizeOption.medium:
        return baseSize;
      case FontSizeOption.big:
        return baseSize + 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = ref.watch(stopwatchProvider1);
    final List<String> items = [
      AppLocalizations.of(context)!.normal,
      AppLocalizations.of(context)!.converterBig,
      AppLocalizations.of(context)!.predictor,
    ];
    final settings = ref.watch(settingsProvider);
    final currentLanguageCode = settings.language.code;
    final showCourse = ref.watch(showCourseSectionStopWatchProvider);
    final showCourse2 = ref.watch(showCourseSectionStopWatchProvider2);
    final log = ref.watch(stopwatchProvider2.select((s) => s.logStopwatch));
    final log2 = ref.watch(stopwatchProvider2.select((s) => s.logConverter));
    final log3 = ref.watch(stopwatchProvider2.select((s) => s.logPredictor));
    final fontOption = ref.watch(settingsProvider).fontSize;

    final modes = ["Stopwatch", "Converter", "Predictor"];
    final activeMode = ref.watch(
      stopwatchProvider2.select((s) => s.activeMode),
    );

    debugPrint("build");

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.stopWatch,
          fontSize: getAdjustedFontSize(24, fontOption).sp,
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
          child: Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Color(0xffDADADA) : Colors.grey.shade300,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Top Buttons
              CustomText(
                text: AppLocalizations.of(context)!.mode,
                fontSize: getAdjustedFontSize(18, fontOption).sp,
                fontWeight: FontWeight.w600,
                color: Color(0xffE3D99B),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xff153250) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(modes.length * 2 - 1, (index) {
                    if (index.isOdd) {
                      return  SizedBox(width: 6.w);
                    }

                    final itemIndex = index ~/ 2;
                    final mode = modes[itemIndex];
                    final isActive = activeMode == mode;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(stopwatchProvider2.notifier).setMode(mode);
                          ref.read(stopwatchProvider1.notifier).clear();
                          ref.read(stopwatchProvider2.notifier).stop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFC9A84C)
                                : const Color(0xFFEAEDF1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomText(text:
                            mode,

                              fontWeight: FontWeight.w600,
                              fontSize: getAdjustedFontSize(17, fontOption).sp,
                              color: isActive
                                  ? Colors.black
                                  : const Color(0xFF82888E),

                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 20.h),
              if (!showCourse && activeMode == 'Converter')
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ref
                              .read(showCourseSectionStopWatchProvider.notifier)
                              .state =
                          true;
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(IconPath.pullIcon),
                            CustomText(
                              text: AppLocalizations.of(
                                context,
                              )!.pullDownToSeeOptions,
                              fontSize: getAdjustedFontSize(14, fontOption).sp,
                              color: Color(0xffC7C7C7),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                  // child: IconButton(
                  //   icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                  //   onPressed: () {
                  //     ref.read(showCourseSectionProvider.notifier).state = true;
                  //   },
                  // ),
                ),

              if (!showCourse2 && activeMode == 'Predictor')
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ref
                              .read(
                                showCourseSectionStopWatchProvider2.notifier,
                              )
                              .state =
                          true;
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(IconPath.pullIcon),
                            CustomText(
                              text: AppLocalizations.of(
                                context,
                              )!.pullDownToSeeOptions,
                              fontSize: getAdjustedFontSize(14, fontOption).sp,
                              color: Color(0xffC7C7C7),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),

              /// Main Content
              activeMode == 'Stopwatch'
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Color(0xff0C3156)
                                : Color(0xffFFFFFF),
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
                              Consumer(
                                builder: (context, ref, child) {
                                  var time = ref.watch(
                                    stopwatchProvider2.select(
                                      (s) => s.elapsed(),
                                    ),
                                  );

                                  return Card(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: CustomText(
                                          text: _formatElapsed(time),
                                          fontSize: getAdjustedFontSize(35, fontOption).sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),

                              /// INITIAL STATE
                              if (status == StopwatchStatus.initial)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(double.infinity, 52.h),
                                    backgroundColor: isDark
                                        ? Color(0xffC69C3F)
                                        : null,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(stopwatchProvider2.notifier)
                                        .start();
                                    ref
                                        .read(stopwatchProvider1.notifier)
                                        .start();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.startIcon,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      CustomText(text:
                                        AppLocalizations.of(context)!.start,

                                          fontSize: getAdjustedFontSize(14, fontOption).sp,
                                          fontWeight: FontWeight.w600,

                                      ),
                                    ],
                                  ),
                                ),

                              /// RUNNING STATE
                              if (status == StopwatchStatus.running)
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(double.infinity, 52.h),
                                        backgroundColor: Color(0xff2DA8F0),
                                        side: BorderSide(
                                          color: Color(0xff2DA8F0),
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(stopwatchProvider1.notifier)
                                            .start();
                                        ref
                                            .read(stopwatchProvider2.notifier)
                                            .split();
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.splitIcon,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text: AppLocalizations.of(
                                                context,
                                              )!.split,
                                              fontSize: getAdjustedFontSize(16, fontOption).sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                double.infinity,
                                                52.h,
                                              ),
                                              backgroundColor: Color(
                                                0xff475569,
                                              ),
                                              side: BorderSide(
                                                color: Color(0xff475569),
                                              ),
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                    stopwatchProvider1.notifier,
                                                  )
                                                  .start();
                                              ref
                                                  .read(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .undoLastSplit();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  IconPath.undoIcon,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors.textWhite,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                CustomText(
                                                  text: AppLocalizations.of(
                                                    context,
                                                  )!.undoSplit,
                                                  color: AppColors.textWhite,
                                                  fontSize: getAdjustedFontSize(12, fontOption).sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),

                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                double.infinity,
                                                52.h,
                                              ),
                                              backgroundColor: Color(
                                                0xffFE484C,
                                              ),
                                              side: BorderSide(
                                                color: Color(0xffFE484C),
                                              ),
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(
                                                    stopwatchProvider1.notifier,
                                                  )
                                                  .stop();
                                              ref
                                                  .read(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .pause();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  IconPath.stopIcon,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors.textWhite,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                CustomText(
                                                  text: AppLocalizations.of(
                                                    context,
                                                  )!.stop,
                                                  color: AppColors.textWhite,
                                                  fontSize: getAdjustedFontSize(12, fontOption).sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                              /// STOPPED STATE
                              if (status == StopwatchStatus.stopped)
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                            double.infinity,
                                            52.h,
                                          ),
                                          backgroundColor: AppColors.primary,
                                          side: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                        ),

                                        onPressed: () {
                                          ref
                                              .read(stopwatchProvider2.notifier)
                                              .start();
                                          ref
                                              .read(stopwatchProvider1.notifier)
                                              .resume();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.startIcon,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text: AppLocalizations.of(
                                                context,
                                              )!.resume,
                                              color: Colors.black,
                                              fontSize:
                                                  currentLanguageCode
                                                          .toString() !=
                                                      "en"
                                                  ? getAdjustedFontSize(12, fontOption).sp
                                                  : getAdjustedFontSize(16, fontOption).sp.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10.w),

                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                            double.infinity,
                                            52.h,
                                          ),
                                          backgroundColor: Color(0xff6F35CA),
                                          side: BorderSide(
                                            color: Color(0xff6F35CA),
                                          ),
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(stopwatchProvider1.notifier)
                                              .clear();
                                          ref
                                              .read(stopwatchProvider2.notifier)
                                              .reset();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.clearIcon,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.textWhite,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text: AppLocalizations.of(
                                                context,
                                              )!.clearTime,
                                              color: AppColors.textWhite,
                                              fontSize:
                                                  currentLanguageCode
                                                          .toString() !=
                                                      "en"
                                                  ? getAdjustedFontSize(12, fontOption).sp
                                                  : getAdjustedFontSize(16, fontOption).sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),

                        if (log.isNotEmpty)
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Color(0xff0C3156)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1.w,
                                    color: Color(0xff2DA8F0),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child:CustomText(text:
                                    _activeLog(
                                      ref.read(stopwatchProvider2.notifier),
                                    ),



                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff234B6E),
                                        side: BorderSide(
                                          color: Color(0xff234B6E),
                                        ),
                                      ),
                                      onPressed: () {
                                        ref
                                                .watch(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .logStopwatch =
                                            '';
                                        ref
                                            .read(stopwatchProvider2.notifier)
                                            .pause(); // you need a method to clear log
                                      },
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.clearIcon,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.textWhite,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text: AppLocalizations.of(
                                                context,
                                              )!.clear,
                                              fontSize: getAdjustedFontSize(16, fontOption).sp,
                                              color: AppColors.textWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                      ),
                                      onPressed: () {
                                        exportOutputAsPdf1(context, ref);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            IconPath.exportIcon,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.export,
                                            fontSize: getAdjustedFontSize(16, fontOption).sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    )
                  : activeMode == 'Converter'
                  ? Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: isDark ? Color(0xff0C3156) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black12),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (showCourse)
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      CustomText(
                                        text: AppLocalizations.of(
                                          context,
                                        )!.from,

                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: getAdjustedFontSize(14, fontOption).sp,
                                      ),
                                      SizedBox(height: 8.h),
                                      Consumer(
                                        builder: (context, ref, child) {
                                          final state = ref.watch(
                                            stopwatchProvider2,
                                          );

                                          return SplitCalculatorSelectorOne(
                                            items: const ["SCM", "SCY", "LCM"],
                                            selectedValue: state
                                                .fromCourse, // ✅ keep selected after refresh
                                            onChanged: (value) {
                                              ref
                                                  .read(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .setConverterCourses(
                                                    from: value,
                                                  );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    children: [
                                      CustomText(
                                        text: AppLocalizations.of(context)!.to,

                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: getAdjustedFontSize(14, fontOption).sp,
                                      ),
                                      SizedBox(height: 8.h),
                                      Consumer(
                                        builder: (context, ref, child) {
                                          final state = ref.watch(
                                            stopwatchProvider2,
                                          );

                                          return SplitCalculatorSelectorOne(
                                            items: const ["SCM", "SCY", "LCM"],
                                            selectedValue: state
                                                .toCourse, // ✅ keep selected after refresh
                                            onChanged: (value) {
                                              ref
                                                  .read(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .setConverterCourses(
                                                    to: value,
                                                  );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Color(0xff0C3156)
                                  : Color(0xffFFFFFF),
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
                                Consumer(
                                  builder: (context, ref, child) {
                                    var time = ref.watch(
                                      stopwatchProvider2.select(
                                        (s) => s.elapsed(),
                                      ),
                                    );

                                    return Card(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: CustomText(
                                            text: _formatElapsed(time),
                                            fontSize: getAdjustedFontSize(35, fontOption).sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),

                                /// INITIAL STATE
                                if (status == StopwatchStatus.initial &&
                                    activeMode == 'Converter')
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(double.infinity, 52.h),
                                      backgroundColor: isDark
                                          ? Color(0xffC69C3F)
                                          : null,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(stopwatchProvider2.notifier)
                                          .start();
                                      ref
                                          .read(stopwatchProvider1.notifier)
                                          .start();

                                      ref
                                              .read(
                                                showCourseSectionStopWatchProvider
                                                    .notifier,
                                              )
                                              .state =
                                          false;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.startIcon,
                                          colorFilter: ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                       CustomText(text:
                                          AppLocalizations.of(context)!.start,

                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                            fontWeight: FontWeight.w600,

                                        ),
                                      ],
                                    ),
                                  ),

                                /// RUNNING STATE
                                if (status == StopwatchStatus.running &&
                                    activeMode == 'Converter')
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                            double.infinity,
                                            52.h,
                                          ),
                                          backgroundColor: Color(0xff2DA8F0),
                                          side: BorderSide(
                                            color: Color(0xff2DA8F0),
                                          ),
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(stopwatchProvider1.notifier)
                                              .start();
                                          ref
                                              .read(stopwatchProvider2.notifier)
                                              .split();
                                        },
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.splitIcon,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.split,
                                                fontSize: getAdjustedFontSize(16, fontOption).sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                  double.infinity,
                                                  52.h,
                                                ),
                                                backgroundColor: Color(
                                                  0xff475569,
                                                ),
                                                side: BorderSide(
                                                  color: Color(0xff475569),
                                                ),
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      stopwatchProvider1
                                                          .notifier,
                                                    )
                                                    .start();
                                                ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .undoLastSplit();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    IconPath.undoIcon,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          AppColors.textWhite,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  CustomText(
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.undoSplit,
                                                    color: AppColors.textWhite,
                                                    fontSize: getAdjustedFontSize(12, fontOption).sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),

                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                  double.infinity,
                                                  52.h,
                                                ),
                                                backgroundColor: Color(
                                                  0xffFE484C,
                                                ),
                                                side: BorderSide(
                                                  color: Color(0xffFE484C),
                                                ),
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      stopwatchProvider1
                                                          .notifier,
                                                    )
                                                    .stop();
                                                ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .pause();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    IconPath.stopIcon,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          AppColors.textWhite,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  CustomText(
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.stop,
                                                    color: AppColors.textWhite,
                                                    fontSize: getAdjustedFontSize(12, fontOption).sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                /// STOPPED STATE
                                if (status == StopwatchStatus.stopped &&
                                    activeMode == 'Converter')
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                              double.infinity,
                                              52.h,
                                            ),
                                            backgroundColor: AppColors.primary,
                                            side: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),

                                          onPressed: () {
                                            ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .start();
                                            ref
                                                .read(
                                                  stopwatchProvider1.notifier,
                                                )
                                                .resume();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.startIcon,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.resume,
                                                color: Colors.black,
                                                fontSize:
                                                    currentLanguageCode
                                                            .toString() !=
                                                        "en"
                                                    ? getAdjustedFontSize(12, fontOption).sp
                                                    : getAdjustedFontSize(16, fontOption).sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                              double.infinity,
                                              52.h,
                                            ),
                                            backgroundColor: Color(0xff6F35CA),
                                            side: BorderSide(
                                              color: Color(0xff6F35CA),
                                            ),
                                          ),
                                          onPressed: () {
                                            ref
                                                    .watch(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .logConverter =
                                                '';
                                            ref
                                                .read(
                                                  stopwatchProvider1.notifier,
                                                )
                                                .clear();
                                            ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .reset();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.clearIcon,
                                                colorFilter: ColorFilter.mode(
                                                  AppColors.textWhite,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.clearTime,
                                                color: AppColors.textWhite,
                                                fontSize:
                                                    currentLanguageCode
                                                            .toString() !=
                                                        "en"
                                                    ? getAdjustedFontSize(12, fontOption).sp
                                                    : getAdjustedFontSize(16, fontOption).sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          if (log2.isNotEmpty)
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Color(0xff0C3156)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xff2DA8F0),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black12,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: CustomText(text:
                                      _activeLog(
                                        ref.read(stopwatchProvider2.notifier),
                                      ),

                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff234B6E),
                                          side: BorderSide(
                                            color: Color(0xff234B6E),
                                          ),
                                        ),
                                        onPressed: () {
                                          ref
                                                  .watch(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .logStopwatch =
                                              '';
                                          ref
                                              .read(stopwatchProvider2.notifier)
                                              .pause(); // you need a method to clear log
                                        },
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.clearIcon,
                                                colorFilter: ColorFilter.mode(
                                                  AppColors.textWhite,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.clear,
                                                fontSize: getAdjustedFontSize(16, fontOption).sp,
                                                color: AppColors.textWhite,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                        onPressed: () {
                                          exportOutputAsPdf(context, ref);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.exportIcon,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text: AppLocalizations.of(
                                                context,
                                              )!.export,
                                              fontSize: getAdjustedFontSize(16, fontOption).sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: isDark ? Color(0xff0C3156) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black12),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (showCourse2)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.gender,

                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                          ),
                                          SizedBox(height: 8.h),

                                          Consumer(
                                            builder: (context, ref, child) {
                                              final state = ref.watch(
                                                stopwatchProvider2,
                                              );

                                              // Define items
                                              const items = ["men", "women"];
                                              String capitalize(String s) =>
                                                  s.isNotEmpty
                                                  ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
                                                  : s;

                                              return SplitCalculatorSelectorOne(
                                                items: items
                                                    .map(capitalize)
                                                    .toList(), // display first letter uppercase
                                                selectedValue: capitalize(
                                                  state.gender,
                                                ), // show selected value capitalized
                                                onChanged: (v) {
                                                  // Convert back to lowercase before storing
                                                  final lowerCaseValue = v
                                                      .toLowerCase();
                                                  ref
                                                      .read(
                                                        stopwatchProvider2
                                                            .notifier,
                                                      )
                                                      .setPredictorParams(
                                                        g: lowerCaseValue,
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.course,

                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getAdjustedFontSize(16, fontOption).sp,
                                          ),
                                          SizedBox(height: 8.h),
                                          Consumer(
                                            builder: (context, ref, child) {
                                              final state = ref.watch(
                                                stopwatchProvider2,
                                              );
                                              const items = [
                                                "scy",
                                                "scm",
                                                "lcm",
                                              ];

                                              return SplitCalculatorSelectorOne(
                                                items: items
                                                    .map((e) => e.toUpperCase())
                                                    .toList(),
                                                selectedValue: state.course
                                                    .toUpperCase(),
                                                onChanged: (v) {
                                                  // Convert back to lowercase before storing
                                                  final lowerCaseValue = v
                                                      .toLowerCase();
                                                  ref
                                                      .read(
                                                        stopwatchProvider2
                                                            .notifier,
                                                      )
                                                      .setPredictorParams(
                                                        c: lowerCaseValue,
                                                      );
                                                },

                                                // ✅ keep selected after refresh
                                                //                                             onChanged: (v) => ref
                                                //     .read(
                                                // stopwatchProvider2.notifier,
                                                // )
                                                //     .setPredictorParams(
                                                // c: v.toLowerCase(),
                                                // ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.stroke,

                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                          ),
                                          SizedBox(height: 8.h),

                                          Consumer(
                                            builder: (context, ref, child) {
                                              final state = ref.watch(
                                                stopwatchProvider2,
                                              );

                                              const strokes = [
                                                "fly",
                                                "back",
                                                "free",
                                                "breast",
                                                "im",

                                              ];
                                              String formatStroke(String s) {
                                                if (s.toLowerCase() == 'im') {
                                                  return 'IM';
                                                }
                                                return s.isNotEmpty
                                                    ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
                                                    : s;
                                              }

                                              return SplitCalculatorSelectorOne(
                                                items: strokes
                                                    .map(formatStroke)
                                                    .toList(), // display formatted strokes
                                                selectedValue: formatStroke(
                                                  state.stroke,
                                                ), // display current selection formatted
                                                onChanged: (v) {
                                                  // Convert back to lowercase for storing
                                                  final lowerCaseValue = v
                                                      .toLowerCase();
                                                  ref
                                                      .read(
                                                        stopwatchProvider2
                                                            .notifier,
                                                      )
                                                      .setPredictorParams(
                                                        s: lowerCaseValue,
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.distance,

                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                          ),
                                          SizedBox(height: 8.h),
                                          Consumer(
                                            builder: (context, ref, child) {
                                              final state = ref.watch(
                                                stopwatchProvider2,
                                              );

                                              return SplitCalculatorSelectorOne(
                                                items: const [
                                                  "50",
                                                  "100",
                                                  "150",
                                                  "200",
                                                  "250",
                                                  "300",
                                                  "350",
                                                  "400",
                                                  "450",
                                                  "500",
                                                ],
                                                selectedValue: state
                                                    .distance, // ✅ keep selected after refresh
                                                onChanged: (v) => ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .setPredictorParams(d: v),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.splitSize,

                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                          ),
                                          SizedBox(height: 8.h),
                                          Consumer(
                                            builder: (context, ref, child) {
                                              final state = ref.watch(
                                                stopwatchProvider2,
                                              );

                                              return SplitCalculatorSelectorOne(
                                                items: const [
                                                  "50",
                                                  "100",
                                                  "150",
                                                  "200",
                                                  "250",
                                                  "500",
                                                ],
                                                selectedValue: state
                                                    .splitSize, // ✅ keep selected after refresh
                                                onChanged: (v) => ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .setPredictorParams(
                                                      split: v,
                                                    ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.startType,

                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                          ),
                                          SizedBox(height: 8.h),
                                          Consumer(
                                            builder: (context, ref, child) {
                                              final state = ref.watch(
                                                stopwatchProvider2,
                                              );

                                              return SplitCalculatorSelectorOne(
                                                items: const [
                                                  "From Start",
                                                  "From Push",

                                                ],
                                                selectedValue: state
                                                    .startType, // ✅ keep selected after refresh
                                                onChanged: (v) => ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .setPredictorParams(
                                                      start: v,
                                                    ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Color(0xff0C3156)
                                  : Color(0xffFFFFFF),
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
                                Consumer(
                                  builder: (context, ref, child) {
                                    var time = ref.watch(
                                      stopwatchProvider2.select(
                                        (s) => s.elapsed(),
                                      ),
                                    );

                                    return Card(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: CustomText(
                                            text: _formatElapsed(time),
                                            fontSize: 35.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),

                                /// INITIAL STATE
                                if (status == StopwatchStatus.initial)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(double.infinity, 52.h),
                                      backgroundColor: isDark
                                          ? Color(0xffC69C3F)
                                          : null,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(stopwatchProvider2.notifier)
                                          .start();
                                      ref
                                          .read(stopwatchProvider1.notifier)
                                          .start();
                                      ref
                                              .read(
                                                showCourseSectionStopWatchProvider2
                                                    .notifier,
                                              )
                                              .state =
                                          false;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.startIcon,
                                          colorFilter: ColorFilter.mode(
                                            Colors.black,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                       CustomText(text:
                                          AppLocalizations.of(context)!.start,

                                            fontSize: getAdjustedFontSize(14, fontOption).sp,
                                            fontWeight: FontWeight.w600,

                                        ),
                                      ],
                                    ),
                                  ),

                                /// RUNNING STATE
                                if (status == StopwatchStatus.running)
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                            double.infinity,
                                            52.h,
                                          ),
                                          backgroundColor: Color(0xff2DA8F0),
                                          side: BorderSide(
                                            color: Color(0xff2DA8F0),
                                          ),
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(stopwatchProvider1.notifier)
                                              .start();
                                          ref
                                              .read(stopwatchProvider2.notifier)
                                              .split();
                                        },
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.splitIcon,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.split,
                                                fontSize: getAdjustedFontSize(16, fontOption).sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                  double.infinity,
                                                  52.h,
                                                ),
                                                backgroundColor: Color(
                                                  0xff475569,
                                                ),
                                                side: BorderSide(
                                                  color: Color(0xff475569),
                                                ),
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      stopwatchProvider1
                                                          .notifier,
                                                    )
                                                    .start();
                                                ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .undoLastSplit();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    IconPath.undoIcon,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          AppColors.textWhite,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  CustomText(
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.undoSplit,
                                                    color: AppColors.textWhite,
                                                    fontSize: getAdjustedFontSize(12, fontOption).sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),

                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(
                                                  double.infinity,
                                                  52.h,
                                                ),
                                                backgroundColor: Color(
                                                  0xffFE484C,
                                                ),
                                                side: BorderSide(
                                                  color: Color(0xffFE484C),
                                                ),
                                              ),
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      stopwatchProvider1
                                                          .notifier,
                                                    )
                                                    .stop();
                                                ref
                                                    .read(
                                                      stopwatchProvider2
                                                          .notifier,
                                                    )
                                                    .pause();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    IconPath.stopIcon,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          AppColors.textWhite,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  CustomText(
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.stop,
                                                    color: AppColors.textWhite,
                                                    fontSize: getAdjustedFontSize(12, fontOption).sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                /// STOPPED STATE
                                if (status == StopwatchStatus.stopped)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                              double.infinity,
                                              52.h,
                                            ),
                                            backgroundColor: AppColors.primary,
                                            side: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),

                                          onPressed: () {
                                            ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .start();
                                            ref
                                                .read(
                                                  stopwatchProvider1.notifier,
                                                )
                                                .resume();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.startIcon,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.resume,
                                                color: Colors.black,
                                                fontSize:
                                                    currentLanguageCode
                                                            .toString() !=
                                                        "en"
                                                    ? getAdjustedFontSize(12, fontOption).sp
                                                    : getAdjustedFontSize(16, fontOption).sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                              double.infinity,
                                              52.h,
                                            ),
                                            backgroundColor: Color(0xff6F35CA),
                                            side: BorderSide(
                                              color: Color(0xff6F35CA),
                                            ),
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(
                                                  stopwatchProvider1.notifier,
                                                )
                                                .clear();
                                            ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .reset();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.clearIcon,
                                                colorFilter: ColorFilter.mode(
                                                  AppColors.textWhite,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.clearTime,
                                                color: AppColors.textWhite,
                                                fontSize:
                                                    currentLanguageCode
                                                            .toString() !=
                                                        "en"
                                                    ? getAdjustedFontSize(12, fontOption).sp
                                                    : getAdjustedFontSize(16, fontOption).sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          if (log3.isNotEmpty)
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Color(0xff0C3156)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xff2DA8F0),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black12,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: CustomText(text:
                                      _activeLog(
                                        ref.read(stopwatchProvider2.notifier),
                                      ),

                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff234B6E),
                                          side: BorderSide(
                                            color: Color(0xff234B6E),
                                          ),
                                        ),
                                        onPressed: () {
                                          ref
                                                  .watch(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .logPredictor =
                                              '';
                                          ref
                                              .read(stopwatchProvider2.notifier)
                                              .pause(); // you need a method to clear log
                                        },
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                IconPath.clearIcon,
                                                colorFilter: ColorFilter.mode(
                                                  AppColors.textWhite,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              CustomText(
                                                text: AppLocalizations.of(
                                                  context,
                                                )!.clear,
                                                fontSize: getAdjustedFontSize(16, fontOption).sp,
                                                color: AppColors.textWhite,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                        onPressed: () {
                                          exportOutputAsPdf3(context, ref);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath.exportIcon,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            CustomText(
                                              text: AppLocalizations.of(
                                                context,
                                              )!.export,
                                              fontSize: getAdjustedFontSize(16, fontOption).sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportOutputAsPdf(BuildContext context, WidgetRef ref) async {
    final log2 = ref.read(stopwatchProvider2).logConverter;

    print(log2);

    if (log2.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No output to export!')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Text(log2, style: pw.TextStyle(font: pw.Font.courier())),
          );
        },
      ),
    );

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/swim_converter_output.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF saved at: ${file.path}')));

      await OpenFile.open(file.path);

      // ✅ Clear log after export
    } catch (e) {
      debugPrint("PDF export error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to export PDF')));
    }
  }

  Future<void> exportOutputAsPdf3(BuildContext context, WidgetRef ref) async {
    final log3 = ref.read(stopwatchProvider2).logPredictor;

    print(log3);

    if (log3.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No output to export!')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Text(log3, style: pw.TextStyle(font: pw.Font.courier())),
          );
        },
      ),
    );

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/swim_predictor_output.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF saved at: ${file.path}')));

      await OpenFile.open(file.path);

      // Clear logPredictor after export
      //ref.read(stopwatchProvider2.notifier).clearLogPredictor();
    } catch (e) {
      debugPrint("PDF export error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to export PDF')));
    }
  }

  Future<void> exportOutputAsPdf1(BuildContext context, WidgetRef ref) async {
    final log = ref.read(stopwatchProvider2).logStopwatch;

    print(log);

    if (log.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No output to export!')));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Text(log, style: pw.TextStyle(font: pw.Font.courier())),
          );
        },
      ),
    );

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/swim_stopwatch_output.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF saved at: ${file.path}')));

      await OpenFile.open(file.path);

      // clear log
      //ref.read(stopwatchProvider2.notifier).clearLogStopwatch();
    } catch (e) {
      debugPrint("PDF export error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to export PDF')));
    }
  }

  static String _activeLog(StopwatchController2 c) {
    switch (c.activeMode) {
      case 'Predictor':
        return c.logPredictor;
      case 'Converter':
        return c.logConverter;
      default:
        return c.logStopwatch;
    }
  }

  static String _formatElapsed(double s) =>
      '${_twoDigits((s ~/ 60))}:${_secondsPart(s)}';
  static String _secondsPart(double s) {
    final secs = s % 60;
    return secs.toStringAsFixed(2).padLeft(5, '0');
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
