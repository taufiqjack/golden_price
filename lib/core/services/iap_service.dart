import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPService {
  static const String _premiumProductId = 'golden_price_premium';
  static const String _isPremiumKey = 'is_premium';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isPremium = false;
  List<ProductDetails> _products = [];

  bool get isAvailable => _isAvailable;
  bool get isPremium => _isPremium;
  List<ProductDetails> get products => _products;

  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  Future<void> initialize() async {
    // Check if IAP is available
    _isAvailable = await _iap.isAvailable();

    if (!_isAvailable) {
      debugPrint('In-app purchase not available');
      return;
    }

    // Check premium status from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_isPremiumKey) ?? false;

    // Configure platform-specific settings
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    }

    // Listen to purchase updates
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );

    // Load products
    await loadProducts();
  }

  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    final Set<String> productIds = {_premiumProductId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    if (response.error != null) {
      debugPrint('IAP Error: ${response.error}');
      return;
    }

    _products = response.productDetails;
    debugPrint('Products loaded: ${_products.length}');
  }

  Future<bool> purchasePremium(ProductDetails productDetails) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          debugPrint('Purchase pending');
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndDeliverProduct(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _handleError(purchaseDetails.error!);
          await _iap.completePurchase(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          debugPrint('Purchase canceled');
          await _iap.completePurchase(purchaseDetails);
          break;
      }
    }
  }

  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    // Verify purchase with your backend if needed
    // For now, we'll mark as premium locally

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumKey, true);
    _isPremium = true;

    debugPrint('Purchase successful: ${purchaseDetails.productID}');

    await _iap.completePurchase(purchaseDetails);
  }

  void _handleError(IAPError error) {
    debugPrint('IAP Error: ${error.code} - ${error.message}');
  }

  void _updateStreamOnDone() {
    _subscription?.cancel();
  }

  static void _updateStreamOnError(dynamic error) {
    debugPrint('Purchase stream error: $error');
  }

  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('Restore error: $e');
    }
  }

  Future<void> dispose() async {
    _subscription?.cancel();
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
  }

  ProductDetails? getPremiumProduct() {
    return _products.isNotEmpty ? _products.first : null;
  }
}

class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
