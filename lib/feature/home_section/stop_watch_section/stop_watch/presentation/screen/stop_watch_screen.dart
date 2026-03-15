import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/icon_path.dart';

import '../../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../../../calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import '../../../../converter_section/presentation/screen/widget/vertical_selector_widget.dart';

import '../../../../converter_section/riverpod/converter_controller.dart';
import '../../../../converter_section/riverpod/converter_controller1.dart';
import '../../riverpod/stop_watch_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stopwatchProvider);
    final controller = ref.read(stopwatchProvider.notifier);
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
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xffE3D99B),
              ),
              SizedBox(height: 10.h),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      return const SizedBox(width: 6);
                    }

                    final itemIndex = index ~/ 2;
                    final mode = modes[itemIndex];
                    final isActive = activeMode == mode;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(stopwatchProvider2.notifier).setMode(mode);
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
                            mode,
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
              if (!showCourse && activeMode == 'Predictor')
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
                              fontSize: 14.sp,
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

              if (!showCourse2 && activeMode == 'Converter')
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
                              fontSize: 14.sp,
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

              /// Main Content
              activeMode == 'Stopwatch'
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                text: "WATCHES",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(width: 16.w),
                              Padding(
                                padding: EdgeInsets.only(left: 16.w),
                                child: SvgPicture.asset(IconPath.minusIcon),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 16.w),
                                child: SvgPicture.asset(IconPath.plusIcon),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
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
                                      Text(
                                        AppLocalizations.of(context)!.start,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
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
                                              fontSize: 16.sp,
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
                                                  fontSize: 12.sp,
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
                                                  fontSize: 12.sp,
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
                                                  ? 12
                                                  : 16.sp,
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
                                                  ? 12
                                                  : 16.sp,
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
                                  child: Text(
                                    _activeLog(
                                      ref.read(stopwatchProvider2.notifier),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
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
                                              fontSize: 16.sp,
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
                                      onPressed: () {},
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
                                            fontSize: 16.sp,
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
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(context)!.from,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final fromCource = ref.watch(
                                          stopwatchProvider2.select(
                                            (s) => s.fromCourse,
                                          ),
                                        );
                                        return SizedBox(
                                          width: double.infinity,
                                          child: PopupMenuButton<String>(
                                            onSelected: (v) {
                                              ref
                                                  .read(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .setConverterCourses(from: v);
                                            },

                                            color: Colors.white,

                                            /// move dropdown to the right
                                            offset: const Offset(100, 45),

                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.scm,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.scm,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.scy,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.scy,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.lcm,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.lcm,
                                                ),
                                              ),
                                            ],
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    fromCource.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(context)!.to,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final fromCource = ref.watch(
                                          stopwatchProvider2.select(
                                            (s) => s.toCourse,
                                          ),
                                        );
                                        return SizedBox(
                                          width: double.infinity,
                                          child: PopupMenuButton<String>(
                                            onSelected: (v) {
                                              ref
                                                  .read(
                                                    stopwatchProvider2.notifier,
                                                  )
                                                  .setConverterCourses(to: v);
                                            },

                                            color: Colors.white,

                                            /// move dropdown to the right
                                            offset: const Offset(100, 45),

                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.scm,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.scm,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.scy,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.scy,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.lcm,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.lcm,
                                                ),
                                              ),
                                            ],
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    fromCource.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //
                                //
                                //
                                //     SizedBox(width: 12.w),
                                //
                                //     Expanded(
                                //       child: Column(
                                //         children: [
                                //           CustomText(text:
                                //           AppLocalizations.of(context)!.to,
                                //
                                //             color: AppColors.primary,
                                //             fontWeight: FontWeight.w600,
                                //             fontSize: 14.sp,
                                //
                                //           ),
                                //
                                //           SizedBox(height: 10.h),
                                //
                                //
                                //
                                //           VerticalSelector(
                                //             items: [AppLocalizations.of(context)!.scm, AppLocalizations.of(context)!.scy, AppLocalizations.of(context)!.lcm],
                                //             selected: state.to,
                                //             onTap: controller.selectTo,
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //
                                //   ],
                                // ),
                              ],
                            ),

                          SizedBox(height: 20.h),
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
                                        Text(
                                          AppLocalizations.of(context)!.start,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                                                fontSize: 16.sp,
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
                                                    fontSize: 12.sp,
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
                                                    fontSize: 12.sp,
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
                                                    ? 12
                                                    : 16.sp,
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
                                                    ? 12
                                                    : 16.sp,
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
                                    child: Text(
                                      _activeLog(
                                        ref.read(stopwatchProvider2.notifier),
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
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
                                                fontSize: 16.sp,
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
                                        onPressed: () {},
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
                                              fontSize: 16.sp,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(
                                        context,
                                      )!.gender,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final gender = ref.watch(
                                          stopwatchProvider2.select(
                                            (s) => s.gender,
                                          ),
                                        );
                                        return PopupMenuButton<String>(
                                          onSelected: (v) => ref
                                              .read(stopwatchProvider2.notifier)
                                              .setPredictorParams(g: v),
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                              value: 'men',
                                              child: Text('Men'),
                                            ),
                                            PopupMenuItem(
                                              value: 'women',
                                              child: Text('Women'),
                                            ),
                                          ],
                                          offset: const Offset(100, 45),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  gender.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_drop_down,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12.h),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(
                                        context,
                                      )!.course,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final course = ref.watch(
                                          stopwatchProvider2.select(
                                            (s) => s.course,
                                          ),
                                        );
                                        return SizedBox(
                                          width: double.infinity,
                                          child: PopupMenuButton<String>(
                                            onSelected: (v) => ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .setPredictorParams(
                                                  c: v.toLowerCase(),
                                                ),
                                            color: Colors.white,

                                            /// move dropdown to the right
                                            offset: const Offset(100, 45),

                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.scm,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.scm,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.scy,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.scy,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: AppLocalizations.of(
                                                  context,
                                                )!.lcm,
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.lcm,
                                                ),
                                              ),
                                            ],
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    course.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(
                                        context,
                                      )!.stroke,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),

                                    SizedBox(
                                      width: double.infinity,
                                      child: Consumer(
                                        builder: (context, ref, _) {
                                          final stroke = ref.watch(
                                            stopwatchProvider2.select(
                                              (s) => s.stroke,
                                            ),
                                          );

                                          final mapping = {
                                            AppLocalizations.of(context)!.fly:
                                                'fly',
                                            AppLocalizations.of(context)!.back:
                                                'back',
                                            AppLocalizations.of(context)!.free:
                                                'free',
                                            AppLocalizations.of(context)!.im:
                                                'im',
                                            AppLocalizations.of(
                                              context,
                                            )!.breast: 'breast',
                                          };

                                          final mappingReverse = {
                                            'fly': AppLocalizations.of(
                                              context,
                                            )!.fly,
                                            'back': AppLocalizations.of(
                                              context,
                                            )!.back,
                                            'free': AppLocalizations.of(
                                              context,
                                            )!.free,
                                            'im': AppLocalizations.of(
                                              context,
                                            )!.im,
                                            'breast': AppLocalizations.of(
                                              context,
                                            )!.breast,
                                          };

                                          return PopupMenuButton<String>(
                                            color: Colors.white,

                                            /// move dropdown to the right
                                            offset: const Offset(100, 45),
                                            onSelected: (v) => ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .setPredictorParams(s: v),
                                            itemBuilder: (context) => mapping
                                                .keys
                                                .map(
                                                  (key) => PopupMenuItem(
                                                    value: key,
                                                    child: Text(key),
                                                  ),
                                                )
                                                .toList(),
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    stroke,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(
                                        context,
                                      )!.distance,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),

                                    SizedBox(
                                      width: double.infinity,
                                      child: Consumer(
                                        builder: (context, ref, _) {
                                          final state1 = ref.watch(
                                            stopwatchProvider2.select(
                                              (s) => s.distance,
                                            ),
                                          );

                                          const distanceItems = [
                                            "50",
                                            "100",
                                            "150",
                                            "200",
                                            "250",
                                            "500",
                                          ];

                                          return PopupMenuButton<String>(
                                            color: Colors.white,
                                            onSelected: (v) => ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .setPredictorParams(d: v),
                                            itemBuilder: (context) =>
                                                distanceItems
                                                    .map(
                                                      (distance) =>
                                                          PopupMenuItem(
                                                            value: distance,
                                                            child: Text(
                                                              distance,
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    state1,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // SizedBox(height: 25.h),
                                // Row(
                                //   children: [
                                //
                                //     Expanded(
                                //       child: Column(
                                //         children: [
                                //           CustomText(text:
                                //           AppLocalizations.of(context)!.stroke,
                                //
                                //             color: AppColors.primary,
                                //             fontWeight: FontWeight.w600,
                                //             fontSize: 14.sp,
                                //
                                //           ),
                                //
                                //           SizedBox(height: 10.h),
                                //
                                //
                                //
                                //
                                //           VerticalSelector(
                                //             items:  [AppLocalizations.of(context)!.fly,AppLocalizations.of(context)!.back,AppLocalizations.of(context)!.free, AppLocalizations.of(context)!.im,AppLocalizations.of(context)!.breast],
                                //             selected: [state.stroke],
                                //             onTap: controller.selectStroke,
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //
                                //     SizedBox(width: 12.w),
                                //
                                //     Expanded(
                                //       child: Column(
                                //         children: [
                                //           CustomText(text:
                                //           AppLocalizations.of(context)!.distance,
                                //
                                //             color: AppColors.primary,
                                //             fontWeight: FontWeight.w600,
                                //             fontSize: 14.sp,
                                //
                                //           ),
                                //
                                //           SizedBox(height: 10.h),
                                //
                                //
                                //
                                //           VerticalSelector(
                                //             items: const ["50", "100", "150","200","250"],
                                //             selected: [state.distance],
                                //             onTap: controller.selectDistance,
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //
                                //   ],
                                // ),
                                SizedBox(height: 20.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(
                                        context,
                                      )!.splitSize,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),

                                    SizedBox(
                                      width: double.infinity,
                                      child: Consumer(
                                        builder: (context, ref, _) {
                                          final state1 = ref.watch(
                                            stopwatchProvider2.select(
                                              (s) => s.splitSize,
                                            ),
                                          );

                                          const distanceItems = [
                                            "50",
                                            "100",
                                            "150",
                                            "200",
                                            "250",
                                            "500",
                                          ];

                                          return PopupMenuButton<String>(
                                            color: Colors.white,
                                            onSelected: (v) => ref
                                                .read(
                                                  stopwatchProvider2.notifier,
                                                )
                                                .setPredictorParams(split: v),
                                            itemBuilder: (context) =>
                                                distanceItems
                                                    .map(
                                                      (distance) =>
                                                          PopupMenuItem(
                                                            value: distance,
                                                            child: Text(
                                                              distance,
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    state1,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_drop_down,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12.h),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppLocalizations.of(
                                        context,
                                      )!.startType,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),

                                    SizedBox(height: 10.h),

                                    SizedBox(
                                      width: double.infinity,
                                      child: PopupMenuButton<String>(
                                        onSelected: (v) => ref
                                            .read(stopwatchProvider2.notifier)
                                            .setPredictorParams(start: v),
                                        color: Colors.white,

                                        /// move dropdown to the right
                                        offset: const Offset(100, 45),

                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: AppLocalizations.of(
                                              context,
                                            )!.fromStart,
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.fromStart,
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: AppLocalizations.of(
                                              context,
                                            )!.fromMiddle,
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.fromMiddle,
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: AppLocalizations.of(
                                              context,
                                            )!.fromLast,
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.fromLast,
                                            ),
                                          ),
                                        ],
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ref.read(
                                                  stopwatchProvider2.select(
                                                    (s) => s.startType,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20.h),
                              ],
                            ),

                          SizedBox(height: 20.h),
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
                                        Text(
                                          AppLocalizations.of(context)!.start,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
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
                                                fontSize: 16.sp,
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
                                                    fontSize: 12.sp,
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
                                                    fontSize: 12.sp,
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
                                                    ? 12
                                                    : 16.sp,
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
                                                    ? 12
                                                    : 16.sp,
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
                                    child: Text(
                                      _activeLog(
                                        ref.read(stopwatchProvider2.notifier),
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
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
                                                fontSize: 16.sp,
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
                                        onPressed: () {},
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
                                              fontSize: 16.sp,
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
              // SizedBox(height: 20.h,),
              // Container(
              //   padding: EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //       color: isDark?Color(0xff234B6E):Color(0xffEAEDF1),
              //       borderRadius:BorderRadius.only(
              //           topRight: Radius.circular(10),
              //           topLeft: Radius.circular(10)
              //       )
              //   ),
              //   child:Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       CustomText(text: AppLocalizations.of(context)!.split,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
              //       CustomText(text: AppLocalizations.of(context)!.splitTime,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
              //       CustomText(text: AppLocalizations.of(context)!.total,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
              //
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 300.h, // fixed height for scrollable area
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: isDark?Color(0xff1B3A5C):Color(0xffFFFFFF),
              //
              //
              //     ),
              //     child: state.splits.isEmpty
              //         ?  Center(
              //       child: Text(
              //         AppLocalizations.of(context)!.noSplitsYet,
              //         style: TextStyle(color: Colors.grey),
              //       ),
              //     )
              //         : ListView.builder(
              //       itemCount: state.splits.length,
              //       itemBuilder: (context, index) {
              //         final split = state.splits[index];
              //
              //         // alternate colors: even -> E3F0FF, odd -> FFFFFF
              //         final bgColor = index % 2 == 0 ? Color(0xFFE3F0FF) : Color(0xFFFFFFFF);
              //
              //         return Container(
              //           color: bgColor,
              //           padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               CustomText(
              //                 text: split.distance.toString(),
              //                 fontSize: 14.sp,
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.primary,
              //               ),
              //               CustomText(
              //                 text: split.splitTime.toStringAsFixed(2),
              //                 fontSize: 14.sp,
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.primary,
              //               ),
              //               CustomText(
              //                 text: split.total.toStringAsFixed(2),
              //                 fontSize: 14.sp,
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.primary,
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),

              // SizedBox(height: 16.h),
              //
              // /// ACTION BUTTONS
              // Row(
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor:Color(0xff234B6E),
              //             side: BorderSide(color: Color(0xff234B6E))
              //         ),
              //         onPressed: () {
              //           //notifier.clear();
              //         },
              //         child: Center(
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               SvgPicture.asset(IconPath.clearIcon,colorFilter: ColorFilter.mode(AppColors.textWhite, BlendMode.srcIn),),
              //               SizedBox(width: 6.w,),
              //               CustomText(text: AppLocalizations.of(context)!.clear,fontSize: 16.sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 12.w),
              //     Expanded(
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor:AppColors.primary,
              //         ),
              //         onPressed: () {},
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             SvgPicture.asset(IconPath.exportIcon,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
              //             SizedBox(width: 6.w,),
              //             CustomText(text: AppLocalizations.of(context)!.export,fontSize: 16.sp,fontWeight: FontWeight.w700,),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
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
