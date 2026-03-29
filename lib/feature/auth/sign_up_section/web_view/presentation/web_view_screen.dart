// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class WebViewScreen extends StatefulWidget {
//   final String url; // ✅ class variable
//
//   const WebViewScreen({super.key, required this.url});
//
//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController _controller;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (_) {
//             setState(() => isLoading = true);
//           },
//           onPageFinished: (_) {
//             setState(() => isLoading = false);
//           },
//           onNavigationRequest: (request) {
//             // Optional: detect success/cancel
//             if (request.url.contains("success")) {
//               Navigator.pop(context, true);
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url)); // ✅ using class variable
//   }
//
//   Future<bool> _onWillPop() async {
//     if (await _controller.canGoBack()) {
//       _controller.goBack();
//       return false;
//     }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Payment"),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () => _controller.reload(),
//             ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             WebViewWidget(controller: _controller),
//             if (isLoading)
//               const Center(
//                 child: CircularProgressIndicator(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }