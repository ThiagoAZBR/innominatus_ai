import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/core/text_constants/subjects_page_constants.dart';
import 'package:innominatus_ai/app/modules/subjects/widgets/topic_card.dart';

import '../../../../shared/themes/app_text_styles.dart';

class StudyAreasSelection extends StatelessWidget {
  const StudyAreasSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Escolha um tema',
              style: AppTextStyles.interBig(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            const SubjectCard(
              topic: 'Tecnologia',
              description: SubjectsPageConstants.loremIpsum,
            ),
            const SizedBox(height: 32),
            const SubjectCard(
              topic: 'Design',
              description: SubjectsPageConstants.loremIpsum,
            ),
            const SizedBox(height: 32),
            const SubjectCard(
              topic: 'Psicologia',
              description: SubjectsPageConstants.loremIpsum,
            ),
          ],
        ),
      ),
    );
  }
}
