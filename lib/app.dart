import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/language/language.dart';
import 'config/route/routes.dart';
import 'config/theme/theme.dart';
import 'config/theme/theme_provider.dart';
import 'core/common/widgets/new_custon_widgets/no_internet_widget.dart';
import 'core/utils/constants/app_sizer.dart';
import 'core/utils/constants/app_sizes.dart';

import 'feature/home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import 'l10n/app_localizations.dart';



class PlatformUtils {
  static bool get isIOS =>
      foundation.defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid =>
      foundation.defaultTargetPlatform == TargetPlatform.android;
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool hasConnection = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((statusList) {
      setState(() {
        hasConnection = !statusList.contains(ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final statusList = await Connectivity().checkConnectivity();
    setState(() {
      hasConnection = !statusList.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);

    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: Routes.goRouter,
          title: 'Flutter Demo',

          theme: _getLightTheme(),
          darkTheme: _getDarkTheme(),
          themeMode: themeMode,
          //home: BottomNavScreen (),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(settings.language.code),
          // builder: (context, child) {
          //   // Set global context for auth error handler
          //   //AuthErrorHandler.setGlobalContext(context);
          //   return hasConnection ? child! : const NoInternetWidget();
          // },
        );
      },
    );
  }
  ThemeData _getLightTheme() => AppTheme.lightTheme;

  ThemeData _getDarkTheme() => AppTheme.darkTheme;
}
