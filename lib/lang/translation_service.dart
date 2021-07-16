import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkplace/lang/en_US.dart';
import 'package:mkplace/lang/pt_BR.dart';


class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static final fallbackLocale = Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'pt_BR': pt_BR,
      };
}
