import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:innominatus_ai/app/modules/premium/controllers/premium_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/app_button/app_button.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/app_constants/app_assets.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      'Carregando plano de assinatura',
                      style: AppTextStyles.interMedium(),
                      textAlign: TextAlign.center,
                    )
                  ],
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
                      'Liberdade, Facilidade e Personalização',
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
                            Text(
                              'Use sem anúncios',
                              style: AppTextStyles.interMedium(),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.check, color: AppColors.secondary),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                'Tenha acesso ilimitado as suas aulas e perguntas',
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
                              'Liberdade total no seu aprendizado',
                              style: AppTextStyles.interMedium(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                  Text(
                    'Teste grátis por 1 mês',
                    style: AppTextStyles.interHuge(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Depois, pague somente ${getPrice()}/mês.\nCancele quando quiser.',
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
                      onTap: () {
                        premiumController
                            .makePurchase(premiumController.offering!.monthly!);
                      },
                      text: 'Experimente Gratuitamente',
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sua assinatura será automaticamente renovada mensalmente a não ser que cancele antes sua assinatura. Teste gratuito apenas para primeira assinatura.',
                          style: AppTextStyles.interTiny(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Política de Privacidade',
                              style: AppTextStyles.interTiny(
                                textDecoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => premiumController.restorePurchase(),
                              child: Text(
                                'Restaurar compra',
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

  PremiumController get premiumController => widget.premiumController;

  String getPrice() {
    return premiumController.offering!.monthly!.storeProduct.priceString
        .replaceAll('.', ',')
        .replaceAll('\$', '\$ ');
  }
}