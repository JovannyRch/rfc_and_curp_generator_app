import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const premiumLifetimeProductId = 'rfc_curp_calculator_premium_lifetime';
const _premiumEnabledKey = 'premium_enabled';

final inAppPurchaseProvider = Provider<InAppPurchase>((ref) {
  return InAppPurchase.instance;
});

final premiumControllerProvider =
    StateNotifierProvider<PremiumController, PremiumState>((ref) {
      return PremiumController(ref.watch(inAppPurchaseProvider));
    });

final removeAdsProvider = Provider<bool>((ref) {
  return ref.watch(premiumControllerProvider).isPremium;
});

class PremiumController extends StateNotifier<PremiumState> {
  PremiumController(this._inAppPurchase) : super(const PremiumState.loading()) {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) {
        state = state.copyWith(isLoading: false, errorCode: 'iapUnavailable');
      },
    );
    _initialize();
  }

  final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  Future<void> _initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final persistedPremium = preferences.getBool(_premiumEnabledKey) ?? false;

    state = state.copyWith(isPremium: persistedPremium, isLoading: true);

    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      state = state.copyWith(isLoading: false, isStoreAvailable: false);
      return;
    }

    final response = await _inAppPurchase.queryProductDetails({
      premiumLifetimeProductId,
    });

    final productDetails = response.productDetails
        .where((product) => product.id == premiumLifetimeProductId)
        .cast<ProductDetails?>()
        .firstWhere((_) => true, orElse: () => null);

    state = state.copyWith(
      isLoading: false,
      isStoreAvailable: true,
      productDetails: productDetails,
      errorCode: response.error == null ? null : 'iapUnavailable',
    );
  }

  Future<bool> purchasePremium() async {
    final product = state.productDetails;
    if (product == null) {
      state = state.copyWith(errorCode: 'premiumUnavailable');
      return false;
    }

    state = state.copyWith(isLoading: true, errorCode: null);
    final param = PurchaseParam(productDetails: product);
    final started = await _inAppPurchase.buyNonConsumable(purchaseParam: param);
    if (!started) {
      state = state.copyWith(isLoading: false, errorCode: 'purchaseFailed');
    }
    return started;
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true, errorCode: null);
    await _inAppPurchase.restorePurchases();
    state = state.copyWith(isLoading: false);
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    var hasPremium = state.isPremium;

    for (final purchase in purchases) {
      if (purchase.productID != premiumLifetimeProductId) {
        continue;
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        hasPremium = true;
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }

    if (hasPremium != state.isPremium) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_premiumEnabledKey, hasPremium);
    }

    state = state.copyWith(
      isPremium: hasPremium,
      isLoading: false,
      errorCode: null,
    );
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}

class PremiumState {
  const PremiumState({
    required this.isPremium,
    required this.isLoading,
    required this.isStoreAvailable,
    required this.productDetails,
    required this.errorCode,
  });

  const PremiumState.loading()
    : isPremium = false,
      isLoading = true,
      isStoreAvailable = false,
      productDetails = null,
      errorCode = null;

  final bool isPremium;
  final bool isLoading;
  final bool isStoreAvailable;
  final ProductDetails? productDetails;
  final String? errorCode;

  PremiumState copyWith({
    bool? isPremium,
    bool? isLoading,
    bool? isStoreAvailable,
    ProductDetails? productDetails,
    String? errorCode,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      productDetails: productDetails ?? this.productDetails,
      errorCode: errorCode,
    );
  }
}
