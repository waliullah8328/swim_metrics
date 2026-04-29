import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swim_metrics/core/common/widgets/custom_text.dart';
import 'package:swim_metrics/core/utils/constants/app_colors.dart';


import 'package:swim_metrics/core/utils/constants/app_sizer.dart';
import 'package:swim_metrics/l10n/app_localizations.dart';


import '../../../../../config/route/routes_name.dart';
import '../../../../../core/common/widgets/new_custon_widgets/custom_screen_back_ground.dart';
import '../../../../../core/services/token_storage.dart';
import '../../../../../core/utils/constants/image_path.dart';




class SplashScreenTwo extends ConsumerStatefulWidget {
  const SplashScreenTwo({super.key});

  @override
  ConsumerState<SplashScreenTwo> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreenTwo> {

  //late final AuthenticationRepository _authService;

  @override
  void initState() {
    super.initState();
    //_authService = AuthenticationRepository();
    _navigateUser();
  }

  Future<void> _navigateUser() async {
    await Future.delayed(const Duration(seconds: 2));

    final isOnBoarding = TokenStorage.hasSeenOnboarding();
    debugPrint("Is Onboarding value : $isOnBoarding");

    final isLogin= TokenStorage.hasSeenLogin();
    debugPrint("Is Login value : $isLogin");
    if (!mounted) return;


    if(TokenStorage.hasSeenOnboarding()){

      if(TokenStorage.hasSeenLogin()){
        context.go(RouteNames.homeNavBarScreen);

      }else{
        context.go(RouteNames.getStartedScreen);

      }



    }else{
      context.go(RouteNames.onboardingScreen);

    }

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
           // Image.asset(ImagePath.swimmingGifLogo,width: 150.w,height: 150.h,fit: BoxFit.fitHeight,),
            CustomText(text: "${AppLocalizations.of(context)!.pleaseWait}...",fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.textWhite,)


          ],
        ),),
    );
  }
}
