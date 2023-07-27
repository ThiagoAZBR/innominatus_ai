import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/subjects/controllers/fields_of_study_controller.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:innominatus_ai/app/shared/widgets/selection_card.dart';
import 'package:innominatus_ai/app/shared/widgets/shimmer_cards.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../../shared/themes/app_text_styles.dart';

class FieldsOfStudySelection extends StatefulWidget {
  final FieldsOfStudyController fieldsOfStudyController;
  const FieldsOfStudySelection({
    Key? key,
    required this.fieldsOfStudyController,
  }) : super(key: key);

  @override
  State<FieldsOfStudySelection> createState() => _FieldsOfStudySelectionState();
}

class _FieldsOfStudySelectionState extends State<FieldsOfStudySelection> {
  bool isCardSelected = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await widget.fieldsOfStudyController.getFieldsOfStudy(),
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
              builder: (context) =>
                  subjectsController.isFieldOfStudyPageLoading$
                      ? const ShimmerCards()
                      : Column(
                          children: [
                            for (int i = 0;
                                i < appController.fieldsOfStudy$.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: InkWell(
                                  onTap: () => setState(
                                    () => subjectsController
                                        .changeFieldOfStudySelectedCard(i),
                                  ),
                                  child: SelectionCard(
                                    title: appController.fieldsOfStudy$[i].name,
                                    description: appController
                                        .fieldsOfStudy$[i].description,
                                    isCardSelected: subjectsController
                                        .isFieldOfStudySelectedList[i],
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

  FieldsOfStudyController get subjectsController =>
      widget.fieldsOfStudyController;
  AppController get appController =>
      widget.fieldsOfStudyController.appController;
}
