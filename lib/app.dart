import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/route/routes.dart';
import 'config/theme/theme.dart';
import 'config/theme/theme_provider.dart' hide themeModeProvider;
import 'core/common/widgets/new_custon_widgets/no_internet_widget.dart';
import 'core/utils/constants/app_sizer.dart';
import 'core/utils/constants/app_sizes.dart';

import 'feature/home_section/calculator_section/setting_section/settings/riverpod/setting_controller.dart';
import 'l10n/app_localizations.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((statusList) {
      if (mounted) {
        setState(() {
          hasConnection = !statusList.contains(ConnectivityResult.none);
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final statusList = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        hasConnection = !statusList.contains(ConnectivityResult.none);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);

    // 1. Watch the reactive theme provider
    final themeMode = ref.watch(themeModeProvider);

    // 2. Watch ONLY the language code to avoid unnecessary rebuilds
    final langCode = ref.watch(settingsProvider.select((s) => s.language.code));

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: Routes.goRouter,
          title: 'SwimMetrics',

          // Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode, // This now responds to the switch!

          // Localization Configuration
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(langCode),

          // builder: (context, child) {
          //   //return hasConnection ? child! : const NoInternetWidget();
          // },
        );
      },
    );
  }
}