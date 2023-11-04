import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/themes/app_color.dart';

import '../../../../shared/themes/app_text_styles.dart';

class ClassWithError extends StatelessWidget {
  final ClassController classController;
  const ClassWithError({super.key, required this.classController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Visibility(
              visible: state.isNonPremiumLimitation,
              replacement: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Ops...',
                    style: AppTextStyles.interBig(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ocorreu um problema no momento de geração de sua aula!\n\nPor favor, tente novamente.',
                    style: AppTextStyles.interMedium(),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(
                          double.infinity,
                          48,
                        ),
                      ),
                      child: Text(
                        'Voltar',
                        style: AppTextStyles.interMedium(
                          color: AppColors.link,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Ops...',
                    style:
                        AppTextStyles.interVeryBig(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Seu limite de aulas foi atingido por hoje...\n\nAssine a versão Premium do Chaos IO para receber diversos benefícios, entre eles, o fim dos limites diários de aulas!',
                    style: AppTextStyles.interMedium(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(
                            double.infinity,
                            48,
                          ),
                        ),
                        child: Text(
                          'Voltar',
                          style: AppTextStyles.interMedium(
                            color: AppColors.link,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          if (ModalRoute.of(context)!.settings.name !=
                              AppRoutes.homePage) {
                            Navigator.popAndPushNamed(
                              context,
                              AppRoutes.homePage,
                            );
                          } else {
                            classController.appController.setPageToPremium();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(
                            double.infinity,
                            48,
                          ),
                        ),
                        child: Text(
                          'Remover limites',
                          style: AppTextStyles.interMedium(
                            color: AppColors.link,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ClassWithErrorState get state => classController.state as ClassWithErrorState;
}
