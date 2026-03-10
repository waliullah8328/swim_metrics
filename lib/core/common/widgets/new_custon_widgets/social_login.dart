import 'package:flutter/material.dart';

import '../../../../feature/auth/get_started/presentation/screens/widgets/custom_card_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../utils/constants/icon_path.dart';

class CustomSocialLogin extends StatelessWidget {
  const CustomSocialLogin({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        CustomCard(title: AppLocalizations.of(context)!.continueWithGoogle,imagePath: IconPath.googleIcon,onTap: (){},isDark: isDark,isApple: false,),
        CustomCard(title: AppLocalizations.of(context)!.continueWithApple,imagePath: IconPath.appleIcon,onTap: (){},isDark: isDark,isApple: true,),
      ],
    );
  }
}