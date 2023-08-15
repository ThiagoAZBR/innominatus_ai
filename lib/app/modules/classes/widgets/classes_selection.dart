import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/loading/shimmer_cards.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/themes/app_text_styles.dart';

class ClassesSelection extends StatelessWidget {
  final ClassesController controller;
  const ClassesSelection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Escolha sua aula",
            style: AppTextStyles.interVeryBig(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Text(
              'Você consegue selecionar uma aula ao tocar em cima dela',
              style: AppTextStyles.interSmall(),
            ),
          ),
          const SizedBox(height: 32),
          RxBuilder(
            builder: (_) => controller.isClassesLoading$
                ? const ShimmerCards()
                : Column(
                    children: <Widget>[
                      for (int i = 0; i < generatedClasses.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: SelectionCard(
                            title: generatedClasses[i],
                            isSemiBold: false,
                            isCardSelected: controller.isSelectedClasses[i],
                          ),
                        )
                    ],
                  ),
          )
        ],
      ),
    );
  }

  RxList<String> get generatedClasses => controller.generatedClasses;
}
