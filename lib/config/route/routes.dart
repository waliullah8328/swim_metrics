import 'package:go_router/go_router.dart';

import 'package:swim_metrics/config/route/routes_name.dart';


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
