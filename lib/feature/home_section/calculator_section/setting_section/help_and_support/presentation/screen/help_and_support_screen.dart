import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swim_metrics/core/common/widgets/new_custon_widgets/custom_primary_button.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: CustomText(
          text: "Help & Support",
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
              "Fill up the Information",

                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600
            ),
            SizedBox(height: 18.h,),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  CustomText(text:"Email",color: Color(0xff82888E),),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: emailController,
                    decoration: inputDecoration(),
                  ),

                   SizedBox(height: 16.h),

                  /// Subject
                   CustomText(text:"Subject of Problem or Suggestion",color: Color(0xff82888E),),

                  SizedBox(height: 6.h),
                  TextField(
                    controller: subjectController,
                    decoration: inputDecoration(),
                  ),

                 SizedBox(height: 16.h),
                  CustomText(text:"Problem or Suggestion",color: Color(0xff82888E),),


                 SizedBox(height: 6.h),
                  TextField(
                    controller: problemController,
                    maxLines: 5,
                    decoration: inputDecoration(),
                  ),

                  SizedBox(height: 16.h),
                  CustomText(text:"Screenshot (Optional)",color: Color(0xff82888E),),

                 SizedBox(height: 8.h),

                  GestureDetector(
                    onTap: () => pickImage(ref),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F3F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state.screenshot == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt,
                              size: 35, color: Colors.blue),
                          SizedBox(height: 8),
                          Text("Tap to add a screenshot"),
                          SizedBox(height: 4),
                          Text(
                            "JPG, PNG File Formats",
                            style: TextStyle(
                                color: Colors.blue, fontSize: 12),
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
                  CustomPrimaryButton(title: "Save Changes",onPressed: (){},)


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      hintText: "Type here",
      filled: true,
      fillColor: const Color(0xffF1F3F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}