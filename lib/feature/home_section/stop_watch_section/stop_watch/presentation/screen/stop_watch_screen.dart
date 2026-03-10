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

import '../../riverpod/stop_watch_controller.dart';


enum StopwatchStatus {
  initial,
  running,
  stopped,
}

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
        (ref) => StopwatchController1());

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
    final List<String> items = [AppLocalizations.of(context)!.normal, AppLocalizations.of(context)!.converterBig, AppLocalizations.of(context)!.predictor];
    final settings = ref.watch(settingsProvider);
    final currentLanguageCode = settings.language.code;
    final showCourse = ref.watch(showCourseSectionStopWatchProvider);
    final showCourse2 = ref.watch(showCourseSectionStopWatchProvider2);


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
          child: Divider(height: 1, thickness: 1, color: isDark?Color(0xffDADADA):Colors.grey.shade300),
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Top Buttons
              CustomText(text: AppLocalizations.of(context)!.mode,fontSize: 18.sp,fontWeight: FontWeight.w600,color: Color(0xffE3D99B),),
              SizedBox(height: 10.h,),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: isDark?Color(0xff1B3A5C):Colors.white,
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
                                :isDark?Color(0xff033151).withValues(alpha: 0.6):Color(0xFFEAEDF1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            items[itemIndex],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.black
                                  : isDark?Color(0xffE3D99B): Color(0xFF82888E),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
        
        
              SizedBox(height: 20.h),
              if(!showCourse && selectedIndex == 1)
                Center(
                  child: GestureDetector(
                    onTap: (){
                      ref.read(showCourseSectionStopWatchProvider.notifier).state = true;

                    },
                    child: Column(
                      children: [
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(IconPath.pullIcon),
                            CustomText(text: AppLocalizations.of(context)!.pullDownToSeeOptions,fontSize: 14.sp,color: Color(0xffC7C7C7),)
                          ],
                        ),
                        SizedBox(height: 20.h,)
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

              if(!showCourse2 && selectedIndex == 2)
                Center(
                  child: GestureDetector(
                    onTap: (){
                      ref.read(showCourseSectionStopWatchProvider2.notifier).state = true;

                    },
                    child: Column(
                      children: [
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(IconPath.pullIcon),
                            CustomText(text: AppLocalizations.of(context)!.pullDownToSeeOptions,fontSize: 14.sp,color: Color(0xffC7C7C7),)
                          ],
                        ),
                        SizedBox(height: 20.h,)
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
              selectedIndex == 0
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark?Color(0xff0C3156): Color(0xffFFFFFF),
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
                          Card(

                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CustomText(text: "00.00",fontSize: 35.sp,fontWeight: FontWeight.w700,),
                            )),
                          ),
                          SizedBox(height: 20.h),
                          /// INITIAL STATE
                          if (status == StopwatchStatus.initial)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(double.infinity, 52.h),
                                backgroundColor: isDark ? Color(0xffC69C3F) : null,
                              ),
                              onPressed: () {
                                ref.read(stopwatchProvider1.notifier).start();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    IconPath.startIcon,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black,
                                        BlendMode.srcIn),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    AppLocalizations.of(context)!.start,
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
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
                                    backgroundColor:  Color(0xff2DA8F0) ,
                                    side: BorderSide(color: Color(0xff2DA8F0)),
                                  ),
                                    onPressed: () {},
                                    child: Center(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.splitIcon,
                                          colorFilter: ColorFilter.mode(
                                             Colors.black,
                                              BlendMode.srcIn),
                                        ),
                                        SizedBox(width: 6.w,),
                                        CustomText(text: AppLocalizations.of(context)!.split,fontSize: 16.sp,fontWeight: FontWeight.w600,),
                                      ],
                                    )),
                                  ),


                                SizedBox(height: 20.h),
                                Row(
                                  children: [


                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(double.infinity, 52.h),
                                          backgroundColor:  Color(0xff475569) ,
                                          side: BorderSide(color: Color(0xff475569)),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath. undoIcon,
                                              colorFilter: ColorFilter.mode(
                                                 AppColors.textWhite ,
                                                  BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 6.w,),
                                            CustomText(text: AppLocalizations.of(context)!.undoSplit,color: AppColors.textWhite,fontSize: 12.sp,fontWeight: FontWeight.w700,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),



                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(double.infinity, 52.h),
                                          backgroundColor:  Color(0xffFE484C) ,
                                          side: BorderSide(color:  Color(0xffFE484C)),
                                        ),
                                        onPressed: () {
                                          ref.read(stopwatchProvider1.notifier).stop();
                                        },
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              IconPath. stopIcon,
                                              colorFilter: ColorFilter.mode(
                                                  AppColors.textWhite ,
                                                  BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 6.w,),
                                            CustomText(text: AppLocalizations.of(context)!.stop,color: AppColors.textWhite,fontSize: 12.sp,fontWeight: FontWeight.w700,),
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
                                      fixedSize: Size(double.infinity, 52.h),
                                      backgroundColor: AppColors.primary ,
                                      side: BorderSide(color: AppColors.primary),
                                    ),


                                    onPressed: () {
                                      ref.read(stopwatchProvider1.notifier).resume();
                                    },
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.startIcon,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black ,
                                              BlendMode.srcIn),
                                        ),
                                        SizedBox(width: 6.w,),
                                        CustomText(text: AppLocalizations.of(context)!.resume,color: Colors.black,fontSize: currentLanguageCode.toString() != "en"?12:16.sp,fontWeight: FontWeight.w700,),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10.w),

                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(double.infinity, 52.h),
                                      backgroundColor:  Color(0xff6F35CA) ,
                                      side: BorderSide(color:   Color(0xff6F35CA)),
                                    ),
                                    onPressed: () {
                                      ref.read(stopwatchProvider1.notifier).clear();
                                    },
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.clearIcon,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.textWhite ,
                                              BlendMode.srcIn),
                                        ),
                                        SizedBox(width: 6.w,),
                                        CustomText(text: AppLocalizations.of(context)!.clearTime,color: AppColors.textWhite,fontSize: currentLanguageCode.toString() != "en"?12:16.sp,fontWeight: FontWeight.w700,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
        
                          SizedBox(height: 20.h),
                        ],
                      ),
                    )
                  : selectedIndex == 1?Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: isDark?Color(0xff0C3156):Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    if(showCourse)
                      Column(
                        children: [
                          Row(
                            children: [

                              Expanded(
                                child: Column(
                                  children: [

                                    CustomText(text:
                                    AppLocalizations.of(context)!.from,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),

                                    VerticalSelector(
                                      items:  [AppLocalizations.of(context)!.scm, AppLocalizations.of(context)!.scy, AppLocalizations.of(context)!.lcm],
                                      selected: state.from,
                                      onTap: controller.selectFrom,
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    AppLocalizations.of(context)!.to,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),



                                    VerticalSelector(
                                      items: [AppLocalizations.of(context)!.scm, AppLocalizations.of(context)!.scy, AppLocalizations.of(context)!.lcm],
                                      selected: state.to,
                                      onTap: controller.selectTo,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),



                    SizedBox(height: 20.h),
                    Card(

                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CustomText(text: "00.00",fontSize: 35.sp,fontWeight: FontWeight.w700,),
                      )),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:  Size(double.infinity, 52.h),
                        backgroundColor: isDark?Color(0xffC69C3F):null,// width = full, height = 50
                      ),
                      onPressed: (){
                        // context.go(RouteNames.loginScreen);
                        ref.read(showCourseSectionStopWatchProvider.notifier).state = false;
                      },
                      child: Center(child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.startIcon  ,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                          Text(AppLocalizations.of(context)!.start,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,),),
                        ],
                      )),
                    ),
                  ],
                ),
              ):Container(
                padding: const EdgeInsets.all(16),
        
                decoration: BoxDecoration(
                  color: isDark?Color(0xff0C3156):Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    if(showCourse2)
                      Column(
                        children: [
                          Row(
                            children: [

                              Expanded(
                                child: Column(
                                  children: [

                                    CustomText(text:
                                    AppLocalizations.of(context)!.gender,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),

                                    VerticalSelector(
                                      items:  ["",AppLocalizations.of(context)!.women, AppLocalizations.of(context)!.men, ],
                                      selected: state.from,
                                      onTap: controller.selectFrom,
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    AppLocalizations.of(context)!.course,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),



                                    VerticalSelector(
                                      items:  [AppLocalizations.of(context)!.scm, AppLocalizations.of(context)!.scy, AppLocalizations.of(context)!.lcm],
                                      selected: state.to,
                                      onTap: controller.selectTo,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 20.h),
                          Row(
                            children: [

                              Expanded(
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    AppLocalizations.of(context)!.stroke,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),




                                    VerticalSelector(
                                      items:  [AppLocalizations.of(context)!.fly,AppLocalizations.of(context)!.back,AppLocalizations.of(context)!.free, AppLocalizations.of(context)!.im,AppLocalizations.of(context)!.breast],
                                      selected: [state.stroke],
                                      onTap: controller.selectStroke,
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    AppLocalizations.of(context)!.distance,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),



                                    VerticalSelector(
                                      items: const ["50", "100", "150","200","250"],
                                      selected: [state.distance],
                                      onTap: controller.selectDistance,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 20.h),
                          Row(
                            children: [





                              Expanded(
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    AppLocalizations.of(context)!.splitSize,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),



                                    VerticalSelector(
                                      items: const ["50", "100", "150","200","250"],
                                      selected: [state.distance],
                                      onTap: controller.selectDistance,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  children: [
                                    CustomText(text:
                                    AppLocalizations.of(context)!.startType,

                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,

                                    ),

                                    SizedBox(height: 10.h),




                                    VerticalSelector(
                                      items: [AppLocalizations.of(context)!.fromStart,AppLocalizations.of(context)!.fromMiddle,AppLocalizations.of(context)!.fromLast ],
                                      selected: [state.stroke],
                                      onTap: controller.selectStroke,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),

                    Card(

                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CustomText(text: "00.00",fontSize: 35.sp,fontWeight: FontWeight.w700,),
                      )),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:  Size(double.infinity, 52.h), // width = full, height = 50
                      ),
                      onPressed: (){
                       // context.go(RouteNames.loginScreen);
                        ref.read(showCourseSectionStopWatchProvider2.notifier).state = false;
                      },
                      child: Center(child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.startIcon  ,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                          Text(AppLocalizations.of(context)!.start,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600),),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: isDark?Color(0xff234B6E):Color(0xffEAEDF1),
                    borderRadius:BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)
                    )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: AppLocalizations.of(context)!.split,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
                    CustomText(text: AppLocalizations.of(context)!.splitTime,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),
                    CustomText(text: AppLocalizations.of(context)!.total,fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.primary,),

                  ],
                ),
              ),
              SizedBox(
                height: 300.h, // fixed height for scrollable area
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark?Color(0xff1B3A5C):Color(0xffFFFFFF),


                  ),
                  child: state.splits.isEmpty
                      ?  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noSplitsYet,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: state.splits.length,
                    itemBuilder: (context, index) {
                      final split = state.splits[index];

                      // alternate colors: even -> E3F0FF, odd -> FFFFFF
                      final bgColor = index % 2 == 0 ? Color(0xFFE3F0FF) : Color(0xFFFFFFFF);

                      return Container(
                        color: bgColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: split.distance.toString(),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            CustomText(
                              text: split.splitTime.toStringAsFixed(2),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            CustomText(
                              text: split.total.toStringAsFixed(2),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xff234B6E),
                          side: BorderSide(color: Color(0xff234B6E))
                      ),
                      onPressed: () {
                        //notifier.clear();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(IconPath.clearIcon,colorFilter: ColorFilter.mode(isDark?AppColors.textWhite:Colors.black, BlendMode.srcIn),),
                            SizedBox(width: 6.w,),
                            CustomText(text: AppLocalizations.of(context)!.clear,fontSize: 16.sp,color: AppColors.textWhite,fontWeight: FontWeight.w700,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.primary,
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.exportIcon,colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                          SizedBox(width: 6.w,),
                          CustomText(text: AppLocalizations.of(context)!.export,fontSize: 16.sp,fontWeight: FontWeight.w700,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
