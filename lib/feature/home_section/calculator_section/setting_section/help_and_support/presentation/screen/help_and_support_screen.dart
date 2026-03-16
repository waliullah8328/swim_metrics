import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/core/utils/validators/app_validator.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';

import '../../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../../core/utils/constants/icon_path.dart';
import '../../riverpod/help_and_support_controller.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {

  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final problemController = TextEditingController();
  final helpAndSupportGlobalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    subjectController.dispose();
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key:helpAndSupportGlobalKey ,
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
                      validator: (value){

                        return  AppValidator.validateEmail(value,context);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value){
                        ref.read(helpSupportProvider.notifier).setEmail(value);
                      },
                      decoration: inputDecoration(isDarkMode: isDark,context: context),
                    ),

                     SizedBox(height: 16.h),

                    /// Subject
                     CustomText(text:AppLocalizations.of(context)!.subjectOfProblemOrSuggestion,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),

                    SizedBox(height: 6.h),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: subjectController,
                      validator: (value){

                        return  AppValidator.validateSubjectOfProblem(value,context);
                      },
                      onChanged: (value){
                        ref.read(helpSupportProvider.notifier).setSubjectOfProblem(value);
                      },
                      decoration: inputDecoration(isDarkMode: isDark,context: context),
                    ),

                   SizedBox(height: 16.h),
                    CustomText(text:AppLocalizations.of(context)!.problemOrSuggestion,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),


                   SizedBox(height: 6.h),
                    TextFormField(
                      controller: problemController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){

                        return  AppValidator.validateProblemOrSuggestion(value,context);
                      },
                      onChanged: (value){
                        ref.read(helpSupportProvider.notifier).setProblemOfSuggestion(value);
                      },

                      maxLines: 5,
                      decoration: inputDecoration(isDarkMode: isDark,context: context),
                    ),

                    SizedBox(height: 16.h),
                    CustomText(text:AppLocalizations.of(context)!.screenshotOptional,color: isDark?Color(0xffE3D99B):Color(0xff82888E),),

                   SizedBox(height: 8.h),

                    GestureDetector(
                      onTap: (){
                        ref.read(helpSupportProvider.notifier).pickImage(ref);
                      },
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

                    Consumer(builder: (context,ref,child){
                      final isLoading = ref.watch(helpSupportProvider.select((s)=>s.isLoading));

                      return CustomPrimaryButton(title: AppLocalizations.of(context)!.submit,
                        isLoading: isLoading,
                        onPressed: () async {
                        if(helpAndSupportGlobalKey.currentState!.validate()){
                          ref.read(helpSupportProvider.notifier).submitHelpAndSupport(context: context);

                        }






                        },);

                    }),




                  ],
                ),
              ),
              SizedBox(height:
              24.h),
            ],
          ),
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