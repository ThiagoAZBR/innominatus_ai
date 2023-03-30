import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

import '../../../../core/text_constants/subjects_page_constants.dart';
import '../topic_card.dart';

class TopicsSelection extends StatelessWidget {
  final bool canChooseMoreThanOneTopic;
  const TopicsSelection({
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
          const SizedBox(height: 32),
          const SubjectCard(
            topic: 'Ciência de Dados',
            description: SubjectsPageConstants.loremIpsum,
          ),
          const SizedBox(height: 32),
          const SubjectCard(
            topic: 'Ciber-Segurança',
            description: SubjectsPageConstants.loremIpsum,
          ),
          const SizedBox(height: 32),
          const SubjectCard(
            topic: 'Desenvolvimento de Software',
            description: SubjectsPageConstants.loremIpsum,
          ),
        ],
      ),
    );
  }
}
