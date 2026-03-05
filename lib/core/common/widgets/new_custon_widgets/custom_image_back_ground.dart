//
// import 'package:flutter/material.dart';
//
// /// A reusable Scaffold with a full-screen background image
// class BackgroundImageScaffold extends StatelessWidget {
//   const BackgroundImageScaffold({
//     super.key,
//     required this.body,
//     this.backgroundImage, this.floatingActionButton,
//   });
//
//   /// The main content of the screen
//   final Widget body;
//   final Widget? floatingActionButton;
//
//   /// Background image asset path
//   final String? backgroundImage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: floatingActionButton,
//       body: Stack(
//         children: [
//           // Full-screen background image
//           SizedBox.expand(
//             child:  Image.asset(
//              ImagePath.allScreenBackgroundImage  ,
//               fit: BoxFit.cover,
//             )
//                 // fallback color
//           ),
//
//           // Body content
//           body,
//         ],
//       ),
//     );
//   }
// }
