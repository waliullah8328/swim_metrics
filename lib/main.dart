import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/local_storage_service.dart';



Future<void> main() async {
  //await LocalStorage.init();
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: const MyApp()));
}



