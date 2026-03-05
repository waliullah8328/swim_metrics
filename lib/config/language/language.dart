
import 'package:flutter_riverpod/legacy.dart';

enum Language{
  english(flag: '🇺🇸', name: 'English', code: 'en'),
  hindi(flag: '🇮🇳', name: 'Hindi', code: 'hi'),
  korea(flag: '🇰🇷', name: 'Korea', code: 'ko');


  const Language({required this.flag, required this.name,required this.code});

  final String flag;
  final String name;
  final String code;
}

final languageProvider = StateProvider<Language>((ref) => Language.english);
