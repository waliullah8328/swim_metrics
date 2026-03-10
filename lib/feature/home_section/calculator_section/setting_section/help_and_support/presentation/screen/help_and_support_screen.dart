import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../riverpod/help_and_support_controller.dart';

class HelpSupportScreen extends ConsumerWidget {
  HelpSupportScreen({super.key});

  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final problemController = TextEditingController();

  Future<void> pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ref.read(helpSupportProvider.notifier).setScreenshot(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(helpSupportProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.helpAndSupport,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SvgPicture.asset(
              IconPath.backIcon,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CustomText(text:
              AppLocalizations.of(context)!.fillUpTheInformation,

                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600
            ),
            SizedBox(height: 18.h,),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark?Color(0xff1B3A5C):Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  SizedBox(height: 20.h),

                  /// Email
                  CustomText(text:AppLocalizations.of(context)!.email,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: emailController,
                    decoration: inputDecoration(isDarkMode: isDark,context: context),
                  ),

                   SizedBox(height: 16.h),

                  /// Subject
                   CustomText(text:AppLocalizations.of(context)!.subjectOfProblemOrSuggestion,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),

                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: subjectController,
                    decoration: inputDecoration(isDarkMode: isDark,context: context),
                  ),

                 SizedBox(height: 16.h),
                  CustomText(text:AppLocalizations.of(context)!.problemOrSuggestion,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),


                 SizedBox(height: 6.h),
                  TextFormField(
                    controller: problemController,
                    maxLines: 5,
                    decoration: inputDecoration(isDarkMode: isDark,context: context),
                  ),

                  SizedBox(height: 16.h),
                  CustomText(text:AppLocalizations.of(context)!.screenshotOptional,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),

                 SizedBox(height: 8.h),

                  GestureDetector(
                    onTap: () => pickImage(ref),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark?Color(0xff153250):Color(0xffF1F3F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state.screenshot == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Icon(Icons.camera_alt,
                              size: 35, color: Colors.blue),
                          SizedBox(height: 8),
                          CustomText(text: AppLocalizations.of(context)!.tapToAddAScreenshot),
                          SizedBox(height: 4),
                          CustomText(text:
                          AppLocalizations.of(context)!.jPGPNGFileFormats,

                                color: Colors.blue, fontSize: 12.sp
                          )
                        ],
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          state.screenshot!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                  CustomPrimaryButton(title: AppLocalizations.of(context)!.saveChanges,onPressed: (){},),



                ],
              ),
            ),
            SizedBox(height:
            24.h),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration({required bool isDarkMode,required context}) {
    return InputDecoration(
      hintText: AppLocalizations.of(context)!.typeHere,
      filled: true,
      fillColor: isDarkMode?Color(0xff153250): Color(0xffF1F3F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}