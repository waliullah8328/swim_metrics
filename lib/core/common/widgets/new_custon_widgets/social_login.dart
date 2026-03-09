import 'package:flutter/material.dart';

import '../../../../feature/auth/get_started/presentation/screens/widgets/custom_card_widget.dart';
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
        CustomCard(title: "Continue with Google",imagePath: IconPath.googleIcon,onTap: (){},isDark: isDark,isApple: false,),
        CustomCard(title: "Continue with Apple",imagePath: IconPath.appleIcon,onTap: (){},isDark: isDark,isApple: true,),
      ],
    );
  }
}