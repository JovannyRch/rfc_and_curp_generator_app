import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rfc_and_curp_helper/core/ads/ad_unit_ids.dart';
import 'package:rfc_and_curp_helper/presentation/providers/settings_provider.dart';

final adControllerProvider = Provider<AdController>((ref) {
  final controller = AdController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

class AdController {
  AdController(this._ref) {
    _nextInterstitialThreshold = _randomThreshold();
    _ref.listen<bool>(removeAdsProvider, (_, isPremium) {
      if (isPremium) {
        _disposeInterstitial();
      } else {
        _loadInterstitialIfNeeded();
      }
    });
    _loadInterstitialIfNeeded();
  }

  final Ref _ref;
  final Random _random = Random();

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;
  int _calculationsSinceInterstitial = 0;
  late int _nextInterstitialThreshold;

  bool get _supportsMobileAds =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _adsEnabled =>
      _supportsMobileAds &&
      !_ref.read(removeAdsProvider) &&
      AdUnitIds.interstitial.isNotEmpty;

  Future<void> trackCalculation() async {
    if (!_adsEnabled) {
      return;
    }

    _calculationsSinceInterstitial += 1;
    if (_calculationsSinceInterstitial < _nextInterstitialThreshold) {
      _loadInterstitialIfNeeded();
      return;
    }

    if (_interstitialAd == null) {
      _loadInterstitialIfNeeded();
      return;
    }

    final ad = _interstitialAd!;
    _interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _resetInterstitialCycle();
        _loadInterstitialIfNeeded();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _resetInterstitialCycle();
        _loadInterstitialIfNeeded();
      },
    );
    await ad.show();
  }

  void dispose() {
    _disposeInterstitial();
  }

  void _loadInterstitialIfNeeded() {
    if (!_adsEnabled || _interstitialAd != null || _isLoadingInterstitial) {
      return;
    }

    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitial = false;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (_) {
          _isLoadingInterstitial = false;
        },
      ),
    );
  }

  void _disposeInterstitial() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoadingInterstitial = false;
  }

  void _resetInterstitialCycle() {
    _calculationsSinceInterstitial = 0;
    _nextInterstitialThreshold = _randomThreshold();
  }

  int _randomThreshold() => 3 + _random.nextInt(3);
}
