import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:innominatus_ai/app/modules/premium/controllers/premium_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/app_button/app_button.dart';

import '../../shared/app_constants/app_assets.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
import '../../shared/widgets/app_scaffold/app_scaffold.dart';

class PremiumPage extends StatelessWidget {
  final PremiumController premiumController;

  const PremiumPage({
    Key? key,
    required this.premiumController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
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
            'Depois, pague somente R\$ 21,90/mês.\nCancele quando quiser',
            style: AppTextStyles.interSmall(),
            textAlign: TextAlign.center,
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AppButton(onTap: () {}),
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
                      'Termos de Uso',
                      style: AppTextStyles.interTiny(
                        textDecoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ' - ',
                      style: AppTextStyles.interTiny(),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Política de Privacidade',
                      style: AppTextStyles.interTiny(
                        textDecoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
