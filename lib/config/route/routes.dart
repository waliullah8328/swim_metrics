import 'package:go_router/go_router.dart';

import 'package:swim_metrics/config/route/routes_name.dart';
import 'package:swim_metrics/feature/auth/get_started/presentation/screens/get_started_screen.dart';
import 'package:swim_metrics/feature/auth/sign_up_section/verify_email/presentation/screens/verify_email_screen.dart';


import '../../feature/auth/login_section/login/presentation/screens/login_screen.dart';
import '../../feature/auth/sign_up_section/sign_up/presentation/screens/sign_up_screen.dart';
import '../../feature/auth/sign_up_section/verify_email_success/presentation/screens/verify_email_success.dart';
import '../../feature/on_boarding/presentation/screens/on_boarding_screen.dart';
import '../../feature/splash_section/splash/presentation/screens/splash_screen.dart';

import '../../feature/splash_section/splash2/presentation/screens/splash_screen_two.dart';



class Routes {
  static final GoRouter goRouter = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RouteNames.splashScreen,
    routes: [
      GoRoute(
        path: RouteNames.splashScreen,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.splashScreenTwo,
        builder: (context, state) => SplashScreenTwo(),
      ),
      GoRoute(
        path: RouteNames.onboardingScreen,
        builder: (context, state) => OnboardingScreen(),
      ),

      GoRoute(
        path: RouteNames.getStartedScreen,
        builder: (context, state) => GetStartedScreen(),
      ),
      GoRoute(
        path: RouteNames.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signUpScreen,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: "${RouteNames.verifyEmailScreen}/:email",
        builder: (context, state) {
          String email = state.pathParameters['email']??'';
          return VerifyEmailScreen(email: email,);
  } ,
      ),

      GoRoute(
        path: "${RouteNames.verifyEmailSuccessScreen}/:title/:subTitle/:isSignUp",
        builder: (context, state) {
          String title = state.pathParameters['title']??'';
          String subTitle = state.pathParameters['subTitle']??'';
          String isSignUp = state.pathParameters['isSignUp']??'';
          return VerifyEmailSuccess (title: title, subTitle: subTitle,isSignUp: isSignUp,);
        } ,
      ),

      // GoRoute(
      //   path: "${RouteNames.resetPasswordScreen}/:email/:otp",
      //   builder: (context, state) {
      //     String email = state.pathParameters['email']??'';
      //     String otp = state.pathParameters['otp']??'';
      //     return ResetPasswordScreen(email: email, otp: otp,);
      //   },
      // ),
    ],
  );
}
