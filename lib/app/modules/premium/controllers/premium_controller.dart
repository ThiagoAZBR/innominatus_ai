import 'package:flutter/services.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:innominatus_ai/app/shared/containers/premium_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rx_notifier/rx_notifier.dart';

class PremiumController {
  final AppController appController;
  Offering? offering;
  final RxNotifier _isPremiumLoading = RxNotifier(true);
  final RxNotifier _hasError = RxNotifier(false);

  PremiumController({
    required this.appController,
  });

  Future<Offering?> recoverOffer() async {
    try {
      hasError = false;
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      isPremiumLoading = false;
      return current;
    } on PlatformException {
      hasError = true;
      return null;
    }
  }

  Future<Exception?> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      return _validateIfHasPremiumPlan(customerInfo: customerInfo);
    } on PlatformException catch (e) {
      return _handleError(e);
    }
  }

  Future<Exception?> restorePurchase() async {
    try {
      startPremiumLoading();
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      return _validateIfHasPremiumPlan(
        customerInfo: customerInfo,
        isRestorePurchase: true,
      );
    } on PlatformException {
      return const UnableToValidatePremiumStatus();
    }
  }

  Exception? _validateIfHasPremiumPlan({
    required CustomerInfo customerInfo,
    isRestorePurchase = false,
  }) {
    if (!customerInfo.entitlements.active.containsKey(
      AppConstants.premiumPlan,
    )) {
      if (isRestorePurchase) {
        return const ThereIsNoPurchaseToRestore();
      }
      return const UnableToValidatePremiumStatus();
    }
    return null;
  }

  Exception _handleError(PlatformException e) {
    final errorCode = PurchasesErrorHelper.getErrorCode(e);
    if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
      return const UnableToMakeSubscriptionPurchase();
    }
    return const CancelledPurchaseByUser();
  }

  void setupPremiumPlan() {
    appController.setPageToHome();
    appController.activatePremium();
    PremiumContainer().dispose();
  }

  // Getters and Setters
  bool get isPremiumLoading => _isPremiumLoading.value;
  set isPremiumLoading(bool value) => _isPremiumLoading.value = value;

  void startPremiumLoading() => isPremiumLoading = true;
  void endPremiumLoading() => isPremiumLoading = false;

  bool get hasError => _hasError.value;
  set hasError(bool value) => _hasError.value = value;
}
