import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../topic_card.dart';

class SubTopicsSelection extends StatelessWidget {
  final bool canChooseMoreThanOneTopic;
  const SubTopicsSelection({
    Key? key,
    required this.canChooseMoreThanOneTopic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            canChooseMoreThanOneTopic
                ? "Escolha até 3 tópicos"
                : "Escolha um tópico",
            style: AppTextStyles.interBig(
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: Text(
              'Você consegue selecionar um tópico ao tocar em cima dele',
              style: AppTextStyles.interSmall(),
            ),
          ),
          const SizedBox(height: 32),
          const SubjectCard(
            topic: 'Ciência de Dados',
          ),
          const SizedBox(height: 32),
          const SubjectCard(
            topic: 'Ciber-Segurança',
          ),
          const SizedBox(height: 32),
          const SubjectCard(
            topic: 'Desenvolvimento de Software',
          ),
        ],
      ),
    );
  }
}
