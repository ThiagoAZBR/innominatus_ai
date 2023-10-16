import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:innominatus_ai/app/shared/localDB/localdb_constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/localDB/localdb.dart';

class PremiumController {
  Offering? offering;
  final RxNotifier _isPremiumLoading = RxNotifier(true);

  Future<Offering?> recoverOffer() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      isPremiumLoading = false;
      return current;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> makePurchase(Package package) async {
    try {
      CustomerInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.active.containsKey('Premium')) {
        GetIt.I.get<PrefsImpl>().put(LocalDBConstants.hasPremiumPlan, true);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {}
      return false;
    }
  }

  // Getters and Setters
  bool get isPremiumLoading => _isPremiumLoading.value;
  set isPremiumLoading(bool value) => _isPremiumLoading.value = value;
}
