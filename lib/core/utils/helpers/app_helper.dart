import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelperFunctions {
 // Private constructor to prevent instantiation
 AppHelperFunctions._();

 /// Show a SnackBar
 static void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
   SnackBar(content: Text(message)),
  );
 }

 /// Show an Alert Dialog
 static void showAlert(BuildContext context, String title, String message) {
  showDialog(
   context: context,
   builder: (_) {
    return AlertDialog(
     title: Text(title),
     content: Text(message),
     actions: [
      TextButton(
       onPressed: () => Navigator.of(context).pop(),
       child: const Text('OK'),
      ),
     ],
    );
   },
  );
 }

 /// Navigate to another screen
 static void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
   context,
   MaterialPageRoute(builder: (_) => screen),
  );
 }

 /// Truncate long text with ellipsis
 static String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
   return text;
  } else {
   return '${text.substring(0, maxLength)}...';
  }
 }

 /// Check if app is in dark mode
 static bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
 }

 /// Screen size utilities (require explicit BuildContext)
 static Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
 }

 static double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
 }

 static double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
 }

 /// Format a DateTime into a readable string
 static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
  return DateFormat(format).format(date);
 }

 /// Remove duplicate items from a list
 static List<T> removeDuplicates<T>(List<T> list) {
  return list.toSet().toList();
 }

 /// Wrap widgets into rows of given size
 static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
  final wrappedList = <Widget>[];
  for (var i = 0; i < widgets.length; i += rowSize) {
   final rowChildren = widgets.sublist(
    i,
    i + rowSize > widgets.length ? widgets.length : i + rowSize,
   );
   wrappedList.add(Row(children: rowChildren));
  }
  return wrappedList;
 }
}
