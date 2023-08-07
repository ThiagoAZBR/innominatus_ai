import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/loading/shimmer_cards.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../shared/themes/app_text_styles.dart';

class ClassesSelection extends StatelessWidget {
  final ClassesController classesController;
  const ClassesSelection({super.key, required this.classesController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Escolha sua primeira aula",
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
          builder: (_) => classesController.isClassesLoading$
              ? const ShimmerCards()
              : const Text('text'),
        )
      ],
    );
  }
}
