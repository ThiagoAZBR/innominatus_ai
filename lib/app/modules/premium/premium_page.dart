import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:innominatus_ai/app/modules/premium/controllers/premium_controller.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/miscellaneous/exceptions.dart';
import 'package:innominatus_ai/app/shared/widgets/app_button/app_button.dart';
import 'package:innominatus_ai/app/shared/widgets/app_dialog/app_dialog.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/app_constants/app_assets.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/utils/language_utils.dart';
import '../../shared/widgets/app_scaffold/app_scaffold.dart';

class PremiumPage extends StatefulWidget {
  final PremiumController premiumController;

  const PremiumPage({
    Key? key,
    required this.premiumController,
  }) : super(key: key);

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Premium Page',
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        premiumController.offering = await premiumController.recoverOffer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: RxBuilder(
        builder: (_) => premiumController.isPremiumLoading
            ? SizedBox(
                height: MediaQuery.sizeOf(context).height -
                    kBottomNavigationBarHeight,
                width: MediaQuery.sizeOf(context).width,
                child: Visibility(
                  visible: !premiumController.hasError,
                  replacement: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          LocalizationUtils.I(context).premiumErrorMessage,
                          style: AppTextStyles.interMedium(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        LocalizationUtils.I(context).premiumLoadingMessage,
                        style: AppTextStyles.interMedium(),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Expanded(child: SizedBox()),
                  SvgPicture.asset(
                    AppAssets.chaosIOLogo,
                    width: MediaQuery.sizeOf(context).width * 0.46,
                    colorFilter: const ColorFilter.mode(
                      AppColors.link,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    'Chaos IO Premium',
                    style: AppTextStyles.interTiny(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                    ),
                    child: Text(
                      LocalizationUtils.I(context)
                          .premiumFreedomEaseCustomization,
                      style: AppTextStyles.interVeryBig(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.check, color: AppColors.secondary),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                LocalizationUtils.I(context)
                                    .premiumFirstBenefit,
                                style: AppTextStyles.interMedium(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.check, color: AppColors.secondary),
                            const SizedBox(width: 16),
                            Text(
                              LocalizationUtils.I(context).premiumSecondBenefit,
                              style: AppTextStyles.interMedium(),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.check, color: AppColors.secondary),
                            const SizedBox(width: 16),
                            Text(
                              LocalizationUtils.I(context).premiumThirdBenefit,
                              style: AppTextStyles.interMedium(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                  Text(
                    LocalizationUtils.I(context).premiumTryFree,
                    style: AppTextStyles.interHuge(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocalizationUtils.I(context)
                        .premiumAfterPayJustPriceCancelWhenYouWant(getPrice()),
                    style: AppTextStyles.interSmall(),
                    textAlign: TextAlign.center,
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: AppButton(
                      height: 48,
                      onTap: () {
                        FirebaseAnalytics.instance.logBeginCheckout(
                          currency: getPrice(),
                        );
                        premiumController
                            .makePurchase(premiumController.offering!.monthly!)
                            .then(
                              (error) =>
                                  _handleAfterPurchaseResult(context, error),
                            );
                      },
                      text: LocalizationUtils.I(context).premiumTryFree,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: <Widget>[
                        Text(
                          LocalizationUtils.I(context)
                              .premiumBureaucraticMessage,
                          style: AppTextStyles.interTiny(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              LocalizationUtils.I(context).premiumPrivacyPolice,
                              style: AppTextStyles.interTiny(
                                textDecoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => premiumController
                                  .restorePurchase()
                                  .then((error) => _handleAfterPurchaseResult(
                                        context,
                                        error,
                                      )),
                              child: Text(
                                LocalizationUtils.I(context)
                                    .premiumRestorePurchase,
                                style: AppTextStyles.interTiny(
                                  textDecoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
      ),
    );
  }

  void _handleAfterPurchaseResult(BuildContext context, Exception? error) {
    premiumController.endPremiumLoading();
    if (error != null) {
      if (error is CancelledPurchaseByUser) {
        return;
      }
      showDialog(
        context: context,
        builder: (_) => AppDialog(
          content: getMessageError(error),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: LocalizationUtils.I(context).dialogCongratsPremiumPlan,
        content:
            LocalizationUtils.I(context).dialogCongratsPremiumPlanDescription,
      ),
    ).then((_) => premiumController.setupPremiumPlan());
  }

  String getMessageError(Exception exception) {
    if (exception is UnableToValidatePremiumStatus) {
      return LocalizationUtils.I(context).dialogUnableToValidatePremiumStatus;
    } else if (exception is ThereIsNoPurchaseToRestore) {
      return LocalizationUtils.I(context).dialogThereIsNoPurchaseToRestore;
    } else {
      return LocalizationUtils.I(context)
          .dialogUnableToMakeSubscriptionPurchase;
    }
  }

  PremiumController get premiumController => widget.premiumController;
  AppController get appController => widget.premiumController.appController;

  String getPrice() {
    final price = premiumController.offering!.monthly!.storeProduct.priceString;

    if (appController.languageCode == LanguageConstants.portuguese) {
      return price.replaceAll('.', ',');
    }

    return price;
  }
}
