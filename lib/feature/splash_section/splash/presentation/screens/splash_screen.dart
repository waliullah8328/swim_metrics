import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';
import 'package:swim_metrics/core/utils/constants/app_sizer.dart';

import '../../../../../config/route/routes_name.dart';
import '../../../../../core/common/widgets/new_custon_widgets/custom_screen_back_ground.dart';
import '../../../../../core/utils/constants/image_path.dart';




class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  //late final AuthenticationRepository _authService;

  @override
  void initState() {
    super.initState();
    //_authService = AuthenticationRepository();
    _navigateUser();
  }

  Future<void> _navigateUser() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go(RouteNames.splashScreenTwo);

    // final loggedIn = await _authService.isLoggedIn();
    //  final isOnBoarding = await TokenStorage.hasSeenOnboarding();
    //
    //  debugPrint("Is Onboarding value : $isOnBoarding");
    //  debugPrint("Is Logged In : $loggedIn");




    // if (isOnBoarding) {
    //   if (loggedIn) {
    //     Navigator.pushReplacementNamed(
    //       context,
    //       RouteNames.bottomNavScreen,
    //     );
    //   } else {
    //     Navigator.pushReplacementNamed(
    //       context,
    //       RouteNames.welcomeScreen,
    //     );
    //   }
    // } else {
    //   Navigator.pushReplacementNamed(
    //     context,
    //     RouteNames.onBoardingScreen,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScreenBackground(
        backgroundImage: ImagePath.splashLogoImage,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImagePath.appLogoImage,width: 120.w,height: 120.h,),
            SizedBox(height: 3.h,),
            CustomText(text: "Welcome to",fontSize: 21.sp,fontWeight: FontWeight.w300,color: AppColors.textGrey,),
            SizedBox(height: 4.h,),
            CustomText(text: "SwimMetrics",fontSize: 23.sp,fontWeight: FontWeight.w400,color: AppColors.textCreamyYellow,),

          ],
        ),),
    );
  }
}
