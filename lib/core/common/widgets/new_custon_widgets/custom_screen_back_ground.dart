import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomScreenBackground extends StatelessWidget {
  final String backgroundImage;
  final Widget child;
  final bool? isSvg;

  const CustomScreenBackground({
    super.key,
    required this.backgroundImage,
    required this.child,
    this.isSvg = true
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        /// Background Image
        isSvg == true?SvgPicture.asset(
          backgroundImage,
          fit: BoxFit.cover,
        ): Image.asset(backgroundImage,
          fit: BoxFit.cover,),

        /// Content On Top
        child,
      ],
    );
  }
}