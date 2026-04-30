import 'package:flutter/foundation.dart';

class AdUnitIds {
  static String get banner {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'ca-app-pub-4665787383933447/2710846864',
      TargetPlatform.iOS => 'ca-app-pub-3940256099942544/2934735716',
      _ => '',
    };
  }

  static String get interstitial {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'ca-app-pub-4665787383933447/5852015526',
      TargetPlatform.iOS => 'ca-app-pub-3940256099942544/4411468910',
      _ => '',
    };
  }
}
