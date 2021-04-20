import 'package:flutter/widgets.dart';

import 'strings/en_us.dart';
import 'strings/pt_br.dart';
import 'strings/translations.dart';

class R {
  static Translations strings = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        strings = EnUs();
        break;
      default:
        strings = PtBr();
        break;
    }
  }
}
