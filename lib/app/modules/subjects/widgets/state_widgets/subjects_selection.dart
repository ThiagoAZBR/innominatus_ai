import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/subjects_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/shimmer_cards.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../../shared/themes/app_text_styles.dart';

class SubjectsSelection extends StatefulWidget {
  final SubjectsController subjectsController;
  const SubjectsSelection({
    Key? key,
    required this.subjectsController,
  }) : super(key: key);

  @override
  State<SubjectsSelection> createState() => _SubjectsSelectionState();
}

class _SubjectsSelectionState extends State<SubjectsSelection> {
  bool isCardSelected = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await widget.subjectsController.getSubjects(),
    );
  }

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
              style: AppTextStyles.interVeryBig(
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: Text(
                'Você consegue selecionar tema ao tocar em cima dele',
                style: AppTextStyles.interSmall(),
              ),
            ),
            const SizedBox(height: 32),

            // Cards with Subjects
            RxBuilder(
              builder: (context) => subjectsController.isSubjectLoading$
                  ? const ShimmerCards()
                  : Column(
                      children: [
                        for (int i = 0; i < appController.subjects$.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: InkWell(
                              onTap: () => setState(
                                () => subjectsController
                                    .changeSubjectSelectedCard(i),
                              ),
                              child: SelectionCard(
                                title: appController.subjects$[i].subject,
                                description:
                                    appController.subjects$[i].description,
                                isCardSelected:
                                    subjectsController.isSubjectSelectedList[i],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  SubjectsController get subjectsController => widget.subjectsController;
  AppController get appController => widget.subjectsController.appController;
}
