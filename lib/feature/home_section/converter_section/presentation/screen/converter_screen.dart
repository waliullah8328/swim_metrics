import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_text_form_field.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../../../../core/utils/utils/print_utils.dart';
import '../../../calculator_section/calculator/presentation/screen/widget/custom_drawer_widget.dart';
import '../../riverpod/converter_controller.dart';
import '../../riverpod/converter_controller1.dart';

final showCourseSectionConverter = StateProvider<bool>((ref) => true);

class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  late final TextEditingController timeController;
  late FocusNode timeFocusNode;

  @override
  void initState() {
    super.initState();
    final state1 = ref.read(converterProvider1);
    timeController = TextEditingController(text: state1.timeText);
    timeFocusNode = FocusNode();
  }

  @override
  void dispose() {
    timeController.dispose();
    timeFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    debugPrint("build");


    final state = ref.watch(converterProvider);
    final state1 = ref.watch(converterProvider1);
    //final controller = ref.read(converterProvider.notifier);
    final controller1 = ref.read(converterProvider1.notifier);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCourse = ref.watch(showCourseSectionConverter);

    return Scaffold(
      key: scaffoldKey,

      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomText(text: AppLocalizations.of(context)!.converter,fontSize: 24.sp,fontWeight: FontWeight.w600,),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
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
            color: Colors.grey.shade300,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            if(!showCourse)
              Center(
                child: GestureDetector(
                  onTap: (){
                    ref.read(showCourseSectionConverter.notifier).state = true;

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

              ),

            Container(
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

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CustomText(text:
                            AppLocalizations.of(context)!.from,

                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,

                            ),

                            SizedBox(height: 10.h),

                            SizedBox(
                              width: double.infinity,
                              child: PopupMenuButton<String>(
                                onSelected: controller1.setCourse,
                                color: isDark?Color(0xff153250):Colors.white,

                                /// move dropdown to the right
                                offset: const Offset(100, 45),

                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: AppLocalizations.of(context)!.scm,
                                    child: Text(AppLocalizations.of(context)!.scm),
                                  ),
                                  PopupMenuItem(
                                    value: AppLocalizations.of(context)!.scy,
                                    child: Text(AppLocalizations.of(context)!.scy),
                                  ),
                                  PopupMenuItem(
                                    value: AppLocalizations.of(context)!.lcm,
                                    child: Text(AppLocalizations.of(context)!.lcm),
                                  ),
                                ],
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isDark?Color(0xff153250):Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state1.course.toString(),
                                        style: TextStyle(
                                          fontSize: 16.sp,

                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),




                        SizedBox(height: 20.h,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: AppLocalizations.of(context)!.to,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                            Row(
                              children: [
                                // SCY
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: state1.targets.contains('scy'),
                                      onChanged: state.from.isNotEmpty && state.from.first == 'SCY'
                                          ? null
                                          : (val) => controller1.toggleTarget('scy', val ?? false),
                                    ),
                                    const Text('SCY'),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // SCM
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: state1.targets.contains('scm'),
                                      onChanged: state.from.isNotEmpty && state.from.first == 'SCM'
                                          ? null
                                          : (val) => controller1.toggleTarget('scm', val ?? false),
                                    ),
                                    const Text('SCM'),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // LCM
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: state1.targets.contains('lcm'),
                                      onChanged: state.from.isNotEmpty && state.from.first == 'LCM'
                                          ? null
                                          : (val) => controller1.toggleTarget('lcm', val ?? false),
                                    ),
                                    const Text('LCM'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CustomText(text:
                            AppLocalizations.of(context)!.gender,

                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,

                            ),

                            SizedBox(height: 10.h),

                            PopupMenuButton<String>(
                              onSelected: (v) => controller1.setGender(v),
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'men', child: Text('Men')),
                                PopupMenuItem(value: 'women', child: Text('Women')),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isDark?Color(0xff153250):Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state1.gender, style:  TextStyle(fontSize: 16.sp,)),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 20.h),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CustomText(text:
                            AppLocalizations.of(context)!.stroke,

                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,

                            ),

                            SizedBox(height: 10.h),

                            SizedBox(
                              width: double.infinity,
                              child: Consumer(builder: (context, ref, _) {
                                final state = ref.watch(converterProvider);
                                final controller1 = ref.read(converterProvider.notifier);

                                final mapping = {
                                  AppLocalizations.of(context)!.fly: 'fly',
                                  AppLocalizations.of(context)!.back: 'back',
                                  AppLocalizations.of(context)!.free: 'free',
                                  AppLocalizations.of(context)!.im: 'im',
                                  AppLocalizations.of(context)!.breast: 'breast',
                                };

                                final mappingReverse = {
                                  'fly': AppLocalizations.of(context)!.fly,
                                  'back': AppLocalizations.of(context)!.back,
                                  'free': AppLocalizations.of(context)!.free,
                                  'im': AppLocalizations.of(context)!.im,
                                  'breast': AppLocalizations.of(context)!.breast,
                                };

                                return PopupMenuButton<String>(
                                  color: isDark?Color(0xff153250):Colors.white,
                                  /// move dropdown to the right
                                  offset: const Offset(100, 45),
                                  onSelected: (selected) {
                                    final internalValue = mapping[selected] ?? selected;
                                    controller1.selectStroke(internalValue);
                                  },
                                  itemBuilder: (context) => mapping.keys
                                      .map(
                                        (key) => PopupMenuItem(
                                      value: key,
                                      child: Text(key),
                                    ),
                                  )
                                      .toList(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isDark?Color(0xff153250):Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          mappingReverse[state.stroke] ?? state.stroke,
                                          style: TextStyle(
                                            fontSize: 16.sp,

                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text:
                            AppLocalizations.of(context)!.distance,

                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,

                            ),

                            SizedBox(height: 10.h),



                            SizedBox(
                              width: double.infinity,
                              child: Consumer(builder: (context, ref, _) {
                                final state1 = ref.watch(converterProvider1);
                                final controller1 = ref.read(converterProvider1.notifier);

                                const distanceItems = ["50", "100", "150", "200", "250","500"];

                                return PopupMenuButton<String>(
                                  color: isDark?Color(0xff153250):Colors.white,
                                  onSelected: controller1.setDistance,
                                  itemBuilder: (context) => distanceItems
                                      .map(
                                        (distance) => PopupMenuItem(
                                      value: distance,
                                      child: Text(distance),
                                    ),
                                  )
                                      .toList(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isDark?Color(0xff153250):Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state1.distance,
                                          style: TextStyle(
                                            fontSize: 16.sp,

                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                        SizedBox(height: 25.h),
                      ],
                    ),





                  /// TIME INPUT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text:"Time (mm:ss or ss.ss)",

                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,

                      ),
                      SizedBox(height: 10.h,),

                      CustomTextField(
                        hintText: "mm:ss or ss.ss",
                        focusNode: timeFocusNode,
                        controller: timeController,
                        onChanged: (value) {
                          ref.read(converterProvider1.notifier).setTimeText(value);
                        },
                        suffixIcon: GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                IconPath.voiceIcon,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      )


                    ],
                  ),



                  SizedBox(height: 20.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(text:
                      'Show splits',
                      ),

                      Checkbox(
                        value: state1.showSplits,
                        onChanged: (v) =>
                            controller1.setShowSplits(v ?? false),
                        activeColor: Colors.white,
                        checkColor: const Color(0xFF1e90ff),
                      ),

                    ],
                  ),

                  /// CONVERT BUTTON

                  GestureDetector(
                    onTap: (){
                      controller1.convert();
                      ref.read(showCourseSectionConverter.notifier).state = false;
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xffc59d3f),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.calculatorSplitIcon),
                          SizedBox(width: 6.w,),
                          Text(
                            AppLocalizations.of(context)!.convertTime,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              color: AppColors.backgroundDark

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 24.h,),

            state1.output.isEmpty?SizedBox():Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: isDark?Color(0xff0C3156):Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1,color:Color (0xff2DA8F0)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black12,
                  )
                ],
              ),

              child: SingleChildScrollView(
                child: Text(
                  state1.output,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),

            state1.output.isEmpty?SizedBox():Column(
              children: [
                SizedBox(height: 24.h,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xff234B6E),
                            side: BorderSide(color: Color(0xff234B6E))
                        ),
                        onPressed: () {
                          controller1.reset();
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(IconPath.clearIcon),
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
                        onPressed: () => printTextDoc(
                          title: 'Swim Time Converter',
                          body: state1.output.isEmpty ? 'No output yet.' : state1.output,
                        ),
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

          ],
        ),
      ),
    );
  }
}