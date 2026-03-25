import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swim_metrics/feature/auth/login_section/login/presentation/riverpod/login_controller.dart';

import '../../../../feature/auth/get_started/presentation/screens/widgets/custom_card_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../utils/constants/icon_path.dart';

class CustomSocialLogin extends ConsumerWidget{
  const CustomSocialLogin({
    super.key,
  });


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
      Platform.isAndroid?
    Consumer(
    builder: (context, ref, child) {
      final isLoading =
      ref.watch(loginProvider.select((s) => s.isLoadingGoogle));

      return Stack(
        alignment: Alignment.center,
        children: [
          CustomCard(
            title: AppLocalizations.of(context)!.continueWithGoogle,
            imagePath: IconPath.googleIcon,
            onTap: isLoading
                ? null
                : () {
              ref
                  .read(loginProvider.notifier)
                  .loginWithGoogle(context);
            },
            isDark: isDark,
            isApple: false,
          ),
          if (isLoading)
            const CircularProgressIndicator(),
        ],
      );
    },
    )
        :
        CustomCard(title: AppLocalizations.of(context)!.continueWithApple,imagePath: IconPath.appleIcon,onTap: (){},isDark: isDark,isApple: true,),
      ],
    );
  }
}