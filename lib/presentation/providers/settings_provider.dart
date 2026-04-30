import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _removeAdsKey = 'remove_ads';

final removeAdsProvider = StateNotifierProvider<RemoveAdsNotifier, bool>(
  (ref) => RemoveAdsNotifier(),
);

class RemoveAdsNotifier extends StateNotifier<bool> {
  RemoveAdsNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    state = preferences.getBool(_removeAdsKey) ?? false;
  }

  Future<void> setRemoveAds(bool value) async {
    state = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_removeAdsKey, value);
  }

  Future<bool> purchaseRemoveAds() async {
    await Future.delayed(const Duration(seconds: 1));
    await setRemoveAds(true);
    return true;
  }

  void restorePurchases() {
    // Placeholder for restoring purchases
    // In production, this would verify previous purchases
  }
}

final inAppPurchaseProvider = Provider<InAppPurchase>((ref) {
  return InAppPurchase.instance;
});
